#import "AboutViewController.h"

//@interface AboutViewController ()
//@end


@implementation AboutViewController

@synthesize webView = _webView;

- (void) viewDidLoad
{
	[super viewDidLoad];

	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://staging.shareurmeal.com/about"]];
	[self.webView loadRequest:request];
	[self.webView setScalesPageToFit:YES];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}


- (void) webViewDidFinishLoad:(UIWebView*)webView
{
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


@end
