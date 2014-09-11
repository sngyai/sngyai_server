//
//  RootViewController.m
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController


#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark View lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]; if (self) {
        // 创建积分墙管理器,这⾥里使⽤用的是测试 ID,请按照 User Guide ⽂文档中获取新的 PublisherID。
        _offerWallManager = [[DMOfferWallManager alloc] initWithPublisherID:@"96ZJ1IZAzeB0nwTBAd"];
    }
    return self; }

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //
	_guomobwall_vc=[[GuoMobWallViewController alloc] initWithId:@"1igkea2wocd3978"];
    _mobisagejoy = [[MobiSageJoyViewController alloc] initWithPublisherID:@"3c3e990aef814244824e648f024fd170"];
    //设置代理
    _guomobwall_vc.delegate = self;
    _mobisagejoy.delegate = self;
    _offerWallManager.delegate = self;
    
    //设置果盟定时查询是否获得积分
    _guomobwall_vc.updatetime=30;
    
    [NSThread detachNewThreadSelector:@selector(threadMethod) toTarget:self withObject:nil];
    [[CSAppZone sharedAppZone] loadAppZone:[CSADRequest request]];
    
    //设置有米获取积分监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
}

#pragma mark -
#pragma mark Table view data source

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    //多盟
	_offerWallManager.delegate = nil;
    [_offerWallManager release];
    _offerWallManager = nil;
    
    [super dealloc];
}

- (void)didReceiveAwardPoints:(NSInteger)totalPoints{
	NSLog(@"didReceiveAwardPoints success! totalPoints=%d",totalPoints);
	
	[self alertMessage:[NSString stringWithFormat:@"卧槽得分啦,用户总积分 %d !",totalPoints]];
	
}

- (void)didFailReceiveAwardPoints:(NSError *)error{
	NSLog(@"didFailReceiveAwardPoints failed!");
	
	[self alertMessage:@"卧槽得分失败啦~~~~~~~~~~~~~~~~~~~~~"];
	
}

//miidi
- (void)didReceiveGetPoints:(NSInteger)totalPoints forPointName:(NSString*)pointName{
	NSLog(@"didReceiveGetPoints success! totalPoints:%d",totalPoints);
	if (totalPoints > 0) {
        [MiidiAdWall requestSpendPoints:totalPoints withDelegate:self];
        
        UILocalNotification *localnotification=[[[UILocalNotification alloc] init]autorelease];
        if (localnotification!=nil) {
        
            NSDate *now=[NSDate new];
            localnotification.fireDate=now;
            localnotification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
        
            localnotification.timeZone=[NSTimeZone defaultTimeZone];
            localnotification.soundName = UILocalNotificationDefaultSoundName;
            localnotification.alertBody=[NSString stringWithFormat:@"米迪的%@积分，总积分%d", pointName, totalPoints];
        
            localnotification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
            //下面设置本地通知发送的消息，这个消息可以接受
            NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
            localnotification.userInfo = infoDic;
            //发送通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];
        }
    }
}

- (void)didFailReceiveGetPoints:(NSError *)error{
	NSLog(@"didFailReceiveGetPoints failed!");
}

