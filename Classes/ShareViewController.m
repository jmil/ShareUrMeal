//
//  ShareViewController.m
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "LoadingView.h"
#import "SDNextRunloopProxy.h"
#import "AboutViewController.h"
#import "AccountViewController.h"
#import "ShareUrMealAppDelegate.h"

#define kChoosePhotoSheetTag 12345

@interface ShareViewController ()
- (void)displayLoadingView;
- (void)removeLoadingView;
@end

@implementation ShareViewController

@synthesize emailer;
@synthesize postImage;
@synthesize loginBarButtonItem;

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
    self.emailer = nil;
	self.postImage = nil;
	self.loginBarButtonItem = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = @"ShareUrMeal";
	
//	UIBarButtonItem* composeBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose:)];
//	self.navigationItem.rightBarButtonItem = composeBarButtonItem;
//	[composeBarButtonItem release];
	
	UIBarButtonItem* loginItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginLogout:)];
	self.navigationItem.leftBarButtonItem = loginItem;
	self.loginBarButtonItem = loginItem;
	[loginItem release];
	
	
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated
{
	[self updateLoginLogoutButton];
	
	[super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Actions

-(IBAction) compose:(id) sender
{
	// reset indices
	choosePhotoFromLibraryButtonIndex = -1; 
	takePhotoWithCameraButtonIndex = -1;
    
	UIActionSheet* sheet = [[UIActionSheet alloc] init];
	sheet.delegate = self;
	sheet.tag = kChoosePhotoSheetTag;
	sheet.title = NSLocalizedString1( @"New Photo" );
	choosePhotoFromLibraryButtonIndex = [sheet addButtonWithTitle:NSLocalizedString1( @"Choose From Library" )];
	if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) 
	{
		takePhotoWithCameraButtonIndex = [sheet addButtonWithTitle:NSLocalizedString1( @"Take With Camera" )];
	}
	cancelButtonIndex = [sheet addButtonWithTitle:NSLocalizedString1( @"Cancel" )];
	sheet.cancelButtonIndex = cancelButtonIndex;	
	[sheet showInView:self.view];
	[sheet release];
}


-(IBAction) showAboutView:(id) sender
{
	AboutViewController *vc = [[AboutViewController alloc] init];
	[self presentModalViewController:vc animated:YES];
	[vc release];
}


- (IBAction) showAccountView:(id)sender
{
	AccountViewController* vc = [[AccountViewController alloc] init];
	[self presentModalViewController:vc animated:YES];
	[vc release];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if( actionSheet.tag == kChoosePhotoSheetTag )
	{
		if( buttonIndex == cancelButtonIndex )
			return;

		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		
		if( buttonIndex == takePhotoWithCameraButtonIndex ) {
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else {
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}

#pragma mark -
#pragma mark MFMailComposeViewController


- (void) composeMail
{        
    self.emailer = [[[MFMailComposeViewController alloc] init] autorelease];
    emailer.mailComposeDelegate = self;
    
    [emailer setSubject:@"sharing a great meal"];
    
    // Set up recipients
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* email = nil;
    email = [defaults objectForKey:kUserDefaultsPostEmailAddressKey];
    
    if (email==nil)
        email = kShareUrMealSubmitEmail;
    
    NSArray *toRecipients = [NSArray arrayWithObject:email]; 
    
    [emailer setToRecipients:toRecipients];

	// !!!: HACK: redraw the image to fix rotation problems
	UIGraphicsBeginImageContext(self.postImage.size);
	[self.postImage drawAtPoint:CGPointMake(0.0, 0.0)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    // Attach an image to the email
    NSData *myData = UIImageJPEGRepresentation(newImage, 1);
    [emailer addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"ShareUrMeal"];
	
    // Fill out the email body text
    NSString *emailBody = @"My meal!";
    [emailer setMessageBody:emailBody isHTML:NO];
    
    [[self nextRunloopProxy] removeLoadingView];    

    //BUG: simulator is either too fast or has a bug, if we present the mailer too quickly, we get a loop
    //so we introduce a significant delay when targeting the simulator
    
#if TARGET_IPHONE_SIMULATOR
    [self performSelector:@selector(launchMailer) withObject:nil afterDelay:1];
#else
    [[[self nextRunloopProxy] nextRunloopProxy] launchMailer];
#endif    
    
}

- (void)launchMailer{
    
    [self presentModalViewController:emailer animated:YES];
    
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    // Now we have dismissed the mail; if we clicked either send or cancel then we also want to dismiss the entire image picker!
    // Here controller is the controller of the mailComposeController, which is our imagepicker.
    // Since we have two nested modal view controllers we need to dismiss both of them. This can easily be achieved by dismissing the bottom one.
    // Since self is the rootViewController of the original modal view controller, then we can simply tell self to dismissModalViewControllerAnimated:YES!! This will cause both Mail and ImageViewController to both pop off and go away.
    
    // Notifies users about errors associated with the interface
    
    //    result = MFMailComposeResultFailed;
    //result = MFMailComposeResultSent;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            debugLog(@"Result: canceled");
            // If the user cancelled the email then revert back one level to allow her to pick another image
            [controller dismissModalViewControllerAnimated:YES];
            break;
        case MFMailComposeResultSaved:
            debugLog(@"Result: saved to drafts folder");
            [self dismissModalViewControllerAnimated:YES];
            break;
        case MFMailComposeResultSent:
            debugLog(@"Result: sent to outbox; will be delivered next time you check mail");
            // If the user pressed the Send button then shut all modal view controllers and revert back to ShareViewController properly; we do this by calling self rather than controller!
			[self dismissModalViewControllerAnimated:YES];
            break;
        case MFMailComposeResultFailed:
            debugLog(@"Result: message sending or delivery failed...");
            [self dismissModalViewControllerAnimated:YES];
            break;
        default:
            debugLog(@"Result: email was not sent; don't know why.");
            [self dismissModalViewControllerAnimated:YES];
            break;
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    // Add a new modal view controller to EMAIL PHOTO to the current UIImagePickerController, here named picker
    if (YES == [MFMailComposeViewController canSendMail]) {
        
        [[self nextRunloopProxy] displayLoadingView];
        [[[self nextRunloopProxy] nextRunloopProxy] composeMail];
        
    }        
    
    // Save to our Library ONLY IF FROM CAMERA!!
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:@"UIImagePickerControllerOriginalImage"], nil, nil, nil);
    }
    
    // Set the ImageView in ShareViewController to be the image we picked!
	self.postImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
    [self dismissModalViewControllerAnimated:YES];            
}


#pragma mark -
#pragma mark LoadingView


- (void)displayLoadingView{
    
    loadingView = [LoadingView loadingViewInView:self.view withText:@"Preparing photo..."];
    
}

- (void)removeLoadingView{
    
    [loadingView removeView];

}


#pragma mark -

- (IBAction) logout:(id)sender
{		
	[(ShareUrMealAppDelegate*)[[UIApplication sharedApplication] delegate] logout];
	[self updateLoginLogoutButton];
}


- (void) updateLoginLogoutButton
{
	if( ![(ShareUrMealAppDelegate*)[[UIApplication sharedApplication] delegate] isLoggedIn] )
	{
		self.loginBarButtonItem.title = NSLocalizedString(@"Login", @"Login button title");
	}
	else
	{
		self.loginBarButtonItem.title = NSLocalizedString(@"Logout", @"Logout button title");
	}
}


- (IBAction) loginLogout:(id)sender
{
	if( ![(ShareUrMealAppDelegate*)[[UIApplication sharedApplication] delegate] isLoggedIn] )
	{
		[self showAccountView:nil];
	}
	else
	{
		
		UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you wish to logout?", @"Logout confirmation message")
															  message:nil
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button title")
													otherButtonTitles:NSLocalizedString(@"Logout", @"Logout button title"), nil];
		[logoutAlert show];
		[logoutAlert release];
	}
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

	// TODO: verify that it is the logout alert
	
	if( buttonIndex != alertView.cancelButtonIndex )
	{
		[self logout:nil];
	}
}


@end
