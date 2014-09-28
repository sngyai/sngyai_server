#import <Foundation/Foundation.h>
#import "AppConnect.h"

@interface WPRemotePush : NSObject
@end

@interface AppConnect (WPRemotePush)

+ (void)setupWithOption:(NSDictionary *)launchOptions viewController:(UIViewController *)rootVC;// 初始化

+ (void)registerForRemoteNotificationTypes;                                                     // 注册APNS类型

+ (void)registerDeviceToken:(NSData *)deviceToken;                                              // 向服务器上报Device Token

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;                                    // 处理收到的APNS消息，向服务器上报收到APNS消息

+ (void)handFailToRegisterForRemoteNotificationsWithError:(NSError *)error;                     // 处理注册失败

+ (void)setApplicationIconBadgeZero;                                                            // 设置应用角标为0

@end