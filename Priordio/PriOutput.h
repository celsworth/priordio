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
// we probably don't really want this spewing over into this class
@property (nonatomic, retain) PriAudioSystem *audioSystem;

//@property (nonatomic, retain) PriAudioDataSource *dataSource;


// persistent data

// identifying properties used to lookup current devices
@property (nonatomic, retain) NSString *deviceUID;
@property (nonatomic, retain) NSString *dataSourceName;

// used for table display? if nil, use [datasource Name] ?
@property (nonatomic, retain) NSString *friendlyName;


-(id)initWithAudioSystem:(PriAudioSystem *)audioSystem;

-(PriAudioDataSource *)dataSource;

-(NSString *)name;

-(BOOL)isPresent;

@end
