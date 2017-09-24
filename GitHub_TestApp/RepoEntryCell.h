//
//  RepoEntryCell.h
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ownerPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerNickname;

@property (weak, nonatomic) IBOutlet UILabel *repositoryName;

@property (weak, nonatomic) IBOutlet UILabel *starsLabel;
@property (weak, nonatomic) IBOutlet UILabel *starsCount;
@property (weak, nonatomic) IBOutlet UILabel *forksLabel;
@property (weak, nonatomic) IBOutlet UILabel *forksCount;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *blueCircleView;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;

@property (assign, nonatomic) BOOL firstAppearance;

@property (strong, nonatomic) CALayer *separator;

@end
