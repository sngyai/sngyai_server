//
//  JupengConfig.h
//  JpSDK
//
//  Created by jupeng on 14-2-28.
//  Copyright (c) 2014年 Jupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JupengConfig : NSObject

//
// 应用ID 和 密码
//
// 详解:
//      前往主页:http://www.jpmob.com/ 注册一个开发者帐户，同时注册一个应用，获取对应应用的ID和密码
+(void)      launchWithAppID:(NSString*) appID withAppSecret:(NSString*)appSecret;


// 获取IOS SDK版本号
+(NSString*) sdkVersion;

@end
