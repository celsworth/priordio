//
//  OutputListCell.m
//  Priordio
//
//  Created by Chris Elsworth on 14/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "OutputListCell.h"

@implementation OutputListCell

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(void)populateFromOutput:(PriOutput *)output
{
	[self setOutput:output];
	
	[self redraw];
}

// update the views in self to match current reality of whats in self.output
-(void)redraw
{
	[[self titleTextField] setStringValue:[[self output] name]];
	
	// get fontsize of titleTextField, we're going to need it shortly
	CGFloat titleTextFontSize = [[[self titleTextField] font] pointSize];
	
	if ([[self output] isPresent])
	{
		// transport type (Built-in/USB)
		PriAudioDataSource *ds = [[self output] dataSource];
		[[self connectedTextField] setStringValue: [PriAudioDevice transportTypeAsName:[[ds device] transportType]]];
		
		[[self connectedImage] setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
		
		if ([ds isDefault])
		{
			[[self titleTextField] setFont:[NSFont boldSystemFontOfSize:titleTextFontSize]];
		}
		else
		{
			[[self titleTextField] setFont:[NSFont systemFontOfSize:titleTextFontSize]];
		}
	}
	else
	{
		[[self connectedImage] setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
		
		// could say when it was last seen?
		[[self connectedTextField] setStringValue:@"Disconnected"];
		
		// remove boldness
		[[self titleTextField] setFont:[NSFont systemFontOfSize:titleTextFontSize]];
	}
	

}

@end
