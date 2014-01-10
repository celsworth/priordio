//
//  CaeAudioDevice.h
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreAudio/CoreAudio.h"

@interface CaeAudioDevice : NSObject {
	AudioDeviceID _device;
}

// array of AudioOutput
@property (nonatomic, retain) NSMutableArray *outputs;

-(id)initAsDefaultDevice;

-(AudioDeviceID)deviceID;

-(UInt32)dataSourceCount;
-(NSMutableArray *)dataSources;

@end