// 有米
- (void)pointsGotted:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSArray *pointInfos = dict[kYouMiPointsManagerPointInfosKey];
    for (NSDictionary *aPointInfo in pointInfos) {
        // aPointInfo 是每份积分的信息，包括积分数，userID，下载的APP的名字
        
        NSLog(@"积分数：%@", aPointInfo[kYouMiPointsManagerPointAmountKey]);
        NSLog(@"userID：%@", aPointInfo[kYouMiPointsManagerPointUserIDKey]);
        NSLog(@"产品名字：%@", aPointInfo[kYouMiPointsManagerPointProductNameKey]);
        
        if([aPointInfo[kYouMiPointsManagerPointAmountKey] intValue] > 0){
            NSLog(@"积分信息：%@", dict);
            UILocalNotification *localnotification=[[[UILocalNotification alloc] init]autorelease];
            if (localnotification!=nil) {
                
                NSDate *now=[NSDate new];
                localnotification.fireDate=now;
                localnotification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
                
                localnotification.timeZone=[NSTimeZone defaultTimeZone];
                localnotification.soundName = UILocalNotificationDefaultSoundName;
                localnotification.alertBody=[NSString stringWithFormat:@"用户%@通过有米在应用%@获得%@积分",
                                             aPointInfo[kYouMiPointsManagerPointUserIDKey],
                                             aPointInfo[kYouMiPointsManagerPointProductNameKey],
                                             aPointInfo[kYouMiPointsManagerPointAmountKey] ];
                localnotification.soundName = UILocalNotificationDefaultSoundName;
                localnotification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
                
                //下面设置本地通知发送的消息，这个消息可以接受
                NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
                localnotification.userInfo = infoDic;
                //发送通知
                [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];
            }
        }
    }
}

//果盟
- (void)checkPoint:(NSString *)appname point:(int)point
{
    if (point > 0)
    {
        UILocalNotification *localnotification=[[[UILocalNotification alloc] init] autorelease];

        if (localnotification!=nil) {
            NSDate *now=[NSDate new];
            localnotification.fireDate=now;
            localnotification.soundName = UILocalNotificationDefaultSoundName;
            localnotification.timeZone=[NSTimeZone defaultTimeZone];
            localnotification.soundName = UILocalNotificationDefaultSoundName;
            localnotification.alertBody= [NSString stringWithFormat:@"果盟通过%@获得%d积分",appname,point];
            
            localnotification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
            
            //下面设置本地通知发送的消息，这个消息可以接受
            NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
            localnotification.userInfo = infoDic;
            //发送通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];
        }
    }
}

-(void)threadMethod

{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerDone) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [[NSRunLoop currentRunLoop] run];
}

-(void)timerDone
{
    [[CSAppZone sharedAppZone] queryRewardCoin:^(NSArray *taskCoins, CSRequestError *error) {
        [MiidiAdWall requestGetPoints:self];
        if (taskCoins.count > 0) {
            UILocalNotification *localnotification=[[[UILocalNotification alloc] init]autorelease];
            
            if (localnotification!=nil) {
                NSDate *now=[NSDate new];
                localnotification.fireDate=now;
                localnotification.soundName = UILocalNotificationDefaultSoundName;
                localnotification.timeZone=[NSTimeZone defaultTimeZone];
                localnotification.soundName = UILocalNotificationDefaultSoundName;
                NSMutableString *alertStr = [NSMutableString string];
                for (NSDictionary *dic in taskCoins) {
                    [alertStr appendFormat:@"%@:%@;", [dic objectForKey:@"taskContent"], [dic objectForKey:@"coins"]];
                }
                localnotification.alertBody = alertStr;
                
                localnotification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
                
                //下面设置本地通知发送的消息，这个消息可以接受
                NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
                localnotification.userInfo = infoDic;
                //发送通知
                [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];
            }
        }
    }];
}

-(void) alertMessage:(NSString*)msg{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"warning"
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

-(void) queryScore
{
    //获取IDFA
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"HELLO, WORLD *********IDFA: %@", adId);
    
    NSString* StrUser = [NSString stringWithFormat:@"user/?msg=1001&user_id=%@", adId];
    NSString* StrUrl = [HOST stringByAppendingString:StrUser];
    
    NSURL *url = [NSURL URLWithString:StrUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *object = [response objectFromJSONString];//获取返回数据，有时有些网址返回数据是NSArray类型，可先获取后打印出来查看数据结构，再选择处理方法，得到所需数据
        
        NSString *strScroreCur = [object objectForKey:@"score_current"];
        self.score = [[[NSNumber alloc] initWithInt:[strScroreCur intValue]] autorelease];
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }
}

@end



