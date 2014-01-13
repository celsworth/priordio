//
//  PriOutput.h
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PriAudioSystem.h"

@interface PriOutput : NSObject

// link to the current audioSystem instance, used to check which devices exist etc
@property (nonatomic, retain) PriAudioSystem *audioSystem;


// identifying properties
@property (nonatomic, retain) NSString *deviceUID;
@property (nonatomic, retain) NSString *dataSourceName;

// used for table display? if nil, use [datasource Name] ?
@property (nonatomic, retain) NSString *friendlyName;


-(NSString *)name;

-(BOOL)isPresent;

@end
