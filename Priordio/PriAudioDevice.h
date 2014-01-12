//
//  PriAudioDevice.h
//  Priordio
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


@interface PriAudioDevice : NSObject {
}

// array of AudioOutputs
@property (nonatomic, retain) NSArray *dataSources;

@property (nonatomic, assign) AudioDeviceID device;

// saved to persistent storage so we remember between runs
//@property (nonatomic, retain) NSString *uid;


-(id)initWithDefaultDevice;
-(id)initWithDevice:(AudioDeviceID)device;

-(AudioDeviceID)deviceID;

-(NSString *)name;
-(NSString *)uid;
-(UInt32)transportType;
-(UInt32)outputChannelCount;

+(NSString *)transportTypeAsName:(UInt32)transportType;

-(UInt32)currentDataSource;
-(UInt32)dataSourceCount;
-(NSArray *)enumerateDataSources;

@end
