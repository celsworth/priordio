//
//  AppDelegate.h
//  Priordio
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PriAudioSystem.h"
#import "OutputList.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet OutputList *outputList;

@property (nonatomic, retain) PriAudioSystem *audioSystem;


@end
