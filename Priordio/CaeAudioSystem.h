//
//  CaeAudioSystem.h
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CaeAudioDevice.h"

@interface CaeAudioSystem : NSObject

@property (nonatomic, retain) NSArray *devices;

+(NSString *)osError:(UInt32)err;

+(NSArray *)enumerateDevices;

-(void)setupDevicesNotification;
-(void)setupDefaultChangeNotification;

@end
