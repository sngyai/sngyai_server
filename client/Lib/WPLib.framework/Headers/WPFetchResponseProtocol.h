#import <Foundation/Foundation.h>
#import "WPTBXML.h"

@class WPCoreFetcher;

typedef enum WPResponseError {
    kWPInternetFailure = 0,
    kWPStatusNotOK = 1,
    kWPRequestTimeOut = 2
} WPResponseError;

@protocol WPFetchResponseDelegate <NSObject>
@required

- (void)fetchResponseSuccessWithData:(WPCoreFetcher *)dataObj withRequestTag:(int)aTag;

- (void)fetchResponseError:(WPResponseError)errorType errorDescription:(id)errorDescObj requestTag:(int)aTag;
@end

