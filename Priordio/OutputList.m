//
//  OutputList.m
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "OutputList.h"

#import "PriOutput.h"

#import "PriAudioDataSource.h"
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

-(void)reload
{
	// refresh our outputs array from current audioSystem data
	
	NSMutableArray *tmp = [NSMutableArray new];
	
	[[[self audioSystem] devices] enumerateObjectsUsingBlock:^(PriAudioDevice *device, NSUInteger idx, BOOL *stop) {
		
		[[device dataSources] enumerateObjectsUsingBlock:^(PriAudioDataSource *dataSource, NSUInteger idx, BOOL *stop) {
			[tmp addObject:dataSource];
		}];
		
	}];
	
	[self setOutputs:tmp];
	
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
	//PriOutput *output = [self outputs][rowIndex];
	
	PriAudioDataSource *ds = [self outputs][rowIndex];

	if ([[aTableColumn identifier] isEqualToString:@"name"])
	{
		return [ds name];
	}
	
	// type
	return [PriAudioDevice transportTypeAsName:[[ds device] transportType]];
}


@end
