//
//  GuoMobWall.h
//  GuoMobWall
//
//  Created by qq on 12-11-21.
//  Copyright (c) 2012年 AK. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol GuoMobWallDelegate <NSObject>

@optional
//协议方法
//加载回调 返回参数YES表示加载成功 NO表示失败
- (void)loadWallAdSuccess:(BOOL)success;

//返回按钮回调
- (void)onClickBack;
//下载按钮回调
- (void)onClickDownLoad;
//意见反馈按钮回调
- (void)onClickFeedback;
//意见反馈的返回按钮回调
- (void)onClickBackForFeedback;
//加载积分墙的错误
- (void)GMWallDidFailWithError:(NSString *)error;
//刷新积分的错误
- (void)GMUpdatePointError:(NSString *)error;
//appname 返回打开或下载的应用名字  point返回积分
- (void)checkPoint:(NSString *)appname point:(int)point;
@end

@interface GuoMobWallViewController : UIViewController<GuoMobWallDelegate>
{
id< GuoMobWallDelegate > delegate; 
}
//设应用密钥 和积分墙frame
- (id)initWithId:(NSString *)appKey;
//显示并加载广告列表（参数allow表示是否运行旋转 YES为允许  NO不允许,isHscreen表示应用开始是横还是竖  YES是横NO是竖）
-(void)pushGuoMobWall:(BOOL)allow Hscreen:(BOOL)isHscreen;//加载并显示积分墙
- (void)requestRewardWall:(BOOL)allow Hscreen:(BOOL)isHscreen;//仅仅是加载积分墙
//查询积分
- (int)checkPoint;
//读取所有积分并清空
- (int)readPoint;
//追加积分
- (void)writePoint:(int)writepoint;
//刷新积分
-(void)updatePoint;

@property(nonatomic,assign)id< GuoMobWallDelegate > delegate;
@property(nonatomic)NSTimeInterval updatetime;
@property(nonatomic)BOOL isStatusBarHidden;
@property(nonatomic,copy) NSString * OtherID;//使用积分服务器回调时候的可选参数
@end
