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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateField = [[UILabel alloc]
                          initWithFrame:CGRectMake(5 , 5 , 200 , 20)];
        self.dateField.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.dateField];
        
		self.channelField = [[UILabel alloc]
                             initWithFrame:CGRectMake(5 , 30 , 70 , 20)];
        self.channelField.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.channelField];
        
        self.scoreField = [[UILabel alloc]
                           initWithFrame:CGRectMake(220 , 5 , 90 , 20)];
		self.scoreField.textAlignment = NSTextAlignmentRight;
        self.scoreField.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.scoreField];
        
        self.appNameField = [[UILabel alloc]
                           initWithFrame:CGRectMake(90 , 30 , 220 , 20)];
        self.appNameField.textAlignment = NSTextAlignmentRight;
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
