//
//  ShareViewController.m
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"


@implementation ShareViewController

@synthesize imageView, choosePhotoButton, takePhotoButton, resendPhotoButton, photoSendFail, photoSendSuccess;

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



-(IBAction) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if((UIButton *) sender == choosePhotoButton) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
        
    // Add a new modal view controller to EMAIL PHOTO to the current UIImagePickerController, here named picker
    if (YES == [MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        
        [emailer setSubject:@"Loved it!"];
        
        
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:kShareUrMealSubmitEmail]; 
        //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
        //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
        
        [emailer setToRecipients:toRecipients];
        //[emailer setCcRecipients:ccRecipients];	
        //[emailer setBccRecipients:bccRecipients];
        
        // Attach an image to the email
        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
        NSData *myData = UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
        [emailer addAttachmentData:myData mimeType:@"image/png" fileName:@"ShareUrMeal"];
        
        // Fill out the email body text
        NSString *emailBody = @"My meal!";
        [emailer setMessageBody:emailBody isHTML:NO];
        
        [picker presentModalViewController:emailer animated:YES];
        [emailer release];
    }        
    
    // If we have cancelled an image Pick or image capture with camera, then also dismiss the modal view controller!
    // For some reason this doesn't affect anything; whether we have this or not...
    //[picker dismissModalViewControllerAnimated:YES];
    
    // Save to our Library ONLY IF FROM CAMERA!!
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:@"UIImagePickerControllerOriginalImage"], nil, nil, nil);
    }
    
    // Set the ImageView in ShareViewController to be the image we picked!
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    // Now we have dismissed the mail; if we clicked either send or cancel then we also want to dismiss the entire image picker!
    // Here controller is the controller of the mailComposeController, which is our imagepicker.
    // Since we have two nested modal view controllers we need to dismiss both of them. This can easily be achieved by dismissing the bottom one.
    // Since self is the rootViewController of the original modal view controller, then we can simply tell self to dismissModalViewControllerAnimated:YES!! This will cause both Mail and ImageViewController to both pop off and go away.
    
    // Notifies users about errors associated with the interface
    
//    result = MFMailComposeResultFailed;

    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            // If the user cancelled the email then revert back one level to allow her to pick another image
            [controller dismissModalViewControllerAnimated:YES];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved to drafts folder");
            [self dismissModalViewControllerAnimated:YES];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent to outbox; will be delivered next time you check mail");
            // If the user pressed the Send button then shut all modal view controllers and revert back to ShareViewController properly; we do this by calling self rather than controller!
            self.photoSendFail.hidden = YES;
            self.resendPhotoButton.hidden = YES;
            self.photoSendSuccess.hidden = NO;

            NSDate *now = [NSDate date];
            
            
            //NSString *theSentDateAndTime = [];
            self.photoSendSuccess.text = @"Sent Aug 24 09, 8:32 pm";
            
            [self dismissModalViewControllerAnimated:YES];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: message sending or delivery failed...");
            self.photoSendSuccess.hidden = YES;
            self.photoSendFail.hidden = NO;
            self.resendPhotoButton.hidden = NO;
            self.photoSendFail.text = @"Email Fail. Resend?";
            [self dismissModalViewControllerAnimated:YES];
            break;
        default:
            NSLog(@"Result: email was not sent; don't know why.");
            [self dismissModalViewControllerAnimated:YES];
            break;
    }
    
    
    
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        // Custom initialization
//        
//        self.title = @"Share View";
//        self.tabBarItem.image = [UIImage imageNamed:@"all.png"];
//
//        
//    }
//    return self;
//}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fadeSplashImage];

    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.takePhotoButton.hidden = YES;
    }
    
    // Initially set all to HIDE until we get last sent image saved in user Defaults or Core Data!
    self.photoSendFail.hidden = YES;
    self.photoSendSuccess.hidden = YES;
    self.resendPhotoButton.hidden = YES;
    

}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashImage removeFromSuperview];
    [splashImage release];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
