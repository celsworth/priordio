//
//  PriOutput.m
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "PriOutput.h"

@implementation PriOutput

-(id)initWithAudioSystem:(PriAudioSystem *)audioSystem
{
	if (self = [super init])
	{
		_audioSystem = audioSystem;
	}
	
	return self;
}

-(NSString *)name
{
	return @"test";
}

-(BOOL)isPresent
{
	// is this device/dataSource combination currently present in audioSystem?
	
	PriAudioDataSource *ds = [[self audioSystem] findDevice:[self deviceUID] dataSource:[self dataSourceName]];
	
	return ds ? YES : NO;
}

@end
