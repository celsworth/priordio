//
//  CaeAudioDevice.m
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "CaeAudioDevice.h"

#import "CaeAudioDataSource.h"

@implementation CaeAudioDevice

-(id)init
{
	if (self = [super init])
	{
		_outputs = [NSMutableArray new];
	}
	return self;
}

-(id)initWithDevice:(AudioDeviceID)device
{
	if (self = [self init])
	{
		_device = device;
		
		[self setupNotifications];
	}
	
	return self;
}

-(id)initWithDefaultDevice
{
	if (self = [self init])
	{
		_device = [CaeAudioDevice defaultAudioDevice];
		
		[self setupNotifications];
	}
	
	NSLog(@"setup for %@ done", [self name]);
	
	return self;
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
+(NSArray *)audioDevices
{
	// return an array of all audio devices in the system
	
	UInt32 propSize;
	
	// get number of devices first
	AudioObjectPropertyAddress addr = {
		kAudioHardwarePropertyDevices,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};
	OSStatus ret = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &addr, 0, NULL, &propSize);
	if (ret)
	{
		NSLog(@"%s kAudioHardwarePropertyDevices/size ret=%d", __PRETTY_FUNCTION__, ret);
		return NULL;
	}
	
	UInt32 numDevices = propSize / sizeof(AudioDeviceID);
	AudioDeviceID *deviceList = (AudioDeviceID *)calloc(numDevices, sizeof(AudioDeviceID));
	
	ret = AudioObjectGetPropertyData(kAudioObjectSystemObject, &addr, 0, NULL, &propSize, deviceList);
	if (ret)
	{
		NSLog(@"%s kAudioHardwarePropertyDevices ret=%d", __PRETTY_FUNCTION__, ret);
		return NULL;
	}

	NSMutableArray *tmp = [NSMutableArray new];
	
	for (UInt32 i=0; i < numDevices; i++)
	{
		CaeAudioDevice *dev = [[CaeAudioDevice alloc] initWithDevice:deviceList[i]];
		
		[tmp addObject:dev];
	}

	return tmp;
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
		
		if (dataSourceId == 'ispk') {
			// Recognized as internal speakers
			NSLog(@"speakers?");
		} else if (dataSourceId == 'hdpn') {
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
	AudioObjectPropertyAddress tmp = {
		kAudioDevicePropertyDataSources,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	UInt32 size = 0;
	OSStatus ret = AudioObjectGetPropertyDataSize(_device, &tmp, 0, NULL, &size);
	if (ret)
	{
		NSLog(@"%s kAudioDevicePropertyDataSources fail?", __PRETTY_FUNCTION__);
		return 0;
	}
	
	return size;
}

// fix this to use the self.outputs property, build it somewhere else (init/notification?)
-(NSMutableArray *)dataSources
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
	if (ret)
	{
		NSLog(@"%s kAudioDevicePropertyDataSource fail", __PRETTY_FUNCTION__);
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
	
	return arr;
}

@end