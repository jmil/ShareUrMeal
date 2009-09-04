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

@class LoadingView;


@interface ShareViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
	UIImageView *imageView;
	UIButton *resendPhotoButton;
	UILabel *photoSendSuccess;
	UILabel *photoSendFail;
	UIImageView *splashImage;
    
        LoadingView *loadingView;
	
	// -- stuff for the action sheet.  seems ugly but I couldn't find a better way;
	NSInteger choosePhotoFromLibraryButtonIndex;
	NSInteger takePhotoWithCameraButtonIndex;
	NSInteger cancelButtonIndex;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *resendPhotoButton;
@property (nonatomic, retain) IBOutlet UILabel *photoSendSuccess;
@property (nonatomic, retain) IBOutlet UILabel *photoSendFail;

-(void) fadeSplashImage;

-(IBAction) getPhoto2:(id) sender;

@end
