//
//  PriAudioSystem.h
//  Priordio
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PriAudioDevice.h"

@interface PriAudioSystem : NSObject

@property (nonatomic, retain) NSArray *devices;

+(NSString *)osError:(UInt32)err;

+(NSArray *)enumerateDevices;

-(void)setupDevicesNotification;
-(void)setupDefaultChangeNotification;

@end
