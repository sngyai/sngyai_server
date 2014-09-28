//
//  CSRequestError.h
//  CSADSDK
//
//  Created by CocoaChina_yangjh on 13-11-1.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned int, CSRequestErrorCode) {
    // 1000~1999 为服务器端错误
    CSRequestErrorCode_Success,
    CSRequestErrorCode_NoServices = 1000,     // 服务未开启
    CSRequestErrorCode_HttpMethodError,       // http方法错误
    CSRequestErrorCode_InvalidParameter,      // 参数错误
    CSRequestErrorCode_InvalidPostData,       // POST数据错误
    CSRequestErrorCode_EventSwitchClosed,     // 事件关闭
    CSRequestErrorCode_ChanceClosed = 1005, // Chance关闭
    CSRequestErrorCode_NoAdGroup,             // 无广告适合的广告组
    CSRequestErrorCode_NoAdIdea,              // 无广告创意可用
    CSRequestErrorCode_NoIdeaURL,             // 创意URL不存在
    CSRequestErrorCode_NoAdTemplate,          // 广告模板不存在
    CSRequestErrorCode_AppClosed = 1010,      // App关闭
    CSRequestErrorCode_VersionClosed,         // App版本关闭
    CSRequestErrorCode_UnsupportedAdType,     // 未支持的广告类型
    CSRequestErrorCode_FrequentRequest,       // 频繁的请求
    CSRequestErrorCode_RegionSwitchClosed,    // 地域开关关闭
    CSRequestErrorCode_Cheat = 1015,          // 作弊
    CSRequestErrorCode_UncompressError = 1016,// 解压失败
    CSRequestErrorCode_NoCoin = 1030,         // 未得到积分
    // 2000~2999为SDK错误码
    CSRequestErrorCode_NetError = 2001,       // 网络错误
    CSRequestErrorCode_NoData,                // 服务器返回内容为空
    CSRequestErrorCode_Unknown = 9999,        // 未知错误
};

@interface CSRequestError : NSError

+ (NSString *)localizedDescriptionOf:(CSRequestErrorCode)errorCode;

@end
