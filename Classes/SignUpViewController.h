//
//  RootViewController.h
//  SUMSignUp
//
//  Created by Corey Floyd on 8/25/09.
//  Copyright Flying Jalapeno Software 2009. All rights reserved.
//

#import "IFGenericTableViewController.h"

@class ASINetworkQueue;


@interface SignUpViewController : IFGenericTableViewController {
    
    ASINetworkQueue *networkQueue;

}

@end

extern NSString *const didSignUpNotification; 