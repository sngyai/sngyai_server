//
//  DMOfferWallManager.h
//  DMOfferWallSDK
//
//  Created by Domob on 14-2-11.
//  Copyright (c) 2014年 Domob Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  消费结果状态码
 *  OfferWallConsumeStatus
 */
typedef enum {
    
    /**
     *  消费成功
     *  Consume Successfully
     */
    eDMOfferWallConsumeSuccess = 1,
    /**
     *  剩余积分不足
     *  Not enough point
     */
    eDMOfferWallConsumeInsufficient,
    /**
     *  订单重复
     *  Duplicate consume order
     */
    eDMOfferWallConsumeDuplicateOrder
} DMOfferWallConsumeStatus;
/**
 *  积分墙类型
 *  offer wall type
 */
typedef enum {
    
    /**
     *  列表积分墙
     *  ListOfferWall
     */
    eDMOfferWallTypeList = 1,
    /**
     *  视频积分墙
     *  VideoOfferWall
     */
    eDMOfferWallTypeVideo,
    /**
     *  插屏积分墙
     *  InterstitialOfferWall
     */
    eDMOfferWallTypeInterstitial,
    /**
     *  其他，如Manager的config
     *
     */
    eDMOfferWallTypeOther
    
} DMOfferWallType;

typedef enum {
    
    eOWActivityEnterReport = 1,// 进入广告列表界面
    eOWActivityExitReport      // 退出广告列表界面
}DMOWActivityReprotType;

@class DMOfferWallManager;
@protocol DMOfferWallManagerDelegate <NSObject>
@optional
#pragma mark - offer wall present callback 积分墙展现回调

/**
 *  积分墙开始加载列表数据。
 *  Offer wall starts to fetch list info.
 *
 *  @param manager DMOfferWallManager
 *  @param type    积分墙类型
 */
- (void)dmOfferWallManagerDidStartLoad:(DMOfferWallManager *)manager
                         offerWallType:(DMOfferWallType)type;
/**
 *  积分墙加载完成。
 *  Fetching offer wall list successfully.
 *
 *  @param manager DMOfferWallManager
 *  @param type    积分墙类型
 */
- (void)dmOfferWallManagerDidFinishLoad:(DMOfferWallManager *)manager
                          offerWallType:(DMOfferWallType)type;
/**
 *  积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
 *   Failed to load offer wall.

 *
 *  @param manager DMOfferWallManager
 *  @param error   error
 *  @param type    积分墙类型
 */
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
       failedLoadWithError:(NSError *)error
             offerWallType:(DMOfferWallType)type;
/**
 *  当积分墙要被呈现出来时，回调该方法。
 *  Called when interstitial ad will be presented.
 *
 *  @param manager DMOfferWallManager
 *  @param type    积分墙类型
 */
- (void)dmOfferWallManagerWillPresent:(DMOfferWallManager *)manager
                        offerWallType:(DMOfferWallType)type;
/**
 *  积分墙页面关闭。
 *  Offer wall closed.
 *
 *  @param manager DMOfferWallManager
 *  @param type    积分墙类型
 */
- (void)dmOfferWallManagerDidClosed:(DMOfferWallManager *)manager
                      offerWallType:(DMOfferWallType)type;

/**
 *  成功获取视频积分。（只用于视频积分墙）
 *  Complete Video Offer.（only for video offer）
 *
 *  @param manager DMOfferWallManager
 *  @param totalPoint
 *  @param consumedPoint
 */

- (void)dmOfferWallManagerCompleteVideoOffer:(DMOfferWallManager *)manager
                              withTotalPoint:(NSNumber *)totalPoint
                               consumedPoint:(NSNumber *)consumedPoint;

/**
 *  获取视频积分出错。（只用于视频积分墙）
 *  Uncomplete Video Offer.（only for video offer）
 *
 *  @param manager DMOfferWallManager
 *  @param error
 */

