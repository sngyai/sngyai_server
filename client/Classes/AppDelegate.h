//
//  AppDelegate.h
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    RootViewController *tabBar;
    UIBackgroundTaskIdentifier myTask	;
}

@property (retain, nonatomic) UIWindow *window;
//@property (nonatomic, unsafe_unretained)
@property (nonatomic, strong) NSTimer *myTimer;
@end
