//
//  MiidiAdWallRequestToggleDelegate.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-12-7.
//  Copyright 2012 Miidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MiidiAdWallRequestToggleDelegate <NSObject>
@optional

// 成功请求积分墙开关
//
// 详解:当接收服务器返回积分墙开关成功后调用该函数
// 补充：toggle: 返回积分墙是否开启 
- (void)didReceiveToggle:(BOOL)toggle;

// 请求积分墙开关失败后调用
// 
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：
- (void)didFailReceiveToggle:(NSError *)error;

@end
