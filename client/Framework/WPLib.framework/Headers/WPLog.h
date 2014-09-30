#import <UIKit/UIKit.h>

#define LOG_SILENT 0
#define LOG_DEBUG 10
#define LOG_URL_DEBUG 20
#define LOG_CLICK_DEBUG 30
#define LOG_ACTIVE_DEBUG 40
#define LOG_EXCEPTION 50
#define LOG_NONFATAL_ERROR 60
#define LOG_ALL 70

@interface WPLog : NSObject {

}

+ (void)setLogThreshold:(int)myThreshhold;

+ (void)logWithLevel:(int)myLevel format:(NSString *)myFormat, ...;
@end
