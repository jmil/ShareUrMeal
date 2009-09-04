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


@interface LoginViewController : IFGenericTableViewController {
    
    ASINetworkQueue *networkQueue;
    LoadingView *loadingView;

}

@end

extern NSString *const didLoginNotification; 