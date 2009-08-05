//
//  ShareViewController.m
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"


@implementation ShareViewController

@synthesize imageView, choosePhotoButton, takePhotoButton, sendMailButton;

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
    [picker dismissModalViewControllerAnimated:YES];
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save to our Library ONLY IF FROM CAMERA!!
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:@"UIImagePickerControllerOriginalImage"], nil, nil, nil);
    }
    
//    [self performSelector:@selector(showMailer) withObject:nil afterDelay:0.0];
}


// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(IBAction) showMailer:(id)sender {
        if (YES == [MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@"Loved it!"];
        
        
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"post@shareurmeal.com"]; 
        //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
        //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
        
        [picker setToRecipients:toRecipients];
        //[picker setCcRecipients:ccRecipients];	
        //[picker setBccRecipients:bccRecipients];
        
        // Attach an image to the email
        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
        NSData *myData = UIImagePNGRepresentation(self.imageView.image);
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"ShareUrMeal"];
        
        // Fill out the email body text
        NSString *emailBody = @"My meal!";
        [picker setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }    
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
        [self dismissModalViewControllerAnimated:YES];
    
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


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
