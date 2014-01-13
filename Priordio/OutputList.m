//
//  OutputList.m
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "OutputList.h"

#import "PriOutput.h"

/*
 each row in our priorities table is a PriOutput
 which is actually a PriAudioDevice+PriAudioDataSource combination.
 
 and if an AudioDevice has more than one DataSource (AirPlay, generally?)
 it may appear more than once with different targets to choose.
 */

@implementation OutputList

-(id)init
{
	if (self = [super init])
	{
		_outputs = [NSMutableArray new];
	}
	
	return self;
}

-(void)enumerateAudioSystem
{
	// to be run on first app start? then save it and use it thereafter
	NSMutableArray *arr = [NSMutableArray new];
	
	[[[self audioSystem] devices] enumerateObjectsUsingBlock:^(PriAudioDevice *device, NSUInteger idx, BOOL *stop) {
		
		[[device dataSources] enumerateObjectsUsingBlock:^(PriAudioDataSource *dataSource, NSUInteger idx, BOOL *stop) {
			// create a PriOutput for this
			PriOutput *entry = [[PriOutput alloc] initWithAudioSystem:[self audioSystem]];
			[entry setDeviceUID:[device uid]];
			[entry setDataSourceName:[dataSource name]];
			
			[arr addObject:entry];
		}];
		
	}];
	
	[self setOutputs:arr];
}

-(void)reload
{
	
	[[self outputListTableView] reloadData];
}


#pragma mark - NSTableView DataSource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [[self outputs] count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex
{
	PriOutput *output = [self outputs][rowIndex];
	
	PriAudioDataSource *ds = [[self audioSystem] findDevice:[output deviceUID] dataSource:[output dataSourceName]];
	
	// FIXME: ds can be nil if its a disconnected device! handle it (greyed out display?)
	
	if ([[aTableColumn identifier] isEqualToString:@"name"])
	{
		return [output name];
	}
	
	// type, we need to store this in the Output for when ds is nil?
	return [PriAudioDevice transportTypeAsName:[[ds device] transportType]];
}


@end
