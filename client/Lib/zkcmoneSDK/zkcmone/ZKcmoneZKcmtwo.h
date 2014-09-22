//
//  ZKcmoneZKcmtwo.h
//  ZKcmoneZKcmtwo
//
//  Created by zenny_chen on 13-5-9.
//  Copyright (c) 2013年 zenny_chen. All rights reserved.
//

#ifndef ZKcmoneZKcmtwo_ZKcmoneZKcmtwo_h
#define ZKcmoneZKcmtwo_ZKcmoneZKcmtwo_h

#import <UIKit/UIKit.h>

// 当前ZKcmone泡泡糖版本号——2.2.0
#define ZKCMONEOW_SDK_VERSION_VALUE                230
#define ZKCMONEOW_SDK_VERSION              0x230

// ZKcmone泡泡糖返回的错误码
enum ZKCMONE_ZKCM_TWO_ERRORCODE
{
    ZKCMONE_ZKCM_TWO_ERRORCODE_SUCCESS,                      // 0: 状态成功
    ZKCMONE_ZKCM_TWO_ERRORCODE_ZKCMTWO_DISABLED,           // 1: 泡泡糖被禁用，或当前PID不存在
    ZKCMONE_ZKCM_TWO_ERRORCODE_LOGIN_CONNECTION_FAILED,      // 2: 登陆网络连接失败
    ZKCMONE_ZKCM_TWO_ERRORCODE_NOT_LOGINNED,                 // 3: 泡泡糖尚未登录
    ZKCMONE_ZKCM_TWO_ERRORCODE_NOT_INITIALIZED,              // 4: 泡泡糖未被初始化
    ZKCMONE_ZKCM_TWO_ERRORCODE_ALREADY_LOGINNING,            // 5: 泡泡糖已经在登录了
    ZKCMONE_ZKCM_TWO_ERRORCODE_UNKNOWN_ERROR,                // 6: 未知错误
    ZKCMONE_ZKCM_TWO_ERRORCODE_INVALID_FLAG,                 // 7: 无效的标志
    ZKCMONE_ZKCM_TWO_ERRORCODE_APPLIST_REQUEST_FAILED,       // 8: 请求应用列表失败
    ZKCMONE_ZKCM_TWO_ERRORCODE_APPLIST_RESPONSE_FAILED,      // 9: 请求应用列表响应失败
    ZKCMONE_ZKCM_TWO_ERRORCODE_APPLIST_PARAM_MALFORMAT,      // 10: 应用请求列表参数格式错误
    ZKCMONE_ZKCM_TWO_ERRORCODE_APPLIST_ALREADY_REQUESTING,   // 11: 应用列表已经在请求中
    ZKCMONE_ZKCM_TWO_ERRORCODE_ZKCMT_NOT_READY_FOR_SHOW,      // 12: 泡泡糖还没准备好来展示
    ZKCMONE_ZKCM_TWO_ERRORCODE_ZKCMT_KEYWORDS_MALFORMATTED,   // 13: 关键字格式错误
    ZKCMONE_ZKCM_TWO_ERRORCODE_ZKCMT_LACK_OF_SPACE_FOR_RESOURCE,  // 14: 用户磁盘空间不足，无法存放资源
    ZKCMONE_ZKCM_TWO_ERRORCODE_ZKCMT_RESOURCE_MALFORMATED,    // 15: 资源格式错误
    ZKCMONE_ZKCM_TWO_ERRORCODE_ZKCMT_RESOURCE_LOAD_FAILED,    // 16: 泡泡糖资源加载失败
    ZKCMONE_ZKCM_TWO_ERRORCODE_ALREADY_LOGINNED,             // 17: 泡泡糖已经登录
    ZKCMONE_ZKCM_TWO_ERRORCODE_EXCEED_MAX_SHOW_COUNT,        // 18: 超出当天泡泡糖最大展示次数
    ZKCMONE_ZKCM_TWO_ERRORCODE_EXCEED_MAX_INIT_COUNT,        // 19: 超出当天泡泡糖最大登录次数
    ZKCMONE_ZKCM_TWO_ERRORCODE_CURRENT_PTS_NOT_ENOUGH,    // 20: 当前泡泡不够消费
    ZKCMONE_ZKCM_TWO_ERRORCODE_PTS_CONSUMPTION_UNAVAILABLE,    // 21: 当前泡泡消费不可用
    
    ZKCMONE_ZKCM_TWO_ERRORCODE_PTS_CONSUMPTION_NEGATIVE,   // 22: 当前泡泡为负数
   
