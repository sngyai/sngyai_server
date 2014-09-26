//
//  WPAdViewHandler.h
//  WPLib
//
//  Created by guang on 13-12-16.
//  Copyright (c) 2013年 celles.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPCallsWrapper.h"
#import "AppConnect.h"
@class WPAdView;
@class UIViewController;

@interface WPAdViewHandler : NSObject{
    WPAdView *_adH5;

}
@property(nonatomic, retain) WPAdView *adH5;

+ (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y ;

+ (UIView *)displayAd:(NSString *)aSize;

- (void)removeAdH5;

+ (void)closeBannerAd;

@end

@interface WPCallsWrapper (WPAdViewHandler)

- (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

- (UIView *)displayAd:(NSString *)aSize;

- (void)closeBannerAd;

@end


@interface AppConnect (WPAdViewHandler)

+ (UIView *)displayAdForSize:(NSString *)aSize;

+ (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

+ (void)displayAd:(UIViewController *)vController adSize:(NSString *)aSize;

+ (void)displayAd:(UIViewController *)vController;

+ (void)displayAd:(UIViewController *)vController showX:(CGFloat)x showY:(CGFloat)y;

+ (void)closeBannerAd;
@end


