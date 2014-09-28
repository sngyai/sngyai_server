//
//  TaskLogTableTableViewController.m
//  LiZhuan
//
//  Created by sngyai on 14-9-7.
//
//

#import "TaskLogTableTableViewController.h"
#import "TaskLogTableViewCell.h"

@interface TaskLogTableTableViewController ()

@end

@implementation TaskLogTableTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务记录";
    
    tasks = [[NSMutableArray alloc]init];
    [tasks removeAllObjects];
//    self.table.dataSource = self;
//    self.table.delegate = self;
    [self setupRefresh];
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
    self.tableView.headerRefreshingText = @"刷新任务记录";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryTasks];
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";

    TaskLogTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if(cell == nil)
    {
        cell = [[TaskLogTableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    NSInteger rowNo = [indexPath row];
    
    cell.userInteractionEnabled = NO;
    TaskLog *this_task = [tasks objectAtIndex:rowNo];

    cell.dateField.text = this_task.date;
    cell.channelField.text = this_task.channel;
    cell.appNameField.text= this_task.appName;
    cell.scoreField.text = this_task.score;

    return cell;
}


- (void)queryTasks{
    //获取IDFA
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"HELLO, WORLD *********IDFA: %@", adId);
    
    NSString* StrUser = [NSString stringWithFormat:@"user/?msg=1002&user_id=%@", adId];
    NSString* StrUrl = [HOST stringByAppendingString:StrUser];
    
    NSURL *url = [NSURL URLWithString:StrUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *object = [response objectFromJSONString];
        [tasks removeAllObjects];
        for (NSDictionary *dic in object){
            NSDateFormatter *fromatter = [[[NSDateFormatter alloc] init] autorelease];
            [fromatter setDateFormat:@"MM-dd HH:mm"];

            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time"]intValue]];
            
            NSString *dateString = [fromatter stringFromDate:date];
            
            int channel = [[dic objectForKey:@"channel"]intValue];
            NSString *channelString = [[[NSString alloc]init]autorelease];
            channelString = [TaskLogTableTableViewController getChannelStr:channel];
            
            NSString *appNameString = [dic objectForKey:@"app_name"];
            
            NSString *cashString = [[dic objectForKey:@"score"]stringByAppendingString:@"积分"];
            
            TaskLog* new_task = [[TaskLog alloc] init];
            
            new_task.date = dateString;
            new_task.channel = channelString;
            new_task.appName = appNameString;
            new_task.score = cashString;
            
            [tasks addObject:new_task];
        }
        [self.tableView reloadData];
    }else{
        NSLog(@"HELLO, WORLD ***ERROR:%@", error);
    }
}

+(NSString*) getChannelStr:(int)channel
{
    NSString *channelString = [[[NSString alloc]init]autorelease];
    switch (channel) {
        case 0:
            channelString = @"安沃";
            break;
        case 1:
            channelString = @"有米";
            break;
        case 2:
            channelString = @"米迪";
            break;
        case 3:
            channelString = @"果盟";
            break;
        case 4:
            channelString = @"触控";
            break;
        case 5:
            channelString = @"多盟";
            break;
        case 6:
            channelString = @"艾德";
            break;
        case 7:
            channelString = @"巨朋";
            break;
        default:
            channelString = @"未知";
            break;
    }
    return channelString;
}

- (void)dealloc {
//    [_table release];
    [super dealloc];
}
@end
