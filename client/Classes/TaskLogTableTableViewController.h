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

typedef struct TaskLog{
    NSString *date;
    NSString *channel;
    NSString *appName;
    NSString *score;
}TaskLog;

@interface TaskLogTableTableViewController : UITableViewController
<UITableViewDataSource>
{
    NSMutableArray *tasks;
}

+(NSString*) getChannelStr:(int)channel;

@end
