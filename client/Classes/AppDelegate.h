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

@interface AppDelegate : UIResponder
<
    UIApplicationDelegate,
    UITabBarControllerDelegate
>
{
    RootViewController *tabBar;
    BOOL _isBackGround;
}

@property (retain, nonatomic) UIWindow *window;

@end
