//
//  InterADView.h
//  SDKLibrary
//
//  Created by pc001 on 14-1-20.
//  Copyright (c) 2014年 pc001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const QiYouPointsRecivedNotification;
extern NSString * const QiYouPointsFreshPointsKey;




@interface IntegralWallADView : NSObject
{
    
}



//接口参数
//appKey 应用密钥
//加载展示广告

+ (BOOL)showWallADView:(BOOL)award didShowBlock:(void (^)(NSString *))didShowBlock didDismissBlock:(void (^)(NSString *))didDismissBlock;


@end
