//
//  ViewController.m
//  GitHub_TestApp
//
//  Created by iStef on 22.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "AccessToken.h"
#import "ServerManager.h"
#import "ReposTableViewController.h"
#import "User.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView* webView;
@property (strong, nonatomic) UIActivityIndicatorView *authIndicator;

@end


@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Authorization";
    
    CGRect webViewFrame = self.view.bounds;
    webViewFrame.origin = CGPointZero;
     
    UIWebView* webView = [[UIWebView alloc] initWithFrame:webViewFrame];
     
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     
    [self.view addSubview:webView];
    
    self.authIndicator = [[UIActivityIndicatorView alloc]init];
    self.authIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.authIndicator.color = [UIColor grayColor];
    self.authIndicator.center = webView.center;
    [webView addSubview:self.authIndicator];
    [self.authIndicator startAnimating];
     
    self.webView = webView;
    
    NSString* urlString = @"https://github.com/login/oauth/authorize?"
    "client_id=059d85c41579fffa15d6&"
    "scope=user%20repo&"
    "state=ok&"
    "allow_signup=false";

    NSURL* url = [NSURL URLWithString:urlString];
     
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
     
    webView.delegate = self;
     
    [webView loadRequest:request];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    self.webView.delegate = nil;
}

#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self.authIndicator startAnimating];
    
    if ([[[request URL] description] rangeOfString:@"code"].location != NSNotFound) {
 
        NSString *responseCode;
        NSString *responseState;
        User *user = [[User alloc]init];
 
        NSString* query = [[request URL] description];
 
        NSArray* array = [query componentsSeparatedByString:@"&"];
 
        if ([array count] > 1) {
            
            for (NSString *pair in array) {
                if ([pair containsString:@"code"]) {
                    NSArray *codePair = [pair componentsSeparatedByString:@"="];
                    responseCode = [codePair lastObject];
                }else if ([pair containsString:@"?"]){
                    NSRange lastSlashRange = [pair rangeOfString:@".com/"];
                    NSRange questionRange = [pair rangeOfString:@"?"];
                    user.name = [pair substringWithRange:NSMakeRange(lastSlashRange.location + 5,  questionRange.location - (lastSlashRange.location + 5))];
                }else if ([pair containsString:@"state"]){
                    NSArray *statePair = [pair componentsSeparatedByString:@"="];
                    responseState = [statePair lastObject];
                }
            }
        }
    
        self.webView.delegate = nil;
        
        [[ServerManager sharedManager]
         authorizeUserWithCode:responseCode
         andState:responseState
         onSuccess:^(AccessToken *accessToken) {
             
             ReposTableViewController *reposTVC = [[ReposTableViewController alloc]init];
             reposTVC.authorizedUser = user;
             [self.navigationController pushViewController:reposTVC animated:YES];
        }
         onFailure:^(NSError *error) {
         
        }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.authIndicator stopAnimating];
    [self.authIndicator setHidesWhenStopped:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.authIndicator stopAnimating];
    [self.authIndicator setHidesWhenStopped:YES];
}

@end

