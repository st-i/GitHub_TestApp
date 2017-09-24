//
//  ReposTableViewController.m
//  GitHub_TestApp
//
//  Created by iStef on 23.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "ReposTableViewController.h"
#import "ServerManager.h"
#import "Repository.h"
#import "RepoEntryCell.h"
#import "UIKit+AFNetworking.h"
#import "CommitsTableViewController.h"

@interface ReposTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *userRepositories;
@property (strong, nonatomic) NSString *userRepositoriesAmount;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) BOOL requestError;
@property (assign, nonatomic) BOOL noRepositories;

@end

@implementation ReposTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noRepositories = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemSearch target:self action:@selector(showRepositoriesOfNewUser)];
    
    self.userRepositories = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.username = @"st-i";
    self.navigationItem.title = self.username;
    
    [self loadRepositories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showRepositoriesOfNewUser
{
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"Поиск" message:@"Введите имя пользователя на GitHub" preferredStyle:UIAlertControllerStyleAlert];
    [alertContr addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.placeholder = @"Например, st-i";
    }];
    [alertContr addAction:[UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = alertContr.textFields.firstObject.text;
        if (text.length > 0) {
            
            NSCharacterSet *invalidCharactersSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-"] invertedSet];
            NSRange wrongRange = [text rangeOfCharacterFromSet:invalidCharactersSet];
            if (wrongRange.length < 1) {
                self.username = text;
                [self.userRepositories removeAllObjects];
                self.navigationItem.title = self.username;
                [self loadRepositories];
            }else{
                
                double delayInSeconds = 0.2;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Некорректное имя пользователя" preferredStyle:UIAlertControllerStyleAlert];
                    [alertContr addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertContr animated:YES completion:nil];
                    
                     });
            }
        }
    }]];
    [self presentViewController:alertContr animated:YES completion:nil];
}

- (void)loadRepositories
{
    [[ServerManager sharedManager]
     getReposOfUser:self.username
     onSuccess:^(NSArray *repos) {
         [self.userRepositories addObjectsFromArray:repos];
         
         self.requestError = NO;
         if (repos.count == 0) {
             self.noRepositories = YES;
             [self.tableView reloadData];
         }else{
             self.noRepositories = NO;
             [self.tableView reloadData];
         }
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
         self.requestError = YES;
         [self.tableView reloadData];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.requestError || self.noRepositories) {
        return 1;
    }else{
        return self.userRepositories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.requestError) {
        static NSString *identifier = @"errorCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        UIView *lowerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, tableView.window.bounds.size.width, 0.5)];
        lowerSeparator.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lowerSeparator];
        
        NSString *errorCellText = @"Поиск не дал результатов";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:errorCellText];
        [attributedString addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:16 weight:UIFontWeightThin] range:[errorCellText rangeOfString:errorCellText]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.attributedText = attributedString;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        return cell;
        
    }else if (self.noRepositories){
        static NSString *identifier = @"noRepos";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        UIView *lowerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, tableView.window.bounds.size.width, 0.5)];
        lowerSeparator.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lowerSeparator];
        
        NSString *errorCellText = @"Нет репозиториев";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:errorCellText];
        [attributedString addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:16 weight:UIFontWeightThin] range:[errorCellText rangeOfString:errorCellText]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.attributedText = attributedString;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        return cell;
    }else{
    
        static NSString *identifier = @"repoCell";
        
        RepoEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepoEntryCell" owner:self options:nil];
            cell = [array firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        if (cell.firstAppearance) {
            UIView *upperSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.frame.size.width, 0.5)];
            upperSeparator.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:upperSeparator];
            
            cell.firstAppearance = NO;
        }
        
        Repository *repository = [self.userRepositories objectAtIndex:indexPath.row];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:repository.ownerPhotoURL];
        __weak RepoEntryCell* weakCell = cell;
        cell.ownerPhotoImageView.image = nil;
        [cell.ownerPhotoImageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             weakCell.ownerPhotoImageView.image = image;
             [weakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         }];
        
        cell.ownerNickname.text = repository.ownerName;
        
        cell.repositoryName.text = repository.name;
        
        cell.starsCount.text = repository.starsCount;
        cell.forksCount.text = repository.forkCount;
        
        cell.descriptionLabel.text = repository.repoDescription;
        
        cell.languageLabel.text = repository.language;
        cell.lastUpdateLabel.text = [NSString stringWithFormat:@"Updated on %@", repository.dateOfLastUpdate];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.userRepositories.count > 0) {
        
        CommitsTableViewController *commitsTVC = [[CommitsTableViewController alloc]init];
        Repository *selectedRepository = [self.userRepositories objectAtIndex:indexPath.row];
        commitsTVC.currentRepository = selectedRepository;
        [self.navigationController pushViewController:commitsTVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.requestError || self.noRepositories) {
        return 44.f;
    }else{

    if (self.userRepositories.count > 0) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RepoEntryCell" owner:self options:nil];
        RepoEntryCell *cell = [nib objectAtIndex:0];
        
        Repository *repo = [self.userRepositories objectAtIndex:indexPath.row];
        
        UIFont* font = [UIFont systemFontOfSize:14.f];
        
        NSShadow* shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowBlurRadius = 0.5;
        
        NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraph setAlignment:NSTextAlignmentLeft];
        
        NSDictionary* attributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
         font, NSFontAttributeName,
         paragraph, NSParagraphStyleAttributeName,
         shadow, NSShadowAttributeName, nil];
        
        CGRect rect = [repo.repoDescription boundingRectWithSize:CGSizeMake(CGRectGetWidth(cell.descriptionLabel.frame), CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attributes
                                              context:nil];
        
        if (CGRectGetHeight(rect) + 176.f > 344.f) {
            return 344.f;
        }else{
            return CGRectGetHeight(rect) + 176.f;
        }
    }else{
        return 344.f;
    }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.requestError || self.noRepositories) {
        return nil;
    }else{
    
    UIView *newHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    newHeaderView.backgroundColor = [UIColor colorWithRed:246.f/256.f green:246.f/256.f blue:246.f/256.f alpha:1];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [newHeaderView addSubview:titleLabel];
    
    NSString *headerTitle = @"Repositories";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:headerTitle];
    [attributedString addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightThin] range:[headerTitle rangeOfString:headerTitle]];
    
    titleLabel.attributedText = attributedString;
    
    return newHeaderView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.requestError || self.noRepositories) {
        return 0;
    }else{
        return 20;
    }
}

@end
