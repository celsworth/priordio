//
//  CaeAudioDataSource.m
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

// a simple container for details about an audio output
// (a dataSource on a device)

#import "CaeAudioDataSource.h"

@implementation CaeAudioDataSource

-(id)initWithDevice:(CaeAudioDevice *)device dataSource:(UInt32)dataSource;
{
	if (self = [super init])
	{
		_device = device;
		_dataSource = dataSource;
	}
	return self;
}



-(NSString *)name
{
	AudioObjectPropertyAddress tmpSourceAddr = {
		kAudioDevicePropertyDataSourceNameForIDCFString,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	CFStringRef theAnswer = NULL;
	
	AudioValueTranslation audioValueTranslation;
	audioValueTranslation.mInputData = (void *)&_dataSource;
	audioValueTranslation.mInputDataSize = sizeof(UInt32);
	audioValueTranslation.mOutputData = (void *)&theAnswer;
	audioValueTranslation.mOutputDataSize = sizeof(CFStringRef);
	
	UInt32 audioValueTranslationSize = sizeof(audioValueTranslation);
	
	OSStatus ret = AudioObjectGetPropertyData([_device deviceID], &tmpSourceAddr, 0, NULL, &audioValueTranslationSize, &audioValueTranslation);
	if (ret)
	{
		// AudioObjectGetPropertyData failure
		return NULL;
	}
	
	//NSLog(@"datasource is %@", theAnswer);
	
	return (__bridge NSString *)theAnswer;
}

// untested, just guessing based on
// http://joris.kluivers.nl/blog/2012/07/25/per-application-airplay-in-mountain-lion/
-(void)setAsDefault
{
	AudioObjectPropertyAddress tmpAddr = {
		kAudioHardwarePropertyDefaultOutputDevice,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMaster
	};

	AudioDeviceID deviceID = [_device deviceID];
	
	AudioObjectSetPropertyData(kAudioObjectSystemObject, &tmpAddr, 0, NULL,
										sizeof(AudioDeviceID), &deviceID);

	
	tmpAddr.mSelector = kAudioDevicePropertyDataSource;
	tmpAddr.mScope = kAudioDevicePropertyScopeOutput;
	AudioObjectSetPropertyData(deviceID, &tmpAddr, 0, NULL, sizeof(UInt32), &_dataSource);
	
}

@end