    ZKCMONE_ZKCM_TWO_ERRORCODE_PTS_ERROR,                  //23 当前分数不可用
    
    ZKCMONE_ZKCM_TWO_ERRORCODE_REQUEST_ERROR,                  //网络请求错误
    
    ZKCMONE_ZKCM_TWO_ERRORCODE_REQUEST_TOO_OFTEN                  //网络请求过于频繁

};

// 当前嵌泡泡糖应用的审核状态
enum ZKCMONE_ZKCM_TWO_REVIEW_STATE
{
    ZKCMONE_ZKCM_TWO_REVIEW_STATE_ZKCMTWO_DISABLED = -1,   // 当前泡泡糖被禁用，或PID不存在
    ZKCMONE_ZKCM_TWO_REVIEW_STATE_NOT_REVIEWED,              // 当前应用未被审核，处于测试状态
    ZKCMONE_ZKCM_TWO_REVIEW_STATE_NORMAL,                    // 当前泡泡糖正常使用
    ZKCMONE_ZKCM_TWO_REVIEW_STATE_REVIEWED_BUT_NOT_PASS,     // 当前应用审核未通过
    ZKCMONE_ZKCM_TWO_REVIEW_STATE_REVIEWING = 5              // 当前应用在审核中
};

// ZKcmone泡泡糖消息响应事件标志
enum ZKCMONE_ZKCM_TWO_RESPONSE_EVENTS
{
    // 泡泡糖弹出响应事件
    ZKCMONE_ZKCM_TWO_RESPONSE_EVENTS_ZKCMT_PRESENT = 0x1 << 0,
    // 泡泡糖退出响应事件
    ZKCMONE_ZKCM_TWO_RESPONSE_EVENTS_ZKCMT_DISMISS = 0x1 << 1,
    // 泡泡糖刷新总泡泡响应事件
    ZKCMONE_ZKCM_TWO_REFRESH_PT = 0x1 << 2,
    // 泡泡糖消费响应事件
    ZKCMONE_ZKCM_TWO_CONSUMEPTS_PT = 0x1 << 3,
    // 泡泡糖更新信息获取事件
    ZKCMONE_ZKCM_TWO_SUZKCMARY_MESSAGE = 0x1 << 4,
};

// ZKcmone泡泡糖禁止使用特征
enum ZKCMONE_ZKCM_TWO_DISABLED_FEATURES
{
    // 禁用StoreKit
    ZKCMONE_ZKCM_TWO_DISABLED_FEATURES_STORE_KIT = 0x1 << 0,
    //禁用loaction
    ZKCMONE_ZKCM_TWO_DISABLED_FEATURES_LOCATION = 0x1 << 1
};

