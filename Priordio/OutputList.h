//
//  OutputList.h
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutputList : NSObject <NSTableViewDataSource, NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, retain) NSMutableArray *outputs;

@property (nonatomic, retain) IBOutlet NSTableView *outputListTableView;

-(void)reload;

@end
