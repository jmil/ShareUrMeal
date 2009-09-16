//
//  ShareViewController.m
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"

#import "LoadingView.h"
#import "SDNextRunloopProxy.h"

#define kChoosePhotoSheetTag 12345

@implementation ShareViewController

@synthesize imageView, resendPhotoButton, photoSendFail, photoSendSuccess;
@synthesize emailer;


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
    
    self.emailer = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidUnload {
    
    self.imageView = nil;
    self.resendPhotoButton = nil;
    self.photoSendSuccess = nil;
    self.photoSendFail = nil;
    
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
    [super viewDidLoad];
    
    [self fadeSplashImage];
    
    // Initially set all to HIDE until we get last sent image saved in user Defaults or Core Data!
    self.photoSendFail.hidden = YES;
    self.photoSendSuccess.hidden = YES;
    self.resendPhotoButton.hidden = YES;
    
    
}

#pragma mark -
#pragma mark IBOutlet

-(IBAction) getPhoto2:(id) sender
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


#pragma mark -
#pragma mark Launch Image and Animation

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashImage removeFromSuperview];
    [splashImage release];
}



-(void)fadeSplashImage
{
    splashImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    splashImage.image = [UIImage imageNamed:@"Default3.png"];
    [self.view addSubview:splashImage];
    [self.view bringSubviewToFront:splashImage];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashImage.alpha = 0.0;
    [UIView commitAnimations];
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


- (void) composeMail{
        
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

    // Attach an image to the email
    NSData *myData = UIImageJPEGRepresentation(self.imageView.image, 1);
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
            self.photoSendFail.hidden = YES;
            self.resendPhotoButton.hidden = YES;
            self.photoSendSuccess.hidden = NO;
            
            
            // TODO: finish
            NSDate *now = [NSDate date];
            
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            
            NSString *formattedDateString = [dateFormatter stringFromDate:now];
            NSString *precedingString = @"Sent: ";
            NSString *completeFormattedString = [precedingString stringByAppendingString: formattedDateString];
            
            //NSString *theSentDateAndTime = [];
            //self.photoSendSuccess.text = @"Sent Aug 24 09, 8:32 pm";
            self.photoSendSuccess.text = completeFormattedString;
            
            [self dismissModalViewControllerAnimated:YES];
            break;
        case MFMailComposeResultFailed:
            debugLog(@"Result: message sending or delivery failed...");
            self.photoSendSuccess.hidden = YES;
            self.photoSendFail.hidden = NO;
            self.resendPhotoButton.hidden = NO;
            self.photoSendFail.text = @"Email Fail. Resend?";
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
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
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





@end
