//
//  PriAudioSystem.m
//  Priordio
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "PriAudioSystem.h"


@implementation PriAudioSystem

-(id)init
{
	if (self = [super init])
	{
		[self enumerateDevices];
	}
	return self;
}

+(NSString *)osError:(UInt32)err
{
	switch (err) {
		case kAudioHardwareNoError:
			return @"kAudioHardwareNoError";
		case kAudioHardwareNotRunningError:
			return @"kAudioHardwareNotRunningError";
		case kAudioHardwareUnspecifiedError:
			return @"kAudioHardwareUnspecifiedError";
		case kAudioHardwareUnknownPropertyError:
			return @"kAudioHardwareUnknownPropertyError";
		case kAudioHardwareBadPropertySizeError:
			return @"kAudioHardwareBadPropertySizeError";
		case kAudioHardwareIllegalOperationError:
			return @"kAudioHardwareIllegalOperationError";
		case kAudioHardwareBadObjectError:
			return @"kAudioHardwareBadObjectError";
		case kAudioHardwareBadDeviceError:
			return @"kAudioHardwareBadDeviceError";
		case kAudioHardwareBadStreamError:
			return @"kAudioHardwareBadStreamError";
		case kAudioHardwareUnsupportedOperationError:
			return @"kAudioHardwareUnsupportedOperationError";
		case kAudioDeviceUnsupportedFormatError:
			return @"kAudioDeviceUnsupportedFormatError";
		case kAudioDevicePermissionsError:
			return @"kAudioDevicePermissionsError";
			
		default:
			return @"UNKNOWN ERROR";
	}
	
}

-(BOOL)enumerateDevices
{
	// return an array of all audio devices in the system
	
	NSMutableArray *tmp = [NSMutableArray new];
	
	UInt32 propSize;
	
	// get number of devices first
	AudioObjectPropertyAddress pa = {
		kAudioHardwarePropertyDevices,
		kAudioObjectPropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	OSStatus ret = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &pa, 0, NULL, &propSize);
	if (ret)
	{
		NSLog(@"%s kAudioHardwarePropertyDevices/size ret=%d", __PRETTY_FUNCTION__, ret);
		return NO;
	}
	
	// allocate space for those devices
	UInt32 numDevices = propSize / sizeof(AudioDeviceID);
	AudioDeviceID *deviceList = (AudioDeviceID *)calloc(numDevices, sizeof(AudioDeviceID));
	
	// fetch device info
	ret = AudioObjectGetPropertyData(kAudioObjectSystemObject, &pa, 0, NULL, &propSize, deviceList);
	if (ret)
	{
		NSLog(@"%s kAudioHardwarePropertyDevices ret=%d", __PRETTY_FUNCTION__, ret);
		free(deviceList);
		return NO;
	}
	
	// and convert to a more useful form
	for (UInt32 i = 0; i < numDevices; i++)
	{
		PriAudioDevice *dev = [[PriAudioDevice alloc] initWithDevice:deviceList[i]];
		
		// only add devices with some output channels (this gets rid of the internal mic etc)
		if ([dev outputChannelCount] > 0)
		{
			[tmp addObject:dev];
		}
		else
		{
			// debugging for now
			NSLog(@"%s SKIPPING %@ (outputChannelCount==0)", __PRETTY_FUNCTION__, [dev name]);
		}
	}
	
	free(deviceList);
	
	[self setDevices:[NSArray arrayWithArray:tmp]];
	
	return YES;
}

-(void)setupDevicesNotification
{
	// testing..
	AudioObjectPropertyAddress pa = {
		kAudioHardwarePropertyDevices,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};
	
	AudioObjectPropertyListenerBlock b = ^(UInt32 inNumberAddresses,
										   const AudioObjectPropertyAddress *inAddresses)
	{
		NSLog(@"an audio device was added/removed?");
		
		[self enumerateDevices];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kPriAudioSystemNotificationDeviceAddedOrRemoved object:self userInfo:nil];
	};
	
	OSStatus ret = AudioObjectAddPropertyListenerBlock(kAudioObjectSystemObject, &pa,
													   dispatch_get_main_queue(), b);
	
	
}

-(void)setupDefaultChangeNotification
{
	// testing..
	AudioObjectPropertyAddress pa = {
		kAudioHardwarePropertyDefaultOutputDevice,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};
	
	AudioObjectPropertyListenerBlock b = ^(UInt32 inNumberAddresses,
										   const AudioObjectPropertyAddress *inAddresses)
	{
		NSLog(@"default output changed?");
		
		[self enumerateDevices];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kPriAudioSystemNotificationDeviceDefaultChanged object:self userInfo:nil];
	};
	
	OSStatus ret = AudioObjectAddPropertyListenerBlock(kAudioObjectSystemObject, &pa,
													   dispatch_get_main_queue(), b);
	
	
}

-(PriAudioDevice *)findDevice:(NSString *)deviceUID
{
	// look for deviceUID in our current list of known objects
	
	PriAudioDevice *ret = NULL;
	
	for (PriAudioDevice *device in [self devices])
	{
		if ([[device uid] isEqualToString:deviceUID])
		{
			return device;
		}
	}
	
	return ret;
}


-(PriAudioDataSource *)findDevice:(NSString *)deviceUID dataSource:(NSString *)dataSourceName
{
	// look for deviceUID and dataSourceName in our current list of known objects
	
	// allow ret to be set inside blocks
	__block PriAudioDataSource *ret = NULL;
	
	PriAudioDevice *device = [self findDevice:deviceUID];
	if (device)
	{
		for (PriAudioDataSource *dataSource in [device dataSources])
		{
			if ([[dataSource name] isEqualToString:dataSourceName])
			{
				return dataSource;
			}
		}
	}
	
	return ret;
}


@end
