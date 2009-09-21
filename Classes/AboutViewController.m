#import "AboutViewController.h"


@implementation AboutViewController

@synthesize webView = _webView;


- (id)init
{
	self = [super initWithNibName:@"AboutViewController" bundle:nil];
	if (self != nil) {
		// initializations
	}
	return self;
}


- (void) viewDidLoad
{
	[super viewDidLoad];

	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kShareUrMealRootURL @"/about"]];
	[self.webView loadRequest:request];
	[self.webView setScalesPageToFit:YES];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}


- (void) webViewDidFinishLoad:(UIWebView*)webView
{
	debugTrace();
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// -- load fallback content
	
	NSString* localAboutPath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
	NSURL* localAboutURL = [NSURL fileURLWithPath:localAboutPath];
	
	NSURLRequest* request = [NSURLRequest requestWithURL:localAboutURL];
	[webView loadRequest:request];
}


- (IBAction) done:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
