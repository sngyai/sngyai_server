#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ATTRIBUTE_ICON           @"icon"
#define ATTRIBUTE_CLICK_URL      @"click_url"
#define ATTRIBUTE_TITLE          @"title"
#define ATTRIBUTE_TYPE           @"type"
#define ATTRIBUTE_POINTS_NAME    @"points_name"
#define ATTRIBUTE_POINTS         @"points"
#define ATTRIBUTE_BILL           @"bill"
#define ATTRIBUTE_VIEW_IMAGES    @"view_image"
#define ATTRIBUTE_AD_WORDS       @"ad_words"
#define ATTRIBUTE_TIP            @"tip"
#define ATTRIBUTE_SIZE           @"size"
#define ATTRIBUTE_VERSION        @"version"
#define ATTRIBUTE_BUTTON_TEXT    @"btn_txt"

@protocol WPListCustomDelegate;

@interface WPListCustom : NSObject <NSURLConnectionDelegate> {
    int responseCode_;
}
@property(nonatomic, retain) NSMutableData *listData;
@property(nonatomic, retain) NSURLConnection *listDataConnection;
@property(nonatomic, retain) id <WPListCustomDelegate> delegate;

- (void)loadCustomData;

- (void)listOnClick:(NSString *)url;

@end

@protocol WPListCustomDelegate
@optional
- (void)isLoading:(BOOL)flg;

- (void)getCustomDataWithJson:(NSString *)listJson;

- (void)getCustomDataWithArray:(NSArray *)listArray;

- (void)getCustomDataFaile:(NSString *)errorInfo;

- (void)onClickFaile:(NSError *)myError;
@end


