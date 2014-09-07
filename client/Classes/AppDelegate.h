//
//  AppDelegate.h
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "TaskTableViewController.h"
#import "RootViewController.h"
#import "PunchBoxAd.h"
#import "InfoTableViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface AppDelegate : UIResponder
<
    UIApplicationDelegate,
    UITabBarControllerDelegate,
    ASIHTTPRequestDelegate
>
{
    RootViewController *_tabBar;
    BOOL _isBackGround;
}

+(void)queryScore;

@property (retain, nonatomic) UIWindow *window;
@property(nonatomic,copy)RootViewController *tabBar;
@end
