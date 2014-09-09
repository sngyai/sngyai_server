//
//  main.m
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MiidiManager.h"
#import "YouMiConfig.h"
#import "YouMiPointsManager.h"
#import "ChanceAd.h"

int main(int argc, char *argv[]) {
	
    [ChanceAd startSession:@"889879453-E23F9F-E650-079D-6B1EF8ECC"];
    
    [MiidiManager setAppPublisher:@"19071"  withAppSecret:(NSString*)@"5sb72gp3iyj8znow" ];
    [YouMiConfig launchWithAppID:@"18e9f2d24d78bb26" appSecret:@"9c3909b6e5f685cb"];
    [YouMiConfig setIsTesting:NO];
    [YouMiPointsManager enable];

	
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [pool release];
    return retVal;
}
