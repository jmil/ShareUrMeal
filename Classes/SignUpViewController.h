//
//  RootViewController.h
//  SUMSignUp
//
//  Created by Corey Floyd on 8/25/09.
//  Copyright Flying Jalapeno Software 2009. All rights reserved.
//

#import "IFGenericTableViewController.h"


extern NSString *const didSignUpNotification; 

@class ASINetworkQueue;
@class LoadingView;

@interface SignUpViewController : IFGenericTableViewController {
    
    ASINetworkQueue *networkQueue;
    LoadingView *loadingView;
    
}

- (void)signUp;
- (void)addCancelButton;

@end
