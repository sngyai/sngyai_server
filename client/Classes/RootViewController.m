//
//  RootViewController.m
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import "RootViewController.h"
#import "MiidiManager.h"
#import "MiidiWallViewController.h"
#import "CodeAdViewController_iPhone.h"
#import "MiidiAdSpot.h"
#import "MiidiWallViewController.h"
#import "MiidiAdWall.h"
#import "AdSourceViewController.h"
#import "YouMiWall.h"


@interface RootViewController ()

@end


@implementation RootViewController


#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //
	guomobwall_vc=[[GuoMobWallViewController alloc] initWithId:@"1igkea2wocd3978"];
    //设置代理
    guomobwall_vc.delegate=self;
    
    //设置果盟定时查询是否获得积分
    guomobwall_vc.updatetime=30;
    
    //设置有米获取积分监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];

    //设置标题和返回
	self.navigationItem.title = @"利赚-手机赚钱";
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
	backButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = backButtonItem; 
	[backButtonItem release];
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Miidi Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"米迪积分墙";
    } 
	
	else if (indexPath.row == 1) {
        cell.textLabel.text = @"有米积分墙";
    }
	
	else if (indexPath.row == 2) {
        cell.textLabel.text = @"果盟积分墙";
    }
	
	   
    return cell;
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
	
		
	switch (indexPath.row) {
		case 0: //米迪积分墙[下应用奖励积分]
            [MiidiAdWall showAppOffers:self withDelegate:self];
			break;
        case 1:
            [YouMiWall showOffers:YES didShowBlock:^{
                NSLog(@"有米积分墙已显示");
            } didDismissBlock:^{
                NSLog(@"有米积分墙已退出");
            }];
            break;
        case 2:
            [guomobwall_vc pushGuoMobWall:YES Hscreen:NO];
            break;
		default:
			break;
	}
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil)
    {
        UITabBarItem * item = [[UITabBarItem alloc]
                               initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
        item.badgeValue = @"新";
        self.tabBarItem = item;
    }
    return self;
}




#pragma mark -
#pragma mark Memory management

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
	[versionTipView_ release];
	//
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

- (void)didReceiveGetPoints:(NSInteger)totalPoints forPointName:(NSString*)pointName{
	NSLog(@"didReceiveGetPoints success! totalPoints:%d",totalPoints);
	
	[self alertMessage:[NSString stringWithFormat:@"卧槽看到总分了（米迪）, 总积分 %d !",totalPoints]];
    UILocalNotification *localnotification=[[UILocalNotification alloc] init];
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

- (void)didFailReceiveGetPoints:(NSError *)error{
	NSLog(@"didFailReceiveGetPoints failed!");
	
	[self alertMessage:@"卧槽没获取到总分（米迪）~~~~~~~~~~~~~~~~~~~~~~~~~~~"];
}

// 有米
- (void)pointsGotted:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSNumber *freshPoints = [dict objectForKey:kYouMiPointsManagerFreshPointsKey];
    NSLog(@"积分信息：%@", dict);
    if([freshPoints intValue] > 0){
        int *points = [YouMiPointsManager pointsRemained];
        UILocalNotification *localnotification=[[UILocalNotification alloc] init];
        if (localnotification!=nil) {
        
            NSDate *now=[NSDate new];
            localnotification.fireDate=now;
            localnotification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
        
            localnotification.timeZone=[NSTimeZone defaultTimeZone];
            localnotification.soundName = UILocalNotificationDefaultSoundName;
            localnotification.alertBody=[NSString stringWithFormat:@"有米获得%@积分，有米总积分%d", freshPoints, *points];
        
            localnotification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
            //下面设置本地通知发送的消息，这个消息可以接受
            NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
            localnotification.userInfo = infoDic;
            //发送通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];
        }
    }
//    // 手动积分管理可以通过下面这种方法获得每份积分的信息。
//    NSArray *pointInfos = dict[kYouMiPointsManagerPointInfosKey];
//    for (NSDictionary *aPointInfo in pointInfos) {
//        // aPointInfo 是每份积分的信息，包括积分数，userID，下载的APP的名字
//        NSLog(@"积分数：%@", aPointInfo[kYouMiPointsManagerPointAmountKey]);
//        NSLog(@"userID：%@", aPointInfo[kYouMiPointsManagerPointUserIDKey]);
//        NSLog(@"产品名字：%@", aPointInfo[kYouMiPointsManagerPointProductNameKey]);
//        
//        // TODO 按需要处理
//    }
}

//果盟
- (void)checkPoint:(NSString *)appname point:(int)point
{
    if (point > 0) {
        UILocalNotification *localnotification=[[UILocalNotification alloc] init];
        NSLog(@"入口：%@", localnotification);
        if (localnotification!=nil) {
            NSLog(@"内部：%@", localnotification);
            NSDate *now=[NSDate new];
            localnotification.fireDate=now;
            
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
        NSLog(@"出口：%@", localnotification);
    }
}

-(void) alertMessage:(NSString*)msg{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"warning"
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


@end



