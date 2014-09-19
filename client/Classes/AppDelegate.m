//
//  AppDelegate.m
//  LiZhuan
//
//  Created by sngyai on 14-8-27.
//
//

#import "AppDelegate.h"
#import <AdSupport/ASIdentifierManager.h>
#import "Reachability.h"



@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    NSString *StringUrlPing = @"www.apple.com";
    Reachability *r = [Reachability reachabilityWithHostName:StringUrlPing];

    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            break;
        case ReachableViaWWAN:
            [self loadView];
            break;
        case ReachableViaWiFi:
            [self loadView];
            break;
    }
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier background_task;
    //Create a task object
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
        [self hold];
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) DeviceToken
{
    NSString *pushToken = [[[[DeviceToken description]
                             
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;

    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString* StrUser = [[NSString stringWithFormat:@"user/?msg=1003&user_id=%@", adId]stringByAppendingString:[NSString stringWithFormat:@"&tokens=%@", pushToken]];
    NSString* StrUrl = [HOST stringByAppendingString:StrUser];
    
    NSURL *url = [NSURL URLWithString:StrUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *object = [response objectFromJSONString];//获取返回数据，有时有些网址返回数据是NSArray类型，可先获取后打印出来查看数据结构，再选择处理方法，得到所需数据
        
        NSLog(@"HELLO, WORLD ***object:%@", object);
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }

    [self alertMessage:[NSString stringWithFormat:@"我的设备ID: %@", pushToken]];
    
//    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
//    // Subscribe this user to the broadcast channel, ""
//    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"Successfully subscribed to the broadcast channel.");
//        } else {
//            NSLog(@"Failed to subscribe to the broadcast channel.");
//        }
//    }];
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)errorReason
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString* StrUser = [[NSString stringWithFormat:@"user/?msg=1003&user_id=%@", adId]stringByAppendingString:[NSString stringWithFormat:@"&tokens=%@", errorReason]];
    NSString* StrUrl = [HOST stringByAppendingString:StrUser];
    
    NSURL *url = [NSURL URLWithString:StrUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *object = [response objectFromJSONString];//获取返回数据，有时有些网址返回数据是NSArray类型，可先获取后打印出来查看数据结构，再选择处理方法，得到所需数据
        
        NSLog(@"HELLO, WORLD ***object:%@", object);
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }
    [self alertMessage:[NSString stringWithFormat:@"注册失败，无法获取设备ID, 具体错误: %@", errorReason]];
}

-(void) alertMessage:(NSString*)msg{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"warning"
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)hold
{
    NSLog(@"hold enter");
    _isBackGround = YES;
    NSLog(@"hold inner");
    while (_isBackGround) {
        NSLog(@"running ~~~~~~~~~~~~~~");
        [NSThread sleepForTimeInterval:1];
        /** clean the runloop for other source */
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE);
    }
    NSLog(@"hold exit");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"enter foreground");
    _isBackGround = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}

- (void)loadView
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    TaskTableViewController *TaskController = [[[TaskTableViewController alloc] init] autorelease];
    UINavigationController *TaskNav = [[UINavigationController alloc] initWithRootViewController:TaskController];
    InfoTableViewController *InfoController = [[[InfoTableViewController alloc] init] autorelease];
    UINavigationController *InfoNav = [[UINavigationController alloc] initWithRootViewController:InfoController];
    
    _tabBar = [[[RootViewController alloc] init]autorelease];
    _tabBar.delegate = self;
    
    NSArray* controllerArray = [[NSArray alloc]initWithObjects:TaskNav,InfoNav,nil];
    _tabBar.viewControllers = controllerArray;
    [_tabBar.tabBarController.tabBar setBarTintColor:NAVIGATION_BACKGROUND];

    self.window.rootViewController = _tabBar;
    
    [self.window makeKeyAndVisible];
}

@end
