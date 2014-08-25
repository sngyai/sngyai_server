//
//  MiidiWallViewController.m
//  MiidiSdkSample
//
//  Created by xuyi on 14-2-27.
//
//

#import "MiidiWallViewController.h"
#import "MiidiAdWall.h"
#import "AdSourceViewController.h"

@interface MiidiWallViewController ()
@property (retain,nonatomic) AdSourceViewController *tableviewController;
@end

@implementation MiidiWallViewController
@synthesize tableviewController = _tableviewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil)
    {
        UITabBarItem * item = [[UITabBarItem alloc]
                               initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        self.tabBarItem = item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableviewController = [[AdSourceViewController alloc]initWithNibName:@"AdSourceViewController" bundle:nil];
    
    //
	
	//设置标题和返回
	self.navigationItem.title = @"米迪积分墙";
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
	backButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = backButtonItem;
	[backButtonItem release];
}

-(void) dealloc{
    self.tableviewController = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
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
        cell.textLabel.text = @"米迪广告墙 [下载应用奖励积分]";
    }
	
	else if (indexPath.row == 1) {
        cell.textLabel.text = @"消费100积分";
    }
	
	else if (indexPath.row == 2) {
        cell.textLabel.text = @"奖励100积分";
    }
	
	else if (indexPath.row == 3) {
        cell.textLabel.text = @"查询积分";
    }
	
	else if (indexPath.row == 4) {
        cell.textLabel.text = @"用户反馈";
    }
    
    else if(indexPath.row == 5){
        cell.textLabel.text = @"获取积分墙开关";
    }
   
    else if(indexPath.row == 6){
        cell.textLabel.text = @"获取数据源广告数组";
    }
    
    return cell;
	
}

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
		case 0: //米迪广告墙[下应用奖励积分]
			[MiidiAdWall showAppOffers:self withDelegate:self];
			break;
			
		case 1: // 消费100积分
			[MiidiAdWall requestSpendPoints:100 withDelegate:self];
			break;
			
		case 2: // 奖励100积分
			[MiidiAdWall requestAwardPoints:100 withDelegate:self];
			break;
			
		case 3: // 查询积分
			[MiidiAdWall requestGetPoints:self];
			break;
			
		case 4: // 用户反馈
			[MiidiAdWall showAppFeedback:self];
			break;
            
        case 5: // 积分墙开关
            [MiidiAdWall requestToggleOfAdWall:self];
			break;
            
        case 6: // 广告数据源
        {
            [MiidiAdWall requestAdSourcesWithBlock:^(NSArray * adDescArray, NSError * error) {
                if(adDescArray != nil && [adDescArray count] > 0){
                    
                    _tableviewController.adDescArray = adDescArray;
                    [self.navigationController pushViewController:_tableviewController animated:YES];
                    
                }
            }];
        }
            break;
		default:
			break;
	}
    
	
}


#pragma mark -
#pragma mark  MiidiAdWallShowAppOffersDelegate


// 请求应用列表成功
//
// 详解:
//      广告墙请求成功后回调该方法
// 补充:

//
- (void)didReceiveOffers{
}

// 请求应用列表失败
//
// 详解:
//      广告墙请求失败后回调该方法
// 补充:

//
- (void)didFailToReceiveOffers:(NSError *)error{
}

#pragma mark Screen View Notification Methods

// 显示全屏页面
//
// 详解:
//      全屏页面显示完成后回调该方法
// 补充:

//
- (void)didShowWallView{
}

// 隐藏全屏页面
//
// 详解:
//      全屏页面隐藏完成后回调该方法
// 补充:

//
- (void)didDismissWallView{
}

#pragma mark  end

#pragma mark  MiidiAdWallSpendPointsDelegate


- (void)didReceiveSpendPoints:(NSInteger)totalPoints{
	NSLog(@"didReceiveSpendPoints success! totalPoints=%d",totalPoints);
	
    [self alertMessage:[NSString stringWithFormat:@"消耗积分成功,用户总积分 %d !",totalPoints]];
	
	
}


- (void)didFailReceiveSpendPoints:(NSError *)error{
	NSLog(@"didFailReceiveSpendPoints failed!");
	
    [self alertMessage:@"消耗积分失败!!"];
		
}

#pragma mark  end

#pragma mark  MiidiAdWallAwardPointsDelegate


- (void)didReceiveAwardPoints:(NSInteger)totalPoints{
	NSLog(@"didReceiveAwardPoints success! totalPoints=%d",totalPoints);
	
	
	[self alertMessage:[NSString stringWithFormat:@"奖励积分成功,用户总积分 %d !",totalPoints]];
	
    
	
	
}

- (void)didFailReceiveAwardPoints:(NSError *)error{
	NSLog(@"didFailReceiveAwardPoints failed!");
	
    
	[self alertMessage:@"奖励积分失败!!"];
	
    
	
}
#pragma mark  end

#pragma mark  MiidiAdWallGetPointsDelegate


- (void)didReceiveGetPoints:(NSInteger)totalPoints forPointName:(NSString*)pointName{
	NSLog(@"didReceiveGetPoints success! totalPoints:%d",totalPoints);
	
	[self alertMessage:[NSString stringWithFormat:@"获取积分成功,用户总积分 %d !",totalPoints]];
	
    
	
	
}


- (void)didFailReceiveGetPoints:(NSError *)error{
	NSLog(@"didFailReceiveGetPoints failed!");
	
	
	[self alertMessage:@"获取积分失败!!"];
	
}
#pragma mark  end

#pragma mark MiidiAdWallRequestToggleDelegate
// 成功请求积分墙开关
//
// 详解:当接收服务器返回积分墙开关成功后调用该函数
// 补充：toggle: 返回积分墙是否开启
- (void)didReceiveToggle:(BOOL)toggle
{
    NSLog(@"didReceiveToggle success! toggle:%d",toggle);
    
    if(toggle){
        
        [self alertMessage:@"积分墙是开启状态!"];
    }
    
    else{
        
        [self alertMessage:@"积分墙是关闭状态!"];
    }
    
}

// 请求积分墙开关失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：
- (void)didFailReceiveToggle:(NSError *)error
{
    NSLog(@"didFailReceiveToggle failed!");
}



#pragma mark end


-(void) alertMessage:(NSString*)msg{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"warning"
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
@end
