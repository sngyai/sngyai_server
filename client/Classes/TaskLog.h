//
//  TaskLog.h
//  LiZhuan
//
//  Created by 杨玉东 on 14-9-27.
//
//

#import <Foundation/Foundation.h>

@interface TaskLog : NSObject
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *channel;
@property(nonatomic, copy) NSString *appName;
@property(nonatomic, copy) NSString *score;
@end