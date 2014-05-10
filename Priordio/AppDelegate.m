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
#import "OutputList.h"

@implementation AppDelegate


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	[self setAudioSystem:[PriAudioSystem new]];
	
	[[self audioSystem] setupDevicesNotification];
	[[self audioSystem] setupDefaultChangeNotification];
	
	[[self outputList] setOutputs:[self enumerateAudioSystem]];
	[[self outputList] reload];
	
	// debugging..
	NSLog(@"%@", [[self audioSystem] devices]);
	
	// debugging..
	PriAudioDevice *defaultDevice = [[PriAudioDevice alloc] initWithDefaultDevice];
	
	NSArray *dataSources = [defaultDevice dataSources];
	
	NSLog(@"default device has %lu datasources", [dataSources count]);
	NSLog(@"current datasource on default device is %d", [defaultDevice currentDataSource]);
	
	for (PriAudioDataSource *dataSource in dataSources)
	{
		NSLog(@"datasource is %@", [dataSource name]);
	}
}

// setup list of PriOutput to show in the table
-(NSMutableArray *)enumerateAudioSystem
{
	// to be run on first app start? then save array and use it thereafter
	NSMutableArray *arr = [NSMutableArray new];
	
	for (PriAudioDevice *device in [[self audioSystem] devices])
	{
		for (PriAudioDataSource *dataSource in [device dataSources])
		{
			// create a PriOutput for this device/datasource combination
			PriOutput *entry = [[PriOutput alloc] initWithAudioSystem:[self audioSystem]];
			[entry setDeviceUID:[device uid]];
			[entry setDataSourceName:[dataSource name]];
			
			[arr addObject:entry];
		}
	}
	
	return arr;
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