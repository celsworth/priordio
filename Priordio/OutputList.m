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


#import "NSMutableArray+MoveObject.h"

/*
 each row in our priorities table is a PriOutput
 which is actually a PriAudioDevice+PriAudioDataSource combination.
 
 and if an AudioDevice has more than one DataSource (AirPlay, generally?)
 it may appear more than once with different targets to choose.
 */

#define BasicTableViewDragAndDropDataType @"foobar"

@implementation OutputList

-(id)init
{
	if (self = [super init])
	{
		_outputs = [NSMutableArray new];
	}
	
	// this doesn't work yet because the view isn't loaded. not sure where to put it, it's in -reload for now
	//[[self outputListTableView] registerForDraggedTypes:[NSArray arrayWithObject:BasicTableViewDragAndDropDataType]];
	
	/*
	 * This doesn't belong here, OutputList shouldn't care about the audioSystem; we'll tell OutputList
	 * when things change instead
	[[NSNotificationCenter defaultCenter] addObserverForName:kPriAudioSystemNotificationDeviceDefaultChanged
													  object:[self audioSystem]
													   queue:[NSOperationQueue mainQueue]
												  usingBlock:^(NSNotification *note) {
													  [self reload];
												  }];

	[[NSNotificationCenter defaultCenter] addObserverForName:kPriAudioSystemNotificationDeviceAddedOrRemoved
													  object:[self audioSystem]
													   queue:[NSOperationQueue mainQueue]
												  usingBlock:^(NSNotification *note) {
													  [self reload];
												  }];
	
	 */
	
	return self;
}


-(void)reload
{
	// a little excessive :)
	[[self outputListTableView] registerForDraggedTypes:[NSArray arrayWithObject:BasicTableViewDragAndDropDataType]];
	
	[[self outputListTableView] reloadData];
}


#pragma mark - NSTableView DataSource & Delegate
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

- (BOOL)tableView:(NSTableView *)aTableView
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	NSPasteboard *pboard = [info draggingPasteboard];
	NSData *data = [pboard dataForType:BasicTableViewDragAndDropDataType];
	
	NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	// this is just so the block can mess with the destination row, see below
	__block NSInteger dRow;
	
	// rowIndexes have been moved to row. we only permit one row moving at a time for now
	// but if we ever support more, this will probably need updating
	[rowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		
		dRow = row;
		
		// when moving a row down, decrement the target by one
		// this changes dragging behaviour to something more like the user would expect
		// try it with and without this to see what I mean..
		if (dRow > idx) dRow -= 1;
		
		NSLog(@"moving row %lu to %ld", (unsigned long)idx, (long)dRow);
		
		[[self outputs] moveObjectAtIndex:idx toIndex:dRow];
	}];
	
	// redraw table
	// TODO: animation?
	[self reload];
	
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView
				validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row
	   proposedDropOperation:(NSTableViewDropOperation)operation
{
	//NSLog(@"%s", __PRETTY_FUNCTION__);
	
	return NSTableViewDropAbove == operation;
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:BasicTableViewDragAndDropDataType] owner:self];
    [pboard setData:data forType:BasicTableViewDragAndDropDataType];
    return YES;
}


@end
