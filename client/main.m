//
//  main.m
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiidiAppDelegate.h"
#import "MiidiManager.h"
#import "YouMiConfig.h"


int main(int argc, char *argv[]) {
   
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    [MiidiManager setAppPublisher:@"19071"  withAppSecret:(NSString*)@"5sb72gp3iyj8znow" ];
    [YouMiConfig launchWithAppID:@"18e9f2d24d78bb26" appSecret:@"9c3909b6e5f685cb"];
    [YouMiConfig setIsTesting:NO];
    
	int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([MiidiAppDelegate class]));
	
    [pool release];
    return retVal;
}
