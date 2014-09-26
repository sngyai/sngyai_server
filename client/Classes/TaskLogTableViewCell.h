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
@property(nonatomic,copy) UILabel* dateField;
@property(nonatomic,copy) UILabel* channelField;
@property(nonatomic,copy) UILabel* appNameField;
@property(nonatomic,copy) UILabel* scoreField;
@end
