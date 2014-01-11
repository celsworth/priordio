//
//  AppDelegate.m
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "AppDelegate.h"

#import "CoreAudio/CoreAudio.h"

#import "CaeAudioDevice.h"

@implementation AppDelegate


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	self.audioSystem = [CaeAudioSystem new];
	
	[self.audioSystem setupDevicesNotification];
	[self.audioSystem setupDefaultChangeNotification];
	
	NSLog(@"%@", [self.audioSystem devices]);
	
	
	CaeAudioDevice *defaultDevice = [[CaeAudioDevice alloc] initWithDefaultDevice];
	
	NSArray *dataSources = [defaultDevice dataSources];
	
	NSLog(@"default device has %lu datasources", [dataSources count]);
	NSLog(@"current datasource on default device is %d", [defaultDevice currentDataSource]);
	
	[dataSources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSLog(@"datasource is %@", [obj name]);
	}];
	
	[self.deviceListTableView reloadData];
}


// testing tableview stuff
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [[self.audioSystem devices] count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex
{
	CaeAudioDevice *dev = [self.audioSystem devices][rowIndex];
	
	if ([[aTableColumn identifier] isEqualToString:@"device"])
		return [dev name];
	else
		return [[[dev dataSources] lastObject] name];
}

@end
