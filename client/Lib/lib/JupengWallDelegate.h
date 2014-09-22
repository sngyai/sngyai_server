//
//  JupengWallDelegate.h
//  JpSDK
//
//  Created by adroot on 14-6-23.
//  Copyright (c) 2014年 Jupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JupengWallDelegate <NSObject>
@optional


//
// 成功显示广告后调用
//
// 详解:
//      全屏广告显示后调用该方法
//

- (void) didShowWallScreen;


//
// 成功关闭全屏广告后调用
//
// 详解:
//      全屏广告显示完成，关闭全屏广告后调用该方法
//
- (void) didDismissWallScreen;

@end
