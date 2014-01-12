//
//  AppDelegate.h
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CaeAudioSystem.h"
#import "OutputList.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet OutputList *outputList;

@property (nonatomic, retain) CaeAudioSystem *audioSystem;


@property (nonatomic, weak) IBOutlet NSTableView *outputListTableView;

@end
