//
//  MiidiAdWallSpendPointsDelegate.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-3-13.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MiidiAdWall;

@protocol MiidiAdWallSpendPointsDelegate <NSObject>
@optional


// 请求消耗积分成功后调用
//
// 详解:当接收服务器返回的消耗积分成功后调用该函数
// 补充：totalPoints: 返回用户的总积分 

- (void)didReceiveSpendPoints:(NSInteger)totalPoints;


// 请求消耗积分数据失败后调用
// 
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveSpendPoints:(NSError *)error;

@end
