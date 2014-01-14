//
//  OutputListCell.h
//  Priordio
//
//  Created by Chris Elsworth on 14/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PriOutput.h"

@interface OutputListCell : NSTableCellView

@property (nonatomic, weak) IBOutlet NSImageView *connectedImage;
@property (nonatomic, weak) IBOutlet NSTextField *titleTextField;
@property (nonatomic, weak) IBOutlet NSTextField *connectedTextField;

@property (nonatomic, weak) IBOutlet NSImageView *transportTypeImage;

@property (nonatomic, retain) PriOutput *output;

-(void)populateFromOutput:(PriOutput *)output;

@end
