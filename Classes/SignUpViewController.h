//
//  RootViewController.h
//  SUMSignUp
//
//  Created by Corey Floyd on 8/25/09.
//  Copyright Flying Jalapeno Software 2009. All rights reserved.
//

#import "IFGenericTableViewController.h"

@class ASINetworkQueue;
@class LoadingView;

@interface SignUpViewController : IFGenericTableViewController {
    
    ASINetworkQueue *networkQueue;
    LoadingView *loadingView;
    
}

@end

extern NSString *const didSignUpNotification; 