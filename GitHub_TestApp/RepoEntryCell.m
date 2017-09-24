//
//  RepoEntryCell.m
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "RepoEntryCell.h"

@implementation RepoEntryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ownerPhotoImageView.layer.cornerRadius = 4.0;
    [self.ownerPhotoImageView setClipsToBounds:YES];
    
    self.blueCircleView.layer.cornerRadius = 7.5;
    self.firstAppearance = YES;
    
    self.starsLabel.layer.borderWidth = 1.0;
    self.starsLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.starsLabel.layer.cornerRadius = 3.0;
    
    self.starsCount.layer.borderWidth = 1.0;
    self.starsCount.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.starsCount.layer.cornerRadius = 3.0;
    
    self.forksLabel.layer.borderWidth = 1.0;
    self.forksLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.forksLabel.layer.cornerRadius = 3.0;
    
    self.forksCount.layer.borderWidth = 1.0;
    self.forksCount.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.forksCount.layer.cornerRadius = 3.0;
    
    self.ownerPhotoImageView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *starsLabelColor = [self.starsLabel backgroundColor];
    UIColor *forksLabelColor = [self.forksLabel backgroundColor];
    UIColor *color = [self.blueCircleView backgroundColor];
    UIImage *image = self.ownerPhotoImageView.image;
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.starsLabel.backgroundColor = starsLabelColor;
        self.forksLabel.backgroundColor = forksLabelColor;
        self.blueCircleView.backgroundColor = color;
        self.ownerPhotoImageView.image = image;
    }

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *starsLabelColor = [self.starsLabel backgroundColor];
    UIColor *forksLabelColor = [self.forksLabel backgroundColor];
    UIColor *color = [self.blueCircleView backgroundColor];
    UIImage *image = self.ownerPhotoImageView.image;
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.starsLabel.backgroundColor = starsLabelColor;
        self.forksLabel.backgroundColor = forksLabelColor;
        self.blueCircleView.backgroundColor = color;
        self.ownerPhotoImageView.image = image;
    }
}


@end
