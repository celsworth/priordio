//
//  PriAudioDataSource.m
//  Priordio
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

// a simple container for details about an audio output
// (a dataSource on a device)

#import "PriAudioDataSource.h"

@implementation PriAudioDataSource

-(id)initWithDevice:(PriAudioDevice *)device dataSource:(UInt32)dataSource;
{
	if (self = [super init])
	{
		_device = device;
		_dataSource = dataSource;
	}
	return self;
}
-(id)initWithDevice:(PriAudioDevice *)device;
{
	if (self = [super init])
	{
		_device = device;
	}
	return self;
}

-(NSString *)description
{
	return [self name];
}

-(NSString *)name
{
	// nil dataSource means we're not "real", we're a made up source because the device
	// reported it didn't support multiple dataSources
	if (!_dataSource)
		// so just report the device name for now
		return [_device name];
	
	AudioObjectPropertyAddress addr = {
		kAudioDevicePropertyDataSourceNameForIDCFString,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMaster
	};
	
	CFStringRef theAnswer = NULL;
	
	AudioValueTranslation avt;
	avt.mInputData = (void *)&_dataSource;
	avt.mInputDataSize = sizeof(UInt32);
	avt.mOutputData = (void *)&theAnswer;
	avt.mOutputDataSize = sizeof(CFStringRef);
	
	UInt32 avtSize = sizeof(avt);
	
	OSStatus ret = AudioObjectGetPropertyData([[self device] deviceID], &addr, 0, NULL, &avtSize, &avt);
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

	AudioDeviceID deviceID = [[self device] deviceID];
	
	OSStatus ret;
	ret = AudioObjectSetPropertyData(kAudioObjectSystemObject, &tmpAddr, 0, NULL,
										sizeof(AudioDeviceID), &deviceID);
	if (ret)
	{
		abort(); // FIXME
	}
	
	UInt32 ds = [self dataSource];
	
	tmpAddr.mSelector = kAudioDevicePropertyDataSource;
	tmpAddr.mScope = kAudioDevicePropertyScopeOutput;
	ret = AudioObjectSetPropertyData(deviceID, &tmpAddr, 0, NULL, sizeof(UInt32), &ds);
	if (ret)
	{
		abort(); // FIXME
	}

	
}

@end
