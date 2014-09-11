//
//  JupengSpot.h
//  JpSDK
//
//  Created by jupeng on 14-3-1.
//  Copyright (c) 2014年 Jupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JupengPopScreenADs : NSObject


/*
 * 查询插屏广告是否准好 返回true的时候，才显示插播广告
 */
+  (BOOL) isReady;


/*
 * 请求插屏广告数据 ,complete block: error不为空，请求失败。error为空，请求成功
 */
+ (void) requestPopScreenADs :(void (^)(NSError *))complete;




/*
 * 显示插播广告 ,dismiss block: 关闭插屏通知
 */
+ (void)  showPopScreenADs:(UIViewController*)hostViewController block:(void(^)())dismiss;

@end


