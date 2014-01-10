//
//  AppDelegate.m
//  Default Audio Switcher
//
//  Created by Chris Elsworth on 10/01/2014.
//  Copyright (c) 2014 Chris Elsworth. All rights reserved.
//

#import "AppDelegate.h"

#import "CoreAudio/CoreAudio.h"

#import "CaeAudioDevice.h"

@implementation AppDelegate


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	CaeAudioDevice *defaultDevice = [[CaeAudioDevice alloc] initAsDefaultDevice];
		
	NSMutableArray *dataSources = [defaultDevice dataSources];
	
	NSLog(@"default device has %lu datasources", [dataSources count]);
	
	[dataSources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSLog(@"datasource is %@", [obj name]);
	}];
	
	exit(0);
	
#if 0
		
	UInt32 dataSourceId = [self getDataSourceFor:defaultDevice];
		if (dataSourceId == 'ispk') {
		// Recognized as internal speakers
		NSLog(@"speakers?");
	} else if (dataSourceId == 'hdpn') {
		// Recognized as headphones
		NSLog(@"headphones?");
	}
	else {
		NSLog(@"%d", dataSourceId);
	}
	
	AudioObjectPropertyAddress sourceAddr = [self audioObjectForDataSource];
	AudioObjectAddPropertyListenerBlock(defaultDevice, &sourceAddr, dispatch_get_current_queue(),
										^(UInt32 inNumberAddresses, const AudioObjectPropertyAddress *inAddresses) {
											
											NSLog(@"block fired");
											
											UInt32 dataSourceId = [self getDataSourceFor:defaultDevice];
											
											if (dataSourceId == 'ispk') {
												// Recognized as internal speakers
												NSLog(@"speakers?");
											} else if (dataSourceId == 'hdpn') {
												// Recognized as headphones
												NSLog(@"headphones?");
											}
											
										});
#endif
}

@end
