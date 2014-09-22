//
//  MobiSageNative.h
//  mobiSageSDK
//
//  Created by fwang.work on 14-3-13.
//  Copyright (c) 2014年 adsage. All rights reserved.
//

typedef void (^MobiSageNativeCompletionCallBack)(CGSize ,NSDictionary*);

@class MobiSageNative;


@protocol MobiSageNativeDelegate
@optional
/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site, in app purchase时需要使用当前广告所在的控制器。
 * 返回：一个视图控制器对象
 * 说明：如果没有实现此回调，将使用keyWindow.rootViewController
 */
- (UIViewController*)viewControllerToPresent;

//广告请求
//可以根据aNative.content对象中的width,height设置广告位大小.
//content的内容如下:
/*
 {
 height = 250;//广告位的高
 width = 300;//广告位的宽
 title = "信息流广告";//展示的标题
 desc = "";//展示描述
 image = "http://mws.adsage.com/mobisage/bcadm/26496/44b9f6c78f64432d8ac8eb20993e7334.jpg";//广告展示图片
 logo = "http://a1782.phobos.apple.com/us/r30/Purple/v4/39/8a/de/398ade94-d3b4-f60f-4861-9f49b318d2b7/72.png";//应用logo
 packageSize = "7.3";//包大小，单位MB
 star = 0;   //展示星级
 }
 */
-(void)mobiSageNativeSuccessToRequest:(MobiSageNative*) aNative;
-(void)mobiSageNativeFaildToRequest:(MobiSageNative*) aNative withError:(NSError*) error;

//广告加载..
-(void)mobiSageNativeSuccessToLoaded:(MobiSageNative*) aNative;
-(void)mobiSageNativeFaildToLoaded:(MobiSageNative*) aNative withError:(NSError*) error;

//广告landingPage
-(void)mobiSageNativePopADWindow:(MobiSageNative*) aNative;
-(void)mobiSageNativeHideADWindow:(MobiSageNative*) aNative;

//广告被点击
-(void)mobiSageNativeClick:(MobiSageNative*) aNative;

//广告已展示
-(void)mobiSageNativeAppeared:(MobiSageNative*) aNative;

@end


@interface MobiSageNative : UIView

@property (nonatomic, assign) id<MobiSageNativeDelegate> delegate;
@property (nonatomic, readonly) CGSize size;//实际广告的宽高.
@property (nonatomic, readonly) NSDictionary *content;//广告json数据

- (void) setAdSize:(CGSize)size slotToken:(NSString *)slotToken;

//请求广告资源.(width=期望广告view的宽度.我们会根据width,等比缩放广告view,并返回给你height).
- (id) initWithWidth:(CGFloat) width
          slotToken:(NSString *)slotToken
         completion:(MobiSageNativeCompletionCallBack)completion;

//请求广告资源.(height=期望广告view的宽度.我们会根据height,等比缩放广告view,并返回给你width).
- (id) initWithHeight:(CGFloat) height
           slotToken:(NSString *)slotToken
          completion:(MobiSageNativeCompletionCallBack)completion;

//请求广告资源.(size=期望广告view的size.我们会自适应填充广告内容.宽高比在0.5-2之间为有效size).
- (id) initWithSize:(CGSize) size
         slotToken:(NSString *)slotToken
        completion:(MobiSageNativeCompletionCallBack)completion;

//点击广告通知
- (void)handleClick;

- (void)setOptions:(NSDictionary*)_options;//高级可选控制项,(disableClickPic:YES 可以设置广告图片不能点击)
@end
