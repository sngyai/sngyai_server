//
//  TaskLogTableViewCell.m
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-27.
//
//

#import "TaskLogTableViewCell.h"

@implementation TaskLogTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self) {
        self.dateField = [[UILabel alloc]
                          initWithFrame:CGRectMake(5 , 5 , 180 , 20)];
        self.dateField.textAlignment = NSTextAlignmentRight;
        self.dateField.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.dateField];
        
		
        self.scoreField = [[UILabel alloc]
                           initWithFrame:CGRectMake(180 , 5 , 180 , 20)];
		self.scoreField.textAlignment = NSTextAlignmentLeft;
        self.scoreField.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.scoreField];
        
        self.channelField = [[UILabel alloc]
                               initWithFrame:CGRectMake(5 , 30 , 70 , 20)];
        self.channelField.textAlignment = NSTextAlignmentLeft;
        self.channelField.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.channelField];
        
        
        self.appNameField = [[UILabel alloc]
                           initWithFrame:CGRectMake(90 , 30 , 180 , 20)];
        self.appNameField.textAlignment = NSTextAlignmentLeft;
        self.appNameField.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.appNameField];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
