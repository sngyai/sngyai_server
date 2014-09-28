#import "WPCallsWrapper.h"
#import "AppConnect.h"

@class WPPopView;
@class UIViewController;

@interface WPPopViewHandler : NSObject<UIWebViewDelegate>{
    WPPopView *_popH5;
}
@property(nonatomic, retain) WPPopView *popH5;

+ (void)initPop:(UIViewController *)controller;

+ (void)showPop:(UIViewController *)controller;

+ (void)showPop:(UIViewController *)controller urlStr:(NSString *)urlStr;

+ (void)showPop:(UIViewController *)controller popX:(float)popX popY:(float)popY popWidth:(float)width popHeight:(float)height;

+ (void)closePop;

- (void)removePopH5;

@end

@interface WPCallsWrapper (WPPopViewController)

- (void)initPop:(UIViewController *)controller;

- (void)showPop:(UIViewController *)controller;

- (void)showPop:(UIViewController *)controller urlStr:(NSString *)urlStr;

- (void)showPop:(UIViewController *)controller popX:(float)popX popY:(float)popY popWidth:(float)width popHeight:(float)height;

- (void)closePop;

@end


@interface AppConnect (WPPopViewController)

+ (void)initPop;

+ (void)showPop:(UIViewController *)controller;

+ (void)showPop:(UIViewController *)controller urlStr:(NSString *)urlStr;

+ (void)showPop:(UIViewController *)controller popX:(float)popX popY:(float)popY popWidth:(float)width popHeight:(float)height;

+ (void)closePop;
@end
