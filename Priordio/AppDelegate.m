//
//  AppDelegate.m
//  Priordio
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "AppDelegate.h"

#import "CoreAudio/CoreAudio.h"

#import "PriAudioDevice.h"
#import "PriOutput.h"

@implementation AppDelegate


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	[self setAudioSystem:[PriAudioSystem new]];
	
	[[self audioSystem] setupDevicesNotification];
	[[self audioSystem] setupDefaultChangeNotification];
	
	// outputList initialised in nib, we need to tell it about the audioSystem we've allocated
	// so it can watch for notifications, enumerate lists, etc.
	[[self outputList] setAudioSystem:[self audioSystem]];
	
	[[self outputList] enumerateAudioSystem];
	[[self outputList] reload];
	
	// debugging..
	NSLog(@"%@", [[self audioSystem] devices]);
	
	// debugging..
	PriAudioDevice *defaultDevice = [[PriAudioDevice alloc] initWithDefaultDevice];
	
	NSArray *dataSources = [defaultDevice dataSources];
	
	NSLog(@"default device has %lu datasources", [dataSources count]);
	NSLog(@"current datasource on default device is %d", [defaultDevice currentDataSource]);
	
	[dataSources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSLog(@"datasource is %@", [obj name]);
	}];
}


-(IBAction)setDefaultButtonPressed:(id)sender
{
	NSIndexSet *selectedRows = [[self.outputList outputListTableView] selectedRowIndexes];
	
	// we'll disable the button for no selection eventually
	if ([selectedRows count] == 0) return;
	
	assert([selectedRows count] == 1);
		
	NSUInteger index = [selectedRows firstIndex];
	
	// get the OutputDevice / DataSource..
	PriOutput *o = [self.outputList outputs][index];
	PriAudioDataSource *ds = [o dataSource];
	
	NSLog(@"%@", ds);
	[ds setAsDefault];
}

@end