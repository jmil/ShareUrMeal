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

@interface LoginViewController : IFGenericTableViewController {
    
    ASINetworkQueue *networkQueue;

}

@end
