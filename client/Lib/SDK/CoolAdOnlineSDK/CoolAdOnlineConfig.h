//
//  CoolAdOnlineConfig.h
//  CoolAdOnlineConfig
//
//  Created by maming on 14-7-7.
//  Copyright (c) 2014年 马明. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoolAdOnlineConfigDelegate <NSObject>
//异步获取在线参数成功回调
- (void)didFinishGetParameters:(NSDictionary*)parameters;
//异步获取在线参数失败回调
- (void)didFailGetParameters:(NSError*)error;

@end

@interface CoolAdOnlineConfig : NSObject
//
+ (CoolAdOnlineConfig*)shareCoolAdOnlineConfigWithAppID:(NSString*)appId andSecretKey:(NSString*)secretKey delegate:(id<CoolAdOnlineConfigDelegate>)delegate;
//
+ (CoolAdOnlineConfig *)shareCoolAdWallIfExists;
/*获取在线参数
 *参数key为您需要获取在线参数的变量名;当key为@"all"时,会获取所有的在线参数,为某个具体变量名时获取响应的变量值
 *参数sync为设置获取在线参数请求的方式为同步或者异步;如果设置为异步（NO）的时候请实现CoolAdOnlineConfigDelegate的代理方法
 */
+ (id)getParameterForKey:(NSString*)key synchronous:(BOOL)sync;

@end
