//
//  ViewController.m
//  GitHub_TestApp
//
//  Created by iStef on 22.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
//#import "AccessToken.h"
#import "ServerManager.h"
//#import "User.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView* webView;


@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
