//
//  IntegralWallConfig.h
//  SDKLibrary
//
//  Created by pc001 on 14-2-21.
//  Copyright (c) 2014年 pc001. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface IntegralWallConfig : NSObject


+ (void)loadWithAppID:(NSString *)appid WithSubID:(NSString *)subid WithType:(NSString *)type WithUserID:(NSString *)userid WithAppKey:(NSString *)appkey;
+ (NSString *)wallAppID;
+ (void)setWallAppID:(NSString *)appid;

@end
