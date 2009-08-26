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

//URL to test post
//http://hurl.r09.railsrumble.com/hurls/dbe482a36bca7d2df57221d02f144c651ecf6de3/ce959e5dd7830e84b3e4fdc1165e1b8e977a97d0



@implementation SignUpViewController

static NSString *nameKey = @"Name";
static NSString *userNameKey = @"UserName";
static NSString *emailKey = @"Email";
static NSString *passwordKey = @"Password";
static NSString *passwordConfirmationKey = @"PasswordConfirmation";


static NSString *stagingUrl = @"http://staging.shareurmeal.com/api/users";


- (void)dealloc {
    
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[[IFTemporaryModel alloc] init] autorelease];
    
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
    
    
    NSMutableArray *personalCells = [NSMutableArray array];
    
    
    textCell = [[[IFTextCellController alloc] initWithLabel:@"Email:" andPlaceholder:@"you@you.com" atKey:emailKey inModel:model] autorelease];
    textCell.autocorrectionType = UITextAutocapitalizationTypeNone;
    [personalCells addObject:textCell];
    
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
	tableHeaders = [[NSArray arrayWithObjects:@"Who Are You?", @"Some Personal Stuff", @"Password", [NSNull null], nil] retain];	
    /*
     Similarly, the first and second groups get a footer with additional information for the user. The
     last group does not: this time because a NSNull value is used:
     */
	tableFooters = [[NSArray arrayWithObjects:[NSNull null], [NSNull null], [NSNull null], [NSNull null], nil] retain];	
    /*
     RANT: I'm getting really sick and tired of putting newlines in table footers so that the margins
     look nice. If anyone at Apple is reading this, please fix rdar://problem/5863115 Thank you!
     */
}


- (void)signUp{
    
    
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
    NSString *response = [request responseString];
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithJSON:response];
    
    id errors = [responseDictionary objectForKey:@"errors"];
    
    if(errors!=nil){
        
        //TODO: handle errors

    }
    
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}


@end
