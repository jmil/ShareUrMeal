//
//  LoginViewController.m
//  ShareUrMeal
//
//  Created by Corey Floyd on 9/2/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "LoginViewController.h"

#import "IFTemporaryModel.h"

#import "IFTextCellController.h"

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

#import "JSONKit.h"

#import "SignUpViewController.h"

#import "LoadingView.h"

#import "SDNextRunloopProxy.h"


NSString *const didLoginNotification = @"DidLogIn";

static NSString *userNameKey = @"UserName";
static NSString *passwordKey = @"Password";

static NSString *serverUserNameKey = @"username";
static NSString *serverPostingAddressKey = @"posting_address";

static NSString *loadingViewText = @"Hard Core Logging In Action...";

static NSString *userNameTextFieldLabel = @"Username:";
static NSString *passwordTextFieldLabel = @"Password:";


@interface LoginViewController ()
- (void)addCancelButton;
@end
	


@implementation LoginViewController


- (id) init
{
	self = [super initWithNibName:@"SignUpViewController" bundle:nil];
	if (self != nil)
	{
		networkQueue = [[ASINetworkQueue alloc] init];
	}
	return self;
}


- (void)dealloc {
	[networkQueue release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[[IFTemporaryModel alloc] init] autorelease];
    
    //[self addLoginButton];
    [self addCancelButton];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
}



- (void)addLoginButton{
    
    UIBarButtonItem *loginButton = [[[UIBarButtonItem alloc] initWithTitle:@"Login" 
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:self 
                                                                    action:@selector(login)] autorelease];
    
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
    
    NSMutableArray *personalCells = [NSMutableArray array];

    
    textCell = [[[IFTextCellController alloc] initWithLabel:userNameTextFieldLabel andPlaceholder:@"" atKey:userNameKey inModel:model] autorelease];
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    textCell.returnKey = UIReturnKeyNext;
    textCell.updateAction = @selector(textFieldUpdated:);
    textCell.updateTarget = self;
	[personalCells addObject:textCell];
    
    textCell = [[[IFTextCellController alloc] initWithLabel:passwordTextFieldLabel andPlaceholder:@"" atKey:passwordKey inModel:model] autorelease];
	textCell.secureTextEntry = YES;
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    textCell.returnKey = UIReturnKeyDone;
    [personalCells addObject:textCell];
    
    /*
     Once all the groups have been defined, a collection is created that allows the generic table view
     controller to construct the views, manage user input, and update the model(s):
     */
	tableGroups = [[NSArray arrayWithObjects: personalCells, nil] retain];
    /*
     In this example, the first group of cells gets a header ("Sample Cells") while the last two do not
     because an empty string is defined in the collection.
     */
	tableHeaders = [[NSArray arrayWithObjects: @"Enter your username/password", nil] retain];	
   
    /*
     RANT: I'm getting really sick and tired of putting newlines in table footers so that the margins
     look nice. If anyone at Apple is reading this, please fix rdar://problem/5863115 Thank you!
     */
}


- (void)textFieldUpdated:(UITextField*)aTextField{
    
    if(tableGroups==nil)
        return;
    
    if(aTextField.returnKeyType = UIReturnKeyNext)
        [self nextTextFieldBecomeFirstResponder:aTextField];
        
}

- (void)nextTextFieldBecomeFirstResponder:(UITextField*)aTextField{
    
    
    NSIndexPath* currentIndexPath = [self indexPathForTextField:aTextField];
    NSIndexPath* newIndexPath = nil;
    
    if([tableGroups count] > currentIndexPath.section){
        
        NSArray *section = [tableGroups objectAtIndex:currentIndexPath.section];
        
        if([section count] > (currentIndexPath.row+1))
            newIndexPath = [NSIndexPath indexPathForRow:(currentIndexPath.row+1) inSection:currentIndexPath.section];
        
        else if ([tableGroups count] > (currentIndexPath.section+1))
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:(currentIndexPath.section+1)];
        
    }
    
    if(newIndexPath!=nil){
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
        [[[self textFieldForCell:cell] nextRunloopProxy] becomeFirstResponder]; 
    }
    
}


- (UITextField*)textFieldForCell:(UITableViewCell*)aCell{
    
    UITextField* textField = nil;
    
    for(UIView* eachSubview in aCell.contentView.subviews){
        
        if([eachSubview isKindOfClass:[UITextField class]]){
            textField = eachSubview;
            break;
        }
    }
    
    
    return textField;    
}

- (NSIndexPath*)indexPathForTextField:(UITextField*)textField{
    
    
    CGRect frame = textField.frame;
    frame = [self.tableView convertRect:frame fromView:(UIView*)textField];
    
    NSArray* indexPaths = nil;
    indexPaths = [self.tableView indexPathsForRowsInRect:frame];
    
    NSIndexPath* indexPath = nil;

    if((indexPaths!=nil) && ([indexPaths count]>0)){
        
        indexPath = [indexPaths objectAtIndex:0];
    }
    
}



- (void)signUp{
    
    SignUpViewController *viewController = [[[SignUpViewController alloc] init] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navController.navigationBar.tintColor = [UIColor blackColor];    
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:navController animated:YES];
    
}

- (void)login{
    
    loadingView = [LoadingView loadingViewInView:self.view withText:loadingViewText];

    
    NSString *username = [model objectForKey:userNameKey];
    NSString *password = [model objectForKey:passwordKey];
    
//    NSString *urlString = [NSString stringWithFormat:kShareUrMealLoginURL, username, password];
  
	NSString *urlString = @"http://shareurmeal.com/api/users/current.json";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.username = username;
	request.password = password;
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];

    [networkQueue addOperation:request]; //queue is an NSOperationQueue
    [networkQueue go];
}


- (void)requestDone:(ASIHTTPRequest *)request
{
    [loadingView removeView];
    
    NSString *response = [request responseString];
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithJSON:response];
    
    id error = nil;
    
    error = [responseDictionary objectForKey:@"error"];
        
    if(error!=nil){
        
		errLog( @"%@", error);
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Could Not Log In" 
                                                         message:error 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil] autorelease];
        
        [alert show];
        
    }else {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *address = [responseDictionary objectForKey:serverPostingAddressKey];
        NSString *username = [responseDictionary objectForKey:serverUserNameKey]; 
        
        if(address!=nil)
            [defaults setObject:address forKey:kUserDefaultsPostEmailAddressKey];
        
        if(username!=nil)
            [defaults setObject:username forKey:kUserDefaultsUsernameKey];
        
        
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:didLoginNotification object:self];    
    }

    
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
	errLog( @"%@", error );
    //TODO: handle error
}




@end

