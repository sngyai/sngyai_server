//
//  AppDelegate.h
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "TaskTableViewController.h"
#import "RootViewController.h"
#import "ChanceAd.h"
#import "InfoTableViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]

#define NAVIGATION_BACKGROUND [UIColor colorWithRed:0.0/255.0 green:157.0/255.0 blue:164.0/255.0 alpha:1.0]

@interface AppDelegate : UIResponder
<
    UIApplicationDelegate,
    UITabBarControllerDelegate,
    ASIHTTPRequestDelegate
>
{
    RootViewController *_tabBar;
//    BOOL _isBackGround;
}

@property (retain, nonatomic) UIWindow *window;
@property(nonatomic,copy)RootViewController *tabBar;
@end
