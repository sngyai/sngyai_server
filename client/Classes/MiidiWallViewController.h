//
//  MiidiWallViewController.h
//  MiidiSdkSample
//
//  Created by xuyi on 14-2-27.
//
//

#import <UIKit/UIKit.h>
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"

@interface MiidiWallViewController : UITableViewController <MiidiAdWallShowAppOffersDelegate
                                                            , MiidiAdWallAwardPointsDelegate
                                                            , MiidiAdWallSpendPointsDelegate
                                                            , MiidiAdWallGetPointsDelegate
                                                            , MiidiAdWallRequestToggleDelegate
                                                            >

@end
