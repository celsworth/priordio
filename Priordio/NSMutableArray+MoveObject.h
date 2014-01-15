//
//  NSMutableArray+MoveObject.h
//  Priordio
//
//  Created by Chris Elsworth on 15/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MoveObject)

-(void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
