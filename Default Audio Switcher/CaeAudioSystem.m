//
//  CaeAudioSystem.m
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "CaeAudioSystem.h"

#import "CoreAudio/CoreAudio.h"

@implementation CaeAudioSystem

-(id)init
{
	if (self = [super init])
	{
		
	}
	return self;
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
