//
//  InterstitialAD.h
//  SDKLibrary
//
//  Created by pc001 on 14-1-20.
//  Copyright (c) 2014年 pc001. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface BannerAD : NSObject
{
    
}


//参数 appkey 为应用密钥
+ (BOOL)initWithId:(NSString *)appID WithTypeID:(NSString *)typeIDString WithDelegate:(id)delegate WithUserID:(NSString *)userid WithAppKey:(NSString *)appkey WithPageType:(NSString *)typePage didShowBlock:(void (^)(UIView *))didShowBlock didDismissBlock:(void (^)(NSString *))didDismissBlock;


+(void)StartApp:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif;


@end
