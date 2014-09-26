//
//  TaskLogTableTableViewController.h
//  LiZhuan
//
//  Created by sngyai on 14-9-7.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "MJRefresh.h"
#import "TaskLog.h"

@interface TaskLogTableTableViewController : UITableViewController
<UITableViewDataSource>
{
    NSMutableArray *tasks;
}

+(NSString*) getChannelStr:(int)channel;
@property (retain, nonatomic) IBOutlet UITableView *table;

@end
