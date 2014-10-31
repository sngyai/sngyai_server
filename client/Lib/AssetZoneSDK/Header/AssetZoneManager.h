//
//  AssetZoneManager.h
//  AssetZoneSDK
//
//  Created by Domob on 14-2-11.
//  Copyright (c) 2014年 Domob Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  消费结果状态码
 *  AssetZoneConsumeStatus
 */
typedef enum {
    
    /**
     *  消费成功
     *  Consume Successfully
     */
    eAssetZoneConsumeSuccess = 1,
    /**
     *  剩余积分不足
     *  Not enough point
     */
    eAssetZoneConsumeInsufficient,
    /**
     *  订单重复
     *  Duplicate consume order
     */
    eAssetZoneConsumeDuplicateOrder
} AssetZoneConsumeStatus;
/**
 *  积分墙类型
 *  asset zone type
 */
typedef enum {
    
    /**
     *  列表积分墙
     *  ListAssetZone
     */
    eAssetZoneTypeList = 1,
    /**
     *  视频积分墙
     *  VideoAssetZone
     */
    eAssetZoneTypeVideo,
    /**
     *  插屏积分墙
     *  InterstitialAssetZone
     */
    eAssetZoneTypeInterstitial,
    /**
     *  其他，如Manager的config
     *
     */
    eAssetZoneTypeOther
    
} AssetZoneType;

typedef enum {
    
    eAZActivityEnterReport = 1,// 进入广告列表界面
    eAZActivityExitReport      // 退出广告列表界面
}AssetZoneActivityReprotType;

@class AssetZoneManager;
@protocol AssetZoneManagerDelegate <NSObject>
@optional
#pragma mark - asset zone present callback 积分墙展现回调

/**
 *  积分墙开始加载列表数据。
 *  Asset zone starts to fetch list info.
 *
 *  @param manager AssetZoneManager
 *  @param type    积分墙类型
 */
- (void)azManagerDidStartLoad:(AssetZoneManager *)manager
                         assetZoneType:(AssetZoneType)type;
/**
 *  积分墙加载完成。
 *  Fetching asset zone list successfully.
 *
 *  @param manager AssetZoneManager
 *  @param type    积分墙类型
 */
- (void)azManagerDidFinishLoad:(AssetZoneManager *)manager
                          assetZoneType:(AssetZoneType)type;
/**
 *  积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
 *   Failed to load asset zone.

 *
 *  @param manager AssetZoneManager
 *  @param error   error
 *  @param type    积分墙类型
 */
- (void)azManager:(AssetZoneManager *)manager
       failedLoadWithError:(NSError *)error
             assetZoneType:(AssetZoneType)type;
/**
 *  当积分墙要被呈现出来时，回调该方法。
 *  Called when interstitial ad will be presented.
 *
 *  @param manager AssetZoneManager
 *  @param type    积分墙类型
 */
- (void)azManagerWillPresent:(AssetZoneManager *)manager
                        assetZoneType:(AssetZoneType)type;
/**
 *  积分墙页面关闭。
 *  Asset zone closed.
 *
 *  @param manager AssetZoneManager
 *  @param type    积分墙类型
 */
- (void)azManagerDidClosed:(AssetZoneManager *)manager
                      assetZoneType:(AssetZoneType)type;

/**
 *  成功获取视频积分。（只用于视频积分墙）
 *  Complete Video Asset.（only for video Asset）
 *
 *  @param manager AssetZoneManager
 *  @param totalPoint
 *  @param consumedPoint
 */

- (void)azCompleteVideoAsset:(AssetZoneManager *)manager
                              withTotalPoint:(NSNumber *)totalPoint
                               consumedPoint:(NSNumber *)consumedPoint;

/**
 *  获取视频积分出错。（只用于视频积分墙）
 *  Uncomplete Video asset.（only for video asset）
 *
 *  @param manager AssetZoneManager
 *  @param error
 */

- (void)azManagerUncompleteVideoAsset:(AssetZoneManager *)manager
                                     withError:(NSError *)error;

#pragma mark - point manage callback 积分管理

/**
 *  积分查询成功之后，回调该接口，获取总积分和总已消费积分。
 *  Called when finished to do point check.
 *
 *  @param totalPoint
 *  @param consumedPoint
 */
- (void)azManager:(AssetZoneManager *)manager
        receivedTotalPoint:(NSNumber *)totalPoint
        totalConsumedPoint:(NSNumber *)consumedPoint;
