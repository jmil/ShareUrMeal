//
//  RootViewController.m
//  SUMSignUp
//
//  Created by Corey Floyd on 8/25/09.
//  Copyright Flying Jalapeno Software 2009. All rights reserved.
//

#import "SignUpViewController.h"

#import "IFTemporaryModel.h"

#import "IFTextCellController.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

#import "JSONKit.h"

#import "LoadingView.h"

#import "NSString+SUMExtensions.h"


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

static NSString *signupPath = @"/api/users";





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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    
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
    textCell.beginEditingAction = @selector(didSelectTextField:);
    textCell.beginEditingTarget = self;
	[nameCells addObject:textCell];
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"Email:" andPlaceholder:@"you@you.com" atKey:emailKey inModel:model] autorelease];
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    textCell.beginEditingAction = @selector(didSelectTextField:);
    textCell.beginEditingTarget = self;

    [nameCells addObject:textCell];
    
    
    NSMutableArray *personalCells = [NSMutableArray array];
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"User name:" andPlaceholder:@"MyName" atKey:userNameKey inModel:model] autorelease];
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    textCell.beginEditingAction = @selector(didSelectTextField:);
    textCell.beginEditingTarget = self;
	[personalCells addObject:textCell];
    
    
    NSMutableArray *passwordCells = [NSMutableArray array];
    
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"Once:" andPlaceholder:@"" atKey:passwordKey inModel:model] autorelease];
	textCell.secureTextEntry = YES;
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    textCell.beginEditingAction = @selector(didSelectTextField:);
    textCell.beginEditingTarget = self;
    [passwordCells addObject:textCell];
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"Twice:" andPlaceholder:@"" atKey:passwordConfirmationKey inModel:model] autorelease];
	textCell.secureTextEntry = YES;
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    textCell.beginEditingAction = @selector(didSelectTextField:);
    textCell.beginEditingTarget = self;
    [passwordCells addObject:textCell];
    
    
    
    /*
     Once all the groups have been defined, a collection is created that allows the generic table view
     controller to construct the views, manage user input, and update the model(s):
     */
	tableGroups = [[NSArray arrayWithObjects:nameCells, personalCells, passwordCells, nil] retain];
    /*
     In this example, the first group of cells gets a header ("Sample Cells") while the last two do not
     because an empty string is defined in the collection.
     */
    
	tableHeaders = [[NSArray arrayWithObjects:@"Who Are You?", [NSNull null], @"Password", nil] retain];	
    /*
     RANT: I'm getting really sick and tired of putting newlines in table footers so that the margins
     look nice. If anyone at Apple is reading this, please fix rdar://problem/5863115 Thank you!
     */
    
    self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)] autorelease];


}



- (void)didSelectTextField:(UITextField*)textField{
    
    CGRect frame = textField.frame;
    frame = [self.tableView convertRect:frame fromView:(UIView*)textField];
    
    for(UITableViewCell* eachCell in [self.tableView visibleCells]){
        
        CGRect cellFrame = eachCell.frame;
        
        if(CGRectContainsRect(cellFrame, frame) || CGRectIntersectsRect(cellFrame, frame)){
            [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:eachCell] 
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
            break;
            
        } 
    }    
}


- (void)signUp{
    
    
    loadingView = [LoadingView loadingViewInView:self.view withText:loadingViewText];
    
    NSString* urlString = [kShareUrMealRootURL stringByAppendingString:signupPath];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
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
    
    UIAlertView *alert = nil;
    
    if(![response containsString:@"(500)"]){
        
        NSDictionary *responseDictionary = [NSDictionary dictionaryWithJSON:response];
        
        id errors = nil;
        
        errors = [responseDictionary objectForKey:@"errors"];
        
        if(errors!=nil){
            
            if([errors respondsToSelector:@selector(objectAtIndex:)] && ([errors count] >0)){
                
                NSString* firstErrorCode = [errors objectAtIndex:0];

				errLog( @"%@", firstErrorCode );
                
                alert = [[[UIAlertView alloc] initWithTitle:@"Could Not Create Account" 
                                                    message:firstErrorCode 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil] autorelease];
                
                
                
            }
            
            
        }else {
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *address = [responseDictionary objectForKey:serverPostingAddressKey];
            NSString *username = [responseDictionary objectForKey:serverUserNameKey];        
            
            if(address!=nil)
                [defaults setObject:address forKey:kUserDefaultsPostEmailAddressKey];
            
            if(username!=nil)
                [defaults setObject:username forKey:kUserDefaultsUsernameKey];
            
            
            [defaults synchronize];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:didSignUpNotification object:self];
        }
        
        
    }else{
        
        
        alert = [[[UIAlertView alloc] initWithTitle:@"Could Not Create Account" 
                                            message:@"Please enter your information" 
                                           delegate:nil 
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles:nil] autorelease];
        
        
    }
      
    if(alert!=nil)
        [alert show];

    
   
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
	errLog( @"%@", error );
    //TODO: handle error
}


@end

