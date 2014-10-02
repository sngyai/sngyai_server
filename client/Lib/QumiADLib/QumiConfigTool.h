//
//  QumiConfigTool.h
//  qm
//
//  Created by qm on 13-9-7.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#define QUMI_CONNECT_SUCCESS @"QUMI_CONNECT_SUCCESS"
#define QUMI_CONNECT_FAILED  @"QUMI_CONNECT_FAILED"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QumiConfigTool : NSObject
 //开发者ID 密钥 应用所在的渠道号
+ (void)startWithAPPID:(NSString *)publisherId secretKey:(NSString *)secretKey appChannel:(NSUInteger)channel;
//开发者ID
+ (NSString *)qumiAppcodeId;

//密钥
+ (NSString*)qumiSecretKey;

//渠道号
+ (NSUInteger)qumiChannelID;

+ (QumiConfigTool *)sharedInstance;

@end
