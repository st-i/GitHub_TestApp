//
//  CommitsTableViewController.h
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"

@interface CommitsTableViewController : UITableViewController

@property (strong, nonatomic) Repository *currentRepository;

@end
