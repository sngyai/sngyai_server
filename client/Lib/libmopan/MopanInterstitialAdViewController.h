

#import <UIKit/UIKit.h>

// 插屏广告的delegate
@protocol MopanInterstitialDelegate <NSObject>
// 成功请求插屏广告
//
// 详解:当接收服务器返回请求插屏广告成功后调用该函数
// 补充：
- (void)didLoadAdSuccess;

// 请求插屏广告失败
//
// 详解:当插屏广告失败后调用该函数
// 补充：
- (void)didLoadAdFailed:(NSError *)error;
@end

/***
 *
 * MopanInterstitialAdViewController start
 ***/

@interface MopanInterstitialAdViewController : UIViewController

// if it is ready
@property (nonatomic, readonly) BOOL isReady;


//@property (nonatomic, assign)
// if set the statusBarHidden = YES ? default is YES
@property (nonatomic, assign) BOOL shouldHiddenStatusBar;

// set delegate
@property (nonatomic, assign) NSObject<MopanInterstitialDelegate> *delegate;

//  设置开发者账号，账号获取来自网站www.imopan.com
-(id) initWithMopanInterstitial:(NSString*) appID                    // Mopan app Id
          withMopanInterstitial:(NSString*)appPassword               // Mopan app secret
 rootViewController:(UIViewController *)rootViewController;          // set RootViewController

// load ad
- (void)loadAd;

// show ad
- (void)show;


@end
