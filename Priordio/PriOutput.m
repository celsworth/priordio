//
//  PriOutput.m
//  Priordio
//
//  Created by Chris Elsworth on 11/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "PriOutput.h"

@interface PriOutput ()
// private properties
@property (nonatomic, retain) PriAudioDataSource *dataSource;
@end

@implementation PriOutput

-(id)initWithAudioSystem:(PriAudioSystem *)audioSystem
{
	if (self = [super init])
	{
		_audioSystem = audioSystem;
	}
	
	return self;
}

-(void)setDeviceUID:(NSString *)deviceUID
{
	_deviceUID = deviceUID;
	[self setDataSource:[[self audioSystem] findDevice:[self deviceUID] dataSource:[self dataSourceName]]];
}
-(void)setDataSourceName:(NSString *)dataSourceName
{
	_dataSourceName = dataSourceName;
	[self setDataSource:[[self audioSystem] findDevice:[self deviceUID] dataSource:[self dataSourceName]]];
}

-(NSString *)name
{
	return [self dataSourceName];
}

-(BOOL)isPresent
{
	// is this device/dataSource combination currently present in audioSystem?
	// this might not belong in this class, we probably don't want to pass in audioSystem at all either
	
	return [self dataSource] ? YES : NO;
}

@end
