//
//  PriAudioSystem.m
//  Priordio
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "PriAudioSystem.h"

#import "CoreAudio/CoreAudio.h"


@implementation PriAudioSystem

-(id)init
{
	if (self = [super init])
	{
		_devices = [PriAudioSystem enumerateDevices];
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

+(NSArray *)enumerateDevices
{
	// return an array of all audio devices in the system
	
	NSMutableArray *tmp = [NSMutableArray new];
	
	UInt32 propSize;
	
	// get number of devices first
	AudioObjectPropertyAddress addr = {
		kAudioHardwarePropertyDevices,
		kAudioObjectPropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	OSStatus ret = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &addr, 0, NULL, &propSize);
	if (ret)
	{
		NSLog(@"%s kAudioHardwarePropertyDevices/size ret=%d", __PRETTY_FUNCTION__, ret);
		return tmp;
	}
	
	// allocate space for those devices
	UInt32 numDevices = propSize / sizeof(AudioDeviceID);
	AudioDeviceID *deviceList = (AudioDeviceID *)calloc(numDevices, sizeof(AudioDeviceID));
		
	// fetch device info
	ret = AudioObjectGetPropertyData(kAudioObjectSystemObject, &addr, 0, NULL, &propSize, deviceList);
	if (ret)
	{
		NSLog(@"%s kAudioHardwarePropertyDevices ret=%d", __PRETTY_FUNCTION__, ret);
		goto out;
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
			NSLog(@"SKIPPING %@ BECAUSE OUTPUTCHANNELCOUNT==0", [dev name]);
		}
	}
	
	out:
	free(deviceList);
	
	//return tmp;
	return [NSArray arrayWithArray:tmp];
}

-(void)setupDevicesNotification
{
	// testing..
	AudioObjectPropertyAddress addr = {
		kAudioHardwarePropertyDevices,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};
	
	AudioObjectPropertyListenerBlock b = ^(UInt32 inNumberAddresses,
										   const AudioObjectPropertyAddress *inAddresses)
	{
		NSLog(@"an audio device was added/removed?");
		
		
	};
	
	OSStatus ret = AudioObjectAddPropertyListenerBlock(kAudioObjectSystemObject, &addr,
													   dispatch_get_main_queue(), b);
	
	
}

-(void)setupDefaultChangeNotification
{
	// testing..
	AudioObjectPropertyAddress addr = {
		kAudioHardwarePropertyDefaultOutputDevice,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};
	
	AudioObjectPropertyListenerBlock b = ^(UInt32 inNumberAddresses,
										   const AudioObjectPropertyAddress *inAddresses)
	{
		NSLog(@"default output changed?");
		
		
	};
	
	OSStatus ret = AudioObjectAddPropertyListenerBlock(kAudioObjectSystemObject, &addr,
													   dispatch_get_main_queue(), b);
	
	

	
}

@end
