//
//  CaeAudioDevice.m
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "CaeAudioDevice.h"

#import "CaeAudioSystem.h"
#import "CaeAudioDataSource.h"

@implementation CaeAudioDevice

-(id)initWithDevice:(AudioDeviceID)device
{
	NSLog(@"init with device=%d", device);
	if (self = [super init])
	{
		_device = device;
		
		_dataSources = [self enumerateDataSources];

		[self setupNotifications];
	}
	
	return self;
}

-(id)initWithDefaultDevice
{
	if (self = [self initWithDevice:[CaeAudioDevice defaultAudioDevice]])
	{
		NSLog(@"setup for default %@ done", [self name]);
	}
	
	return self;
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"%@ (%d output channels) (%@)",
			[self name], [self outputChannelCount], [[self dataSources] componentsJoinedByString:@", "]];
}

-(AudioDeviceID)deviceID
{
	return _device;
}

+(AudioDeviceID)defaultAudioDevice
{
	const AudioObjectPropertyAddress defaultAddr = {
		kAudioHardwarePropertyDefaultOutputDevice,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};
	AudioDeviceID defaultDevice = 0;
	UInt32 defaultSize = sizeof(AudioDeviceID);
	OSStatus ret = AudioObjectGetPropertyData(kAudioObjectSystemObject, &defaultAddr, 0, NULL, &defaultSize, &defaultDevice);
	if (ret)
		abort(); // FIXME
	
	return defaultDevice;
}

-(void)setupNotifications
{
	AudioObjectPropertyAddress addr = {
		kAudioDevicePropertyDataSource,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	AudioObjectPropertyListenerBlock b = ^(UInt32 inNumberAddresses,
						const AudioObjectPropertyAddress *inAddresses)
	{
		// triggered when a datasource changes
		
		NSLog(@"block fired");
		
		UInt32 dataSourceId = [self currentDataSource];
		
		if (dataSourceId == kAudioDeviceOutputSpeaker) {
			// Recognized as internal speakers
			NSLog(@"speakers?");
		} else if (dataSourceId == kAudioDeviceOutputHeadphone) {
			// Recognized as headphones
			NSLog(@"headphones?");
		}

		// TODO: post NSNotification?
		
	};
	
	OSStatus ret = AudioObjectAddPropertyListenerBlock(_device, &addr,
													   dispatch_get_main_queue(), b);
	if (ret)
	{
		abort(); // FIXME
	}
}

-(NSString *)name
{
	AudioObjectPropertyAddress addr = {
		kAudioObjectPropertyName,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};
	
	CFStringRef deviceName;
	UInt32 propSize = sizeof(CFStringRef);
	OSStatus ret = AudioObjectGetPropertyData(_device, &addr, 0, NULL, &propSize, &deviceName);
	if (ret)
	{
		NSLog(@"%s kAudioObjectPropertyName ret=%d", __PRETTY_FUNCTION__, ret);
		return NULL;
	}

	return (__bridge NSString *)deviceName;
}

-(UInt32)outputChannelCount
{
	AudioObjectPropertyAddress addr = {
		kAudioDevicePropertyStreamConfiguration,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	UInt32 size = 0;
	OSStatus ret = AudioObjectGetPropertyDataSize(_device, &addr, 0, NULL, &size);
	if (ret)
	{
		NSLog(@"%s kAudioDevicePropertyStreamConfiguration/size fail?", __PRETTY_FUNCTION__);
		return 0;
	}
	
	AudioBufferList *tmp = calloc(size, sizeof(AudioBufferList *));
	UInt32 tmpSize = size * sizeof(AudioBufferList *);
		
	ret = AudioObjectGetPropertyData(_device, &addr, 0, NULL, &tmpSize, tmp);
	if (ret)
	{
		NSLog(@"%s kAudioObjectPropertyName ret=%d", __PRETTY_FUNCTION__, ret);
		return 0;
	}
	
	UInt32 outputChannelCount = 0;
	for(int j = 0 ; j<tmp->mNumberBuffers ; j++)
		outputChannelCount += tmp->mBuffers[j].mNumberChannels;
	
	return outputChannelCount;
}

-(UInt32)currentDataSource
{
	AudioObjectPropertyAddress addr = {
		kAudioDevicePropertyDataSource,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	UInt32 dataSourceId = 0;
	UInt32 dataSourceIdSize = sizeof(UInt32);
	
	OSStatus ret = AudioObjectGetPropertyData(_device, &addr, 0, NULL,
											  &dataSourceIdSize, &dataSourceId);
	if (ret)
	{
		NSLog(@"%s kAudioDevicePropertyDataSource fail?", __PRETTY_FUNCTION__);
		return 0;
	}
	return dataSourceId;
}

-(UInt32)dataSourceCount
{
	AudioObjectPropertyAddress addr = {
		kAudioDevicePropertyDataSources,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	UInt32 size = 0;
	OSStatus ret = AudioObjectGetPropertyDataSize(_device, &addr, 0, NULL, &size);
	if (ret == kAudioHardwareUnknownPropertyError)
	{
		// this just means the device doesn't support datasources, but it has one nonetheless
		return 1;
	}
	
	// any other error
	if (ret)
	{
		NSLog(@"%s %@ kAudioDevicePropertyDataSources/size ret=%@",
			  __PRETTY_FUNCTION__, self, [CaeAudioSystem osError:ret]);
		return 0;
	}
	
	return size;
}

-(NSArray *)enumerateDataSources
{
	UInt32 count = [self dataSourceCount];
	
	NSMutableArray *arr = [NSMutableArray new];
	
	if (count == 0)
		return arr;
	
	// temporary storage for the datasource results
	UInt32 *tmp = calloc(count, sizeof(UInt32));
	UInt32 tmpSize = count * sizeof(UInt32);
	
	AudioObjectPropertyAddress tmpAddr = {
		kAudioDevicePropertyDataSource,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	OSStatus ret = AudioObjectGetPropertyData(_device, &tmpAddr, 0, NULL, &tmpSize, tmp);
	if (ret == kAudioHardwareUnknownPropertyError)
	{
		// this just means the device doesn't support datasources, but it has one nonetheless
		[arr addObject:[[CaeAudioDataSource alloc] initWithDevice:self]];
		return arr;
	}

	// any other error
	if (ret)
	{
		NSLog(@"%s kAudioDevicePropertyDataSource ret=%@", __PRETTY_FUNCTION__, [CaeAudioSystem osError:ret]);
		goto out;
	}
	
	for (int i = 0; i < count; i++) {
		if (tmp[i] == 0) continue;
		
		CaeAudioDataSource *addObj = [[CaeAudioDataSource alloc] initWithDevice:self
																	 dataSource:tmp[i]];
		[arr addObject:addObj];
	}
	
	out:
	free(tmp);
	
	return [NSArray arrayWithArray:arr];
}

@end