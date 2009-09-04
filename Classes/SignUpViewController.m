//
//  RootViewController.m
//  SUMSignUp
//
//  Created by Corey Floyd on 8/25/09.
//  Copyright Flying Jalapeno Software 2009. All rights reserved.
//

#import "SignUpViewController.h"

#import "IFTemporaryModel.h"

#import "IFButtonCellController.h"
#import "IFTextCellController.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

#import "JSONKit.h"

#import "LoadingView.h"


NSString *const didSignUpNotification = @"DidSignIn";

@implementation SignUpViewController

static NSString *nameKey = @"Name";
static NSString *userNameKey = @"UserName";
static NSString *emailKey = @"Email";
static NSString *passwordKey = @"Password";
static NSString *passwordConfirmationKey = @"PasswordConfirmation";

static NSString *serverUserNameKey = @"username";
static NSString *serverPostingAddressKey = @"posting_address";

static NSString *loadingViewText = @"Hard Core Signing Up Action...";

static NSString *stagingUrl = @"http://staging.shareurmeal.com/api/users";




- (void)dealloc {
    
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[[IFTemporaryModel alloc] init] autorelease];
    
    //[self addSignUpButton];
    [self addCancelButton];
    
}

- (void)addSignUpButton{
    
    UIBarButtonItem *loginButton = [[[UIBarButtonItem alloc] initWithTitle:@"Sign Up" 
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:self 
                                                                    action:@selector(signUp)] autorelease];
    
    self.navigationItem.rightBarButtonItem = loginButton;
    
}

- (void)addCancelButton{
    
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                                                style:UIBarButtonItemStyleBordered 
                                                               target:self 
                                                               action:@selector(cancel)] autorelease];
    
    self.navigationItem.leftBarButtonItem = cancel;
    
    
}

- (void)cancel{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)constructTableGroups
{
    /*
     This is the heart of the view controller. If you're familiar with domain specific languages (such
     as those used in Ruby), I've tried to do something similar with Objective-C and Cocoa.
     
     Every generic table view controller has three UI components:
     
     1. The groups (each of which is defined by a collection of cells)
     2. The headers (one for each group)
     3. The footers (one for each group)
     
     This view controller also includes a model which is provided to each cell (so view changes can
     update the model.)
     */
    
    /*
     These are the types of cells that are supported by the view controller. Each will be demonstrated
     below. More complex uses of each type is shown in SampleAdvancedViewController.
     */
	IFButtonCellController *buttonCell = nil;
	IFTextCellController *textCell = nil;
    
    /*
     Start by defining a collection where each cell in the group will be stored:
     */
	NSMutableArray *nameCells = [NSMutableArray array];
    
    /*
     Similarly, a cell can be created for text data. In this case, we'll be storing NSStrings in
     the model with the key "sampleText":
     */
	textCell = [[[IFTextCellController alloc] initWithLabel:@"Name:" andPlaceholder:@"Your Name" atKey:nameKey inModel:model] autorelease];
    textCell.autocorrectionType = UITextAutocapitalizationTypeWords;
	[nameCells addObject:textCell];
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"Email:" andPlaceholder:@"you@you.com" atKey:emailKey inModel:model] autorelease];
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    [nameCells addObject:textCell];
    
    
    NSMutableArray *personalCells = [NSMutableArray array];
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"User name:" andPlaceholder:@"MyFunkyName" atKey:userNameKey inModel:model] autorelease];
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
	[personalCells addObject:textCell];
    
    
    NSMutableArray *passwordCells = [NSMutableArray array];
    
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"Once:" andPlaceholder:@"" atKey:passwordKey inModel:model] autorelease];
	textCell.secureTextEntry = YES;
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    [passwordCells addObject:textCell];
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"Twice:" andPlaceholder:@"" atKey:passwordConfirmationKey inModel:model] autorelease];
	textCell.secureTextEntry = YES;
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    [passwordCells addObject:textCell];
    
    
    NSMutableArray *buttonCells = [NSMutableArray array];
    
	buttonCell = [[[IFButtonCellController alloc] initWithLabel:@"Sign Up!" withAction:@selector(signUp) onTarget:self] autorelease];
	[buttonCells addObject:buttonCell];
    
    /*
     Once all the groups have been defined, a collection is created that allows the generic table view
     controller to construct the views, manage user input, and update the model(s):
     */
	tableGroups = [[NSArray arrayWithObjects:nameCells, personalCells, passwordCells, buttonCells, nil] retain];
    /*
     In this example, the first group of cells gets a header ("Sample Cells") while the last two do not
     because an empty string is defined in the collection.
     */
    
	tableHeaders = [[NSArray arrayWithObjects:@"Who Are You?", [NSNull null], @"Password", [NSNull null], nil] retain];	
    /*
     RANT: I'm getting really sick and tired of putting newlines in table footers so that the margins
     look nice. If anyone at Apple is reading this, please fix rdar://problem/5863115 Thank you!
     */
}


- (void)signUp{
    
    
    loadingView = [LoadingView loadingViewInView:self.view withText:@"Hard Core Signing Up Action..."];
    
    NSURL *url = [NSURL URLWithString:stagingUrl];
    
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
    
    [request setPostValue:[model objectForKey:nameKey] forKey:@"user[name]"];
    [request setPostValue:[model objectForKey:emailKey] forKey:@"user[email]"];
    [request setPostValue:[model objectForKey:userNameKey] forKey:@"user[username]"];
    [request setPostValue:[model objectForKey:passwordKey] forKey:@"user[password]"];
    [request setPostValue:[model objectForKey:passwordConfirmationKey] forKey:@"user[password_confirmation]"];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    
    networkQueue = [[ASINetworkQueue alloc] init];

    [networkQueue addOperation:request]; //queue is an NSOperationQueue
    
    [networkQueue go];

}

- (void)requestDone:(ASIHTTPRequest *)request
{
    
    [loadingView removeView];
    
    NSString *response = [request responseString];
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithJSON:response];
    
    id errors = nil;
    
    errors = [responseDictionary objectForKey:@"errors"];
    
    if(errors!=nil){
        
        if([errors respondsToSelector:@selector(objectAtIndex:)] && ([errors count] >0)){
            
            NSString* firstErrorCode = [errors objectAtIndex:0];
            
            if([firstErrorCode class] == [NSString class])
                NSLog(firstErrorCode);
            
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Could Not Create Account" 
                                                             message:firstErrorCode 
                                                            delegate:nil 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil] autorelease];
            
            [alert show];
            
                        
        }
        
               
    }else {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

        NSString *address = [responseDictionary objectForKey:serverPostingAddressKey];
        NSString *username = [responseDictionary objectForKey:serverUserNameKey];        
        
        if(address!=nil)
            [defaults setObject:address forKey:@"PostingAddress"];
        
        if(username!=nil)
            [defaults setObject:username forKey:@"Username"];
        
        
        [defaults synchronize];
        
            
        [[NSNotificationCenter defaultCenter] postNotificationName:didSignUpNotification object:self];
    }

    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    //TODO: handle error

}


@end