#ifdef __cplusplus
extern "C" {
#endif
    
/** 呈现ZKcmone泡泡糖；若能成功展现泡泡糖则返回YES，否则返回NO
    * 参数：
     * pid——给嵌泡泡糖的开发者所提供的唯一的泡泡糖发布ID，即publish ID。pid会做retain操作，因此如果开发者使用了alloc方法的NSString对象的话，需要调用release。
     * baseViewController——基视图控制器。ZKcmone泡泡糖SDK将通过此对象来弹出泡泡糖视图控制器
*/
extern BOOL ZKcmoneOWPresentZKcmtwo(NSString *pid,UIViewController *baseViewController);

/** 设置关键字
 * 参数：关键字数组。
    每个元素都必须是一个NSString*对象,用于特殊广告对象。
*/
extern BOOL ZKcmoneOWSetKeywords(NSArray *keywords);

/*刷新服务器上的最新泡泡，开发者调用这个接口，可以获得服务器最新的总泡泡数
    此方法必须配合 泡泡糖消费响应事件ZKCMONE_ZKCM_TWO_REFRESH_PT使用，开发者使用响应事件获得该接口响应是否成功，可以通过ZKcmoneOWFetchLatestErrorCode()函数来查看错误状态信息。
    若响应事件ZKcmoneOWFetchLatestErrorCode返回为ZKCMONE_ZKCM_TWO_ERRORCODE_SUCCESS说明获取刷新成功，否则刷新获取失败。*/
extern void ZKcmoneOWRefreshPoint();

/** 查询ZKcmone泡泡糖最近服务器上得更新信息
    此方法必须配合 泡泡糖消费响应事件ZKCMONE_ZKCM_TWO_SUZKCMARY_MESSAGE使用，开发者使用响应事件获得该接口响应是否成功，可以通过ZKcmoneOWFetchLatestErrorCode()函数来查看错误状态信息。
      若响应事件ZKcmoneOWFetchLatestErrorCode返回为ZKCMONE_ZKCM_TWO_ERRORCODE_SUCCESS说明获取信息成功，否则获取信息失败。*/
extern void ZKcmoneOWRefreshSummeryMessage();

/*获取ZKcmone泡泡糖最近服务器上得更新信息
 
 开发者可以获取的信息为 :
 {
 "numOfAds" : int,               // 可用的广告数量
 "numOfNewAds" : string,         // 新广告的数量
 "avgPoint" : string,            // 每个广告的平均泡泡
 "maxPoint" : double,            // 最大的泡泡数
 "errordesc" : string,           // errorcode不为0时，错误描述
 "errorcode" : int               // 0表示成功，1表示未知错误，2表示此接口关闭状态
 “currencyUnit”:string,          //当前金币名称
 “totalPoint”:int ,              //总泡泡数
 “tradeRatio”:double          //兑换比例
 }
 */
    
NSDictionary *ZKcmoneOWGetSummaryMessage(void);

    /** 泡泡消费，该接口返回为YES说明消费状态正常，否则说明消费状态不可用：
     此方法必须配合 泡泡糖消费响应事件ZKCMONE_ZKCM_TWO_CONSUMEPTS_PT使用，开发者使用响应事件获得该接口响应是否成功，可以通过ZKcmoneOWFetchLatestErrorCode()函数来查看错误状态信息。
     若响应事件ZKcmoneOWFetchLatestErrorCode返回为ZKCMONE_ZKCM_TWO_ERRORCODE_SUCCESS说明消费成功，否则消费失败。*/
extern BOOL ZKcmoneOWConsumePoints(NSInteger value);
    
    
    /* 当前泡泡获取接口，该接口返回为YES说明泡泡糖状态正常，否则说明泡泡糖状态不可用。
     开发者若要获得当前服务器的最新总泡泡，需要再调用此接口之前调用泡泡刷新接口
     参数：
     * pRemainPoints：传出当前剩余泡泡。该值为当前泡泡剩余减去消费泡泡（value）后的值。
     */
    
BOOL ZKcmoneOWGetCurrentPoints( NSInteger *pRemainPoints);
    
/* 获取ZKcmone泡泡糖最近一次的错误码 */
extern enum ZKCMONE_ZKCM_TWO_ERRORCODE ZKcmoneOWFetchLatestErrorCode(void);

    
    
/** 查询当前嵌泡泡糖的应用的审核状态
 * 参数：
 * pOutState：输出审核状态的枚举值
*/
extern BOOL ZKcmoneOWCheckCurrentReviewState(enum ZKCMONE_ZKCM_TWO_REVIEW_STATE *pOutState);

/** 注册一个指定的响应事件。如果注册成功则返回YES，否则返回NO
 * 参数：
 * theEvent——相应的事件标志
 * target——事件触发后给所指定的对象发送消息
 * aSelector——事件触发后所要回调的方法。该原型必须与相应接口描述中所给出的回调方法的原型一致
 * 注：若先前已经注册了相应事件响应的target和selector，那么使用此接口将会覆盖先前所注册的target和selector
 * target参数不会被retain，因此如果你要彻底销毁此对象，那么在此之前必须先调用ZKcmoneOWUnregisterResponseEvents接口
   来注销相应事件的响应
*/
extern BOOL ZKcmoneOWRegisterResponseEvent(enum ZKCMONE_ZKCM_TWO_RESPONSE_EVENTS theEvent, NSObject *target, SEL aSelector);

/** 注销一组指定的响应事件。如果注销成功则返回YES，否则返回NO
 * 参数：
 * events——用按位或（|）所连接的一组ZKCMONE_ZKCM_TWO_RESPONSE_EVENTS事件，比如：
 ZKCMONE_ZKCM_TWO_RESPONSE_EVENTS_ZKCMT_PRESENT | ZKCMONE_ZKCM_TWO_RESPONSE_EVENTS_ZKCMT_DISMISS
 当然，也可只指定一个事件
 * 注：当开发者在销毁一个已经注册的target对象之前必须注销此相应事件。一般可以在- (void)dealloc方法中做注销。
*/
extern BOOL ZKcmoneOWUnregisterResponseEvents(unsigned events);

/** 禁用一些iOS系统特征
 * 参数：
 * features——用按位或（|）所连接的一组ZKCMONE_ZKCM_TWO_DISABLED_FEATURES特征
*/
extern BOOL ZKcmoneOWDisableFeatures(unsigned features);

#ifdef __cplusplus
}
#endif


#endif
