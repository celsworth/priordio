//
//  CaeAudioSystem.h
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaeAudioSystem : NSObject

-(void)setupDevicesNotification;
-(void)setupDefaultChangeNotification;

@end
