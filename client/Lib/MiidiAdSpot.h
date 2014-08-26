//
//  MiidiAdSpot.h
//  MiidiSDKApp
//
//  Created by xuyi on 14-2-18.
//  Copyright (c) 2014年 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MiidiAdSpot : NSObject

/*
 * 请求插屏广告数据 ,complete block: error不为空，请求失败。error为空，请求成功
 */
+ (void) requestSpotAd :(void (^)(NSError *))complete;

/*
 * 当isSpotAdReady返回true的时候，才显示插播广告
 */
+  (BOOL) isSpotAdReady;


/*
 * 显示插播广告 ,dismiss block: 关闭插屏通知
 */
+ (void)  displaySpotAdWithBlock:(UIViewController*)hostViewController block:(void(^)())dismiss;


//
@property(nonatomic, retain) UIWindow* window;

@end