- (void)dmOfferWallManagerUncompleteVideoOffer:(DMOfferWallManager *)manager
                                     withError:(NSError *)error;

#pragma mark - point manage callback 积分管理

/**
 *  积分查询成功之后，回调该接口，获取总积分和总已消费积分。
 *  Called when finished to do point check.
 *
 *  @param totalPoint
 *  @param consumedPoint
 */
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
        receivedTotalPoint:(NSNumber *)totalPoint
        totalConsumedPoint:(NSNumber *)consumedPoint;
/**
 *  积分查询失败之后，回调该接口，返回查询失败的错误原因。
 *  Called when failed to do point check.
 *
 *  @param DMOfferWallManager
 *  @param error
 */
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
      failedCheckWithError:(NSError *)error;
/**
 *  消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
 *  Called when finished to do point consume.
 *
 *  @param DMOfferWallManager
 *  @param statusCode
 *  @param totalPoint
 *  @param consumedPoint
 */
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
    consumedWithStatusCode:(DMOfferWallConsumeStatus)statusCode
                totalPoint:(NSNumber *)totalPoint
        totalConsumedPoint:(NSNumber *)consumedPoint;
/**
 *  消费请求异常应答后，回调该接口，并返回异常的错误原因。
 *  Called when failed to do consume request.
 *
 *  @param error
 */
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
    failedConsumeWithError:(NSError *)error;

#pragma mark - offerwall status callback 积分墙状态
/**
 *  积分墙是否可用。
 *  Called after get OfferWall enable status.
 *
 *  @param manager
 *  @param enable
 */
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
      didCheckEnableStatus:(BOOL)enable;

@end

@interface DMOfferWallManager : NSObject {
    
}

@property(nonatomic,assign)id<DMOfferWallManagerDelegate>delegate;

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
 *  Create DMOfferWallManager with your own Publisher ID
 *
 *  @param publisherID 媒体ID
 *
 *  @return DMOfferWallManager
 */
- (id)initWithPublisherID:(NSString *)publisherID;
/**
 *  使用Publisher ID和应用当前登陆用户的User ID初始化DMOfferWallManager
 *   Create OfferWallViewController with your own Publisher ID and User ID.
 *
 *  @param publisherID 媒体ID
 *  @param userID      应用中唯一标识用户的ID
 *
 *  @return DMOfferWallManager
 */
- (id)initWithPublisherID:(NSString *)publisherID andUserID:(NSString *)userID;

/**
 *  更新登陆用户的User ID
 *  Update User ID.
 *
 *  @param userID      应用中唯一标识用户的ID
 */
- (void)updateUserID:(NSString *)userID;

#pragma mark - offer wall present 积分墙展现相关方法
/**
 *  使用App的rootViewController来弹出并显示列表积分墙。
 *  Present offer wall in ModelView way with App's rootViewController.
 *
 *  @param type 积分墙类型
 */
- (void)presentOfferWallWithType:(DMOfferWallType)type;
/**
 *  使用开发者传入的UIViewController来弹出显示OfferWallViewController。
 *  Present OfferWallViewController with developer's controller.
 *
 *  @param controller UIViewController
 *  @param type 积分墙类型
 */
- (void)presentOfferWallWithViewController:(UIViewController *)controller
                                      type:(DMOfferWallType)type;
/**
 *  请求加载插屏积分广告
 *  Request to load interstitial ad
 */
- (void)loadInterstitialOfferWall;
/**
 *  询问插屏积分墙广告是否完成，该方法立即返回当前状态，不会阻塞主线程。
 *  Check if interstitial ad is ready to show.
 *
 *  @return BOOL
 */
- (BOOL)isInterstitialOfferWallReady;

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

#pragma mark - offer wall status 查询积分墙墙是否可用
/**
 *  判断积分墙是否可用
 *  get OfferWall enable status.
 */
- (void)checkOfferWallEnableState;

@end
