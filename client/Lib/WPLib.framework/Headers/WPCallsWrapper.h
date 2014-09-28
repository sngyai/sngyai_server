#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WPCallsWrapper : UIViewController {
    UIInterfaceOrientation currentInterfaceOrientation;
}

@property(assign) UIInterfaceOrientation currentInterfaceOrientation;

+ (WPCallsWrapper *)sharedWPCallsWrapper;

- (void)updateViewsWithOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)moveViewToFront;

- (void)showBoxCloseNotification:(NSNotification *)notifierObj;
@end
