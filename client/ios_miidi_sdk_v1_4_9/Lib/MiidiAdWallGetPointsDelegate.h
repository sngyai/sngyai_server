//
//  MiidiAdWallGetPointsDelegate.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-3-13.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MiidiAdWall;


@protocol MiidiAdWallGetPointsDelegate <NSObject>
@optional

// 请求积分值成功后调用
//
// 详解:当接收服务器返回的积分值成功后调用该函数
// 补充：totalPoints: 返回用户的总积分 
//      pointName  : 返回的积分名称
- (void)didReceiveGetPoints:(NSInteger)totalPoints forPointName:(NSString*)pointName;

// 请求积分值数据失败后调用
// 
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveGetPoints:(NSError *)error;

@end