/**
 *  积分查询失败之后，回调该接口，返回查询失败的错误原因。
 *  Called when failed to do point check.
 *
 *  @param AssetZoneManager
 *  @param error
 */
- (void)azManager:(AssetZoneManager *)manager
      failedCheckWithError:(NSError *)error;
/**
 *  消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
 *  Called when finished to do point consume.
 *
 *  @param AssetZoneManager
 *  @param statusCode
 *  @param totalPoint
 *  @param consumedPoint
 */
- (void)azManager:(AssetZoneManager *)manager
    consumedWithStatusCode:(AssetZoneConsumeStatus)statusCode
                totalPoint:(NSNumber *)totalPoint
        totalConsumedPoint:(NSNumber *)consumedPoint;
/**
 *  消费请求异常应答后，回调该接口，并返回异常的错误原因。
 *  Called when failed to do consume request.
 *
 *  @param error
 */
- (void)azManager:(AssetZoneManager *)manager
    failedConsumeWithError:(NSError *)error;

#pragma mark - asset zone status callback 积分墙状态
/**
 *  积分墙是否可用。
 *  Called after get asset zone enable status.
 *
 *  @param manager
 *  @param enable
 */
- (void)azManager:(AssetZoneManager *)manager
      didCheckEnableStatus:(BOOL)enable;

@end

@interface AssetZoneManager : NSObject {
    
}

@property(nonatomic,assign)id<AssetZoneManagerDelegate>delegate;

/**
 *禁用StoreKit库提供的应用内打开store页面的功能，采用跳出应用打开OS内置AppStore。默认为NO，即使用StoreKit。
 */
@property (nonatomic, assign) BOOL disableStoreKit;

/**
 *  用于展示sotre或者展示类广告
 */
@property(nonatomic,assign)UIViewController *rootViewController;

#pragma mark - init 初始化相关方法
/**
 *  使用Publisher ID初始化积分墙
 *  Create AssetZoneManager with your own Publisher ID
 *
 *  @param publisherID 媒体ID
 *
 *  @return AssetZoneManager
 */
- (id)initWithPublisherID:(NSString *)publisherID;
/**
 *  使用Publisher ID和应用当前登陆用户的User ID初始化AssetZoneManager
 *   Create AssetZoneManager with your own Publisher ID and User ID.
 *
 *  @param publisherID 媒体ID
 *  @param userID      应用中唯一标识用户的ID
 *
 *  @return AssetZoneManager
 */
- (id)initWithPublisherID:(NSString *)publisherID andUserID:(NSString *)userID;

#pragma mark - asset zone present 积分墙展现相关方法
/**
 *  使用App的rootViewController来弹出并显示列表积分墙。
 *  Present asset zone in ModelView way with App's rootViewController.
 *
 *  @param type 积分墙类型
 */
- (void)presentAssetZoneWithType:(AssetZoneType)type;
/**
 *  使用开发者传入的UIViewController来弹出显示积分墙。
 *  Present AssetZoneViewController with developer's controller.
 *
 *  @param controller UIViewController
 *  @param type 积分墙类型
 */
- (void)presentAssetZoneWithViewController:(UIViewController *)controller
                                      type:(AssetZoneType)type;
/**
 *  请求加载插屏积分广告
 *  Request to load interstitial ad
 */
- (void)loadInterstitialAssetZone;
/**
 *  询问插屏积分墙广告是否完成，该方法立即返回当前状态，不会阻塞主线程。
 *  Check if interstitial ad is ready to show.
 *
 *  @return BOOL
 */
- (BOOL)isInterstitialAssetZoneReady;

#pragma mark - point manage 积分管理相关广告
/**
 *  检查已经得到的积分，成功或失败都会回调代理中的相应方法。
 *
 */
- (void)checkOwnedPoint;
/**
 *  消费指定的积分数目，成功或失败都会回调代理中的相应方法（请特别注意参数类型为unsigned int，需要消费的积分为非负值）。
 *
 *  @param point 要消费积分的数目
 */
- (void)consumeWithPointNumber:(NSUInteger)point;

#pragma mark - asset zone status 查询积分墙墙是否可用
/**
 *  判断积分墙是否可用
 *  get asset zone enable status.
 */
- (void)checkAssetZoneEnableState;


@end
