//
//  OutputList.m
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "OutputList.h"

#import "PriOutput.h"
#import "OutputListCell.h"

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
	// to be run on first app start? then save array and use it thereafter
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

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	OutputListCell *cell = [tableView makeViewWithIdentifier:@"entry" owner:self];
	
	PriOutput *output = [self outputs][row];
	
	[cell populateFromOutput:output];
	
	return cell;
}

- (BOOL)tableView:(NSTableView *)tableView shouldReorderColumn:(NSInteger)columnIndex toColumn:(NSInteger)newColumnIndex
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	return YES;
}
- (void)tableView:(NSTableView *)tableView didDragTableColumn:(NSTableColumn *)tableColumn
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

}
- (BOOL)tableView:(NSTableView *)aTableView
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView
				validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row
	   proposedDropOperation:(NSTableViewDropOperation)operation
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	// doesn't work, maybe play later
	//NSPasteboardItem *pboardItem = [[NSPasteboardItem alloc] init];
	//[pboardItem setString:@"test" forType:NSPasteboardTypeString];
	//[pboard writeObjects:@[pboardItem]];
	
	return YES;
}


@end
