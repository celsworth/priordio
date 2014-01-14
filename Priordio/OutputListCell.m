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
	[[self testTextField] setStringValue:[[self output] name]];
	
	if ([[self output] isPresent])
	{
		// transport type (Built-in/USB)
		//[PriAudioDevice transportTypeAsName:[[ds device] transportType]];
	}
}

@end
