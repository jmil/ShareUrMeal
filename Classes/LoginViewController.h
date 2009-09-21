//
//  LoginViewController.h
//  ShareUrMeal
//
//  Created by Corey Floyd on 9/2/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFGenericTableViewController.h"

@class ASINetworkQueue;
@class LoadingView;

extern NSString *const didLoginNotification; 

@interface LoginViewController : IFGenericTableViewController {
    
    ASINetworkQueue *networkQueue;
    LoadingView *loadingView;

}

- (void)login;

@end

