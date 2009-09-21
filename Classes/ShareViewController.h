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

    LoadingView *loadingView;
    MFMailComposeViewController *emailer;
	
	// -- stuff for the action sheet.  seems ugly but I couldn't find a better way;
	NSInteger choosePhotoFromLibraryButtonIndex;
	NSInteger takePhotoWithCameraButtonIndex;
	NSInteger cancelButtonIndex;
}

@property (nonatomic,retain) MFMailComposeViewController *emailer;

-(IBAction) compose:(id) sender;

@end
