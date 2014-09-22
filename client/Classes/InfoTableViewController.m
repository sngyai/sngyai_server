//
//  InfoTableViewController.m
//  LiZhuan
//
//  Created by sngyai on 14-8-30.
//
//

#import "InfoTableViewController.h"
#import "MJRefresh.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil)
    {
        UITabBarItem * item = [[UITabBarItem alloc]
                               initWithTitle:@"个人中心" image:[UIImage imageNamed:@"user_enabled"] tag:0];
        self.tabBarItem = item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"任务记录" style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(showTaskLog)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"兑换记录" style:UIBarButtonItemStylePlain
                                                                       target:self action:@selector(showExchangeLog)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
    [self.navigationController.navigationBar setTintColor:[UIColor purpleColor]];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATION_BACKGROUND];
//    [self.tabBarController.tabBar setBarTintColor:NAVIGATION_BACKGROUND];

    [self setupRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [self.tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"刷新积分";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
        [tabBarController queryScore];
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myId = @"Info Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:myId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                RootViewController  *tabBarController = (RootViewController*)(self.tabBarController);
                
                NSString *totalScore = [NSString stringWithFormat:@"用户总积分:\t %@", tabBarController.score];
                cell.textLabel.text = totalScore;
                cell.userInteractionEnabled = NO;
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"账户设置";
            }
            
            return cell;
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"积分兑换";
            }
            return cell;
            break;
        default:
            return cell;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return @"账户总览";
        case 1:
            return @"积分兑换";
        default:
            return @"Unknown";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    [self showAccountSettings];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self showExchangeView];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
	
}

//账户设置
-(void) showAccountSettings{
    UIViewController *controller = [[AccountSettingsViewController alloc] init];
    if(controller){
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//任务记录
-(void) showTaskLog{
    UIViewController *controller = [[TaskLogTableTableViewController alloc] init];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}
//兑换记录
-(void) showExchangeLog{
    UIViewController *controller = [[ExchangeLogTableViewController alloc] init];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}
//积分兑换
-(void) showExchangeView{
    UIViewController *controller = [[ExchangeViewController alloc] init];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


@end
