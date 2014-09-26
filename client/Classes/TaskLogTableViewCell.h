//
//  TaskLogTableViewCell.h
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-27.
//
//

#import <UIKit/UIKit.h>

@interface TaskLogTableViewCell : UITableViewCell
{
    UILabel* _dateField;
    UILabel* _channelField;
    UILabel* _appNameField;
    UILabel* _scoreField;
}
@property(strong) UILabel* dateField;
@property(strong) UILabel* channelField;
@property(strong) UILabel* appNameField;
@property(strong) UILabel* scoreField;
@end
