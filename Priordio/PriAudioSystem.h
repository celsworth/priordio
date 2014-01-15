//
//  PriAudioSystem.h
//  Priordio
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreAudio/CoreAudio.h"

#import "PriAudioDevice.h"


#define kPriAudioSystemNotificationDeviceAddedOrRemoved @"kPriAudioSystemNotificationDeviceAddedOrRemoved"
#define kPriAudioSystemNotificationDeviceDefaultChanged @"kPriAudioSystemNotificationDeviceDefaultChanged"


@class PriAudioDevice; // err not sure why we need this when we have the #import above, investigate
@interface PriAudioSystem : NSObject

@property (nonatomic, retain) NSArray *devices;

+(NSString *)osError:(UInt32)err;

+(NSArray *)enumerateDevices;

-(void)setupDevicesNotification;
-(void)setupDefaultChangeNotification;

-(PriAudioDevice *)findDevice:(NSString *)deviceUID;
-(PriAudioDataSource *)findDevice:(NSString *)deviceUID dataSource:(NSString *)dataSourceName;

@end
