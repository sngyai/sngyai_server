//
//  CoolAdWall.h
//  AdWallCoolAd
//
//  Created by 马明 on 14-1-7.
//  Copyright (c) 2014年 马明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CoolAdWall;
@class CoolAdWallModel;

typedef enum
{
    CoolAdWallThemeColor_White,
    CoolAdWallThemeColor_Orange,			//get ad header
    CoolAdWallThemeColor_Blue,		//get ad body
    CoolAdWallThemeColor_Red,
    CoolAdWallThemeColor_Green,
} CoolAdWallThemeColor; // CoolAdWall 主题颜色


/*
 用于异步通知从网络抓取文件成功
 */
@protocol CoolAdWallFetchUrlDelegate <NSObject>    

@required
- (void)didFetchUrl:(NSString*)sUrl WithData:(NSData*)retData;

@end

void *CoolAdWallMakePointData(int point);
int CoolAdWallGetPoint(void *pointData);

@protocol CoolAdWallDelegate <NSObject>

@required
// 查询积分回调 参数1.adArray存储的数据位获得积分的广告信息，该数组元素内容为NSDictionary类型，包括广告名字和积分数，key值分别为name和point；参数2.pointData转换为为用户的剩余总积分数，--使用CoolAdWallGetPoint（void *pointData）方法将参数转换为int类型积分数据
- (void)didReceiveResultGetScore:(void *)pointData withAdInfo:(NSArray*)adArray;
// 消费积分回调 --使用CoolAdWallGetPoint（void *pointData）方法将参数转换为int类型积分数据，remainPointData参数转换为消费后剩余的总积分数，spendPointData阐述转换为消费的积分数。
- (void)didSpendScoreSuccessAndResidualScore:(void*)remainPointData andSpendScore:(void*)spendPointData;
// 消费积分失败
- (void)didFailedSpendScoreWithError:(NSError*)error;
@optional
// 是否打印日志
- (BOOL)logMode;
// 是否为测试模式
- (BOOL)testMode;
// 广告请求失败
- (void)didFailToReceiveAd:(CoolAdWall*)adWall Error:(NSError*)error;
// 广告请求成功
- (void)didReceiveAd:(CoolAdWall*)adWall;
// CoolAdWall关闭回调
- (void)rtbWallDidDismissScreen:(UIViewController*)adWall;
// CoolAdWall展示成功(暂未调用)
//- (void)rtbWallWillPresentScreen:(UIViewController*)adWall;

/************************************************/
/*用户自定义界面墙回调*/
//请求广告返回数据成功
- (void)customCoolAdWallDidFinishedLoaingWithModels:(NSArray *)models; //array 里面是 CoolAdWallModel
/************************************************/

@end

@interface CoolAdWall : NSObject

@property (assign, nonatomic) id<CoolAdWallDelegate> delegate;

// 创建 CoolAdWall
- (CoolAdWall*)initWithAppID:(NSString*)appID secretKey:(NSString*)secretKey andDelegate:(id<CoolAdWallDelegate>)delegate;

/*用户自定义墙的初始化参数，以及点击跳转方法(PS:创建方法使用这个)*/
/************************************************/
//  用户自定义界面墙
- (CoolAdWall*)initCustomCoolAdWallWithAppID:(NSString*)appID secretKey:(NSString*)secretKey andDelegate:(id<CoolAdWallDelegate>)delegate;

//用户自定义墙点击了某个广告后，汇报点击信息 (model里面有广告的编号，点击后必须调用该函数，否则不会产生激活)
- (void)customCoolAdWallDidClickAt:(CoolAdWallModel *)model inController:(UIViewController *)controller;

//是否有更多广告
- (BOOL)moreAd;

//加载更多 (如果有更多广告再调用此接口)
- (void)customCoolAdWallLoadMore;

//自定义墙初始化后，第一次加载广告
- (void)customCoolAdWallInit;

/************************************************/

// 查询积分
- (void)getScore;
// 消费积分 --使用CoolAdWallMakePointData生成pointData;
- (void)spendScore:(void*)pointData;
// 展示CoolAdWall
- (void)showCoolAdWallWithController:(UIViewController*)viewController;
// 设置CoolAdWall的主题颜色
- (void)setCoolAdWallColor:(CoolAdWallThemeColor)color;

// 设置开发者账户体系的用户名；该方法请在调用showCoolAdWallWithController:方法之前调用，避免不能及时生效。
- (void)setDeveloperUserID:(NSString*)userID;

// 设置积分墙右上角积分view是否显示（只限用于积分墙,默认为展示；该方法请在调用showCoolAdWallWithController:方法之前调用，否则设置无效，会取默认展示的效果）
- (void)setDisplayScoreView:(BOOL)isDisplay;

//设置是否优化状态栏显示效果，缺省为YES
+ (void)setStatusBarOptimized:(BOOL)bOptimized;

@end

@interface CoolAdWallModel : NSObject
- (id)initWithMessage:(id)message;

@property (nonatomic, readonly) NSString * order;   //广告id
@property (nonatomic, readonly) NSString * name;    //广告名称
@property (nonatomic, readonly) NSString * category;//广告类别

@property (nonatomic, readonly) NSString * desc;    //应用的详细描述
@property (nonatomic, readonly) NSString * adText;  //应用的简短描述
@property (nonatomic, readonly) NSString * taskBrief;   //提示语(例如：首次安装并创建新角色获取积分)

@property (nonatomic, readonly) NSString * author;  //应用版权所有者
@property (nonatomic, readonly) NSString * size;    //应用的大小
@property (nonatomic, readonly) NSString * version; //版本
@property (nonatomic, readonly) NSString * smallIconURL;//应用小图标URL
@property (nonatomic, readonly) NSString * largeIconURL;//应用大图标URL
@property (nonatomic, readonly) NSString * taskSteps;   //步骤提示(例如：打开游戏创建新角色并体验3分钟 回到本应用即可获取{积分单位})
@property (nonatomic, readonly) NSString * points;      //积分值(0表示该应用已经激活过，通过isExpired亦可判断)
@property (nonatomic, readonly) BOOL       IsExpired;   //表示该应用是否已经激活过
@property (nonatomic, readonly) NSString * pointUnit;   //应用积分单位(生命值、金币)

@end
