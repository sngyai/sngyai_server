#import <UIKit/UIKit.h>
#import "AppConnect.h"

@class WPListController;

typedef enum {
    WP_GROUPBUY,
    WP_SITE,
    WP_ARTICLES,
    WP_BBS,
    WP_OWNER_APPS
} WPMod;

@interface WPListViewHandler : NSObject {
    WPListController *_wpListController;
}

@property (nonatomic, retain) WPListController *wpListController;

- (void)closeList;

- (void)removeListWebView;

- (UIView *)getListContentView;

+ (WPListViewHandler *)sharedWPListViewHandler;

- (void)showListWithController:(UIViewController *)controller;

- (void)showListWithController:(UIViewController *)controller animated:(BOOL)animated;

- (void)showListWithController:(UIViewController *)vController showNavBar:(BOOL)visible;

- (void)showListWithController:(UIViewController *)controller navBar:(UIView *)userNavBar;

- (void)showListWithUserURL:(NSString *)url Controller:(UIViewController *)controller;

- (void)showFeedBackWithController:(UIViewController *)controller;

- (void)loadViewWithUserURL:(NSString *)url Controller:(UIViewController *)controller;

@end


@interface AppConnect (WPListViewHandler)

#pragma mark -
#pragma mark offer主要调用方法

+ (void)closeList;

+ (void)showList:(UIViewController *)controller;

+ (void)showList:(UIViewController *)controller animated:(BOOL)animated;

+ (void)showList:(UIViewController *)controller showNavBar:(BOOL)visible;

+ (UIView *)getListContentView;

+ (void)showList:(UIViewController *)controller navBar:(UIView *)userNavBar;

+ (void)showListWithURL:(NSString *)url Controller:(UIViewController *)viewController;

+ (void)showFeedBack:(UIViewController *)controller;

+ (void)loadViewWithURL:(NSString *)url Controller:(UIViewController *)controller;

@end