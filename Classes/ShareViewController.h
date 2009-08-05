//
//  ShareViewController.h
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ShareViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate> {
	UIImageView *imageView;
	UIButton *choosePhotoButton;
	UIButton *takePhotoButton;
    }
    
    @property (nonatomic, retain) IBOutlet UIImageView *imageView;
    @property (nonatomic, retain) IBOutlet UIButton *choosePhotoButton;
    @property (nonatomic, retain) IBOutlet UIButton *takePhotoButton;
    
    -(IBAction) getPhoto:(id) sender;
    
@end
