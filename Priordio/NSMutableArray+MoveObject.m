//
//  NSMutableArray+MoveObject.m
//  Priordio
//
//  Created by Chris Elsworth on 15/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "NSMutableArray+MoveObject.h"

@implementation NSMutableArray (MoveObject)

// http://stackoverflow.com/questions/7799076/how-to-move-an-item-on-nsmutablearray

-(void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) return;
    if (fromIndex >= self.count) return; //there is no object to move, return
    if (toIndex >= self.count) toIndex = self.count - 1; //toIndex too large, assume a move to end
    id movingObject = [self objectAtIndex:fromIndex];
	
    if (fromIndex < toIndex)
	{
        for (NSUInteger i = fromIndex; i <= toIndex; i++)
		{
            [self replaceObjectAtIndex:i withObject:(i == toIndex) ? movingObject : [self objectAtIndex:i + 1]];
        }
    } else
	{
        id cObject;
        id prevObject;
        for (NSUInteger i = toIndex; i <= fromIndex; i++)
		{
            cObject = [self objectAtIndex:i];
            [self replaceObjectAtIndex:i withObject:(i == toIndex) ? movingObject : prevObject];
            prevObject = cObject;
        }
    }
}

@end