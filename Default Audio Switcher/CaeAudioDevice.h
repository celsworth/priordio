//
//  CaeAudioDevice.h
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreAudio/CoreAudio.h"

// these aren't defined by apple for some reason, so we'll do them
enum {
	kAudioDeviceOutputSpeaker   = 'ispk',
	kAudioDeviceOutputHeadphone = 'hdpn'
	// spdif/digital?
};


@interface CaeAudioDevice : NSObject {
	AudioDeviceID _device;
}

// array of AudioOutput
@property (nonatomic, retain) NSMutableArray *outputs;

-(id)initWithDefaultDevice;
-(id)initWithDevice:(AudioDeviceID)device;

-(AudioDeviceID)deviceID;

-(UInt32)currentDataSource;

-(UInt32)dataSourceCount;
-(NSMutableArray *)dataSources;

@end
