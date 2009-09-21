#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate>
{
	UIWebView* _webView;
	BOOL _didFallBack;
}

@property (nonatomic, assign) IBOutlet UIWebView* webView;

- (IBAction) done:(id)sender;

@end
