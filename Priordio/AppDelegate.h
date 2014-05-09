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

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

// our OutputList instance is created in the nib, so we can assign outlets to it
@property (nonatomic, weak) IBOutlet OutputList *outputList;

@property (nonatomic, weak) IBOutlet NSButton *setDefaultButton;

@property (nonatomic, retain) PriAudioSystem *audioSystem;

-(IBAction)setDefaultButtonPressed:(id)sender;

@end
