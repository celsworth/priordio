//
//  OutputList.h
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CaeAudioSystem.h"

@interface OutputList : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, retain) NSMutableArray *outputs;
@property (nonatomic, retain) CaeAudioSystem *audioSystem;
@property (nonatomic, retain) NSTableView *outputListTableView;


-(void)reload;

@end
