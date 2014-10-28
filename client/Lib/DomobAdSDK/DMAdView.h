//
//  DMAdView.h
//
//  Copyright (c) 2013 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// For iPhone
#define DOMOB_AD_SIZE_320x50    CGSizeMake(320, 50)
#define DOMOB_AD_SIZE_300x250   CGSizeMake(300, 250)

// For iPad
#define DOMOB_AD_SIZE_488x80    CGSizeMake(488, 80)
#define DOMOB_AD_SIZE_728x90    CGSizeMake(728, 90)
#define DOMOB_AD_SIZE_600x500   CGSizeMake(600, 500)

// For flexible banner
#define FLEXIBLE_SIZE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? CGSizeMake(0, 90):CGSizeMake(0, 50))


typedef enum
{
    DMUserGenderFemale,
    DMUserGenderMale
} DMUserGenderType;

@protocol DMAdViewDelegate;
@interface DMAdView : UIView

@property (nonatomic, assign) id <DMAdViewDelegate> delegate;
@property (nonatomic, assign) UIViewController *rootViewController;

// init ad view
- (id)initWithPublisherId:(NSString *)publisherId // Publisher ID
              placementId:(NSString *)placementId; // Placement ID

- (id)initWithPublisherId:(NSString *)publisherId // Publisher ID
              placementId:(NSString *)placementId // Placement ID
              autorefresh:(BOOL)autorefresh;      // set auto refresh

//新增设置size方法
- (void)setAdSize:(CGSize)adSize;

// load ad view
- (void)loadAd;

//Flexible专用的方法 用于横竖屏切换 移除原有视图 并重新请求
- (void)orientationChanged;

// The user's current location
- (void)setLocation:(CLLocation *)location;

// The user's postcode
- (void)setPostcode:(NSString *)postcode;

// The keyword of current activity
- (void)setKeywords:(NSString *)keywords;

// The user's birthday
- (void)setUserBirthday:(NSString *)userBirthday;

// The user's gender
- (void)setUserGender:(DMUserGenderType)userGender;

// Notification AdView, device orientation changes. If you need AdView automatically adjust itself attributes to support the direction of the change, you need to call this method when the device change the direction in your app
- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol DMAdViewDelegate <NSObject>
@optional
// Sent when an ad request success to loaded an ad
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView;
// Sent when an ad request fail to loaded an ad
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error;
// Sent when the ad view is clicked
- (void)dmAdViewDidClicked:(DMAdView *)adView;
// Sent just before presenting the user a modal view
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView;
// Sent just after dismissing the modal view
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView;
// Sent just before the application will background or terminate because the user's action
// (Such as the user clicked on an ad that will launch App Store).
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView;

@end
