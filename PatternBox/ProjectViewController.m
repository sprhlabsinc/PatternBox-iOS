//
//  ProjectViewController.m
//  PatternBox
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "ProjectViewController.h"
#import "AppManager.h"
#import "ProjectModel.h"
#import "ProjectCell.h"
#import "ProjectEditController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Shadow.h"

@interface ProjectViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    NSMutableArray* _projects;
    NSMutableArray* _allProjects;
    NSIndexPath* _curIndexPath;
    Boolean isPassVaraiable;
}

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPassVaraiable = true;
    _projects = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (isPassVaraiable) {
        isPassVaraiable = false;
    }else{
        self.m_pattern = nil;
        self.m_fabrics = nil;
        self.m_notions = nil;
    }
    [self takePatternsFrom];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueShowProject"]) {
        ProjectEditController *target = (ProjectEditController *)segue.destinationViewController;
        target.m_project = _projects[_curIndexPath.row];
        if (self.m_pattern) {
            target.m_pattern = self.m_pattern;
        }
        if (self.m_fabrics) {
            target.m_fabrics = self.m_fabrics;
        }
        if (self.m_notions) {
            target.m_notions = self.m_notions;
        }
    }
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _curIndexPath = indexPath;
    [self performSegueWithIdentifier:@"segueShowProject" sender:self];
}
#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell *cell = (ProjectCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ProjectModel* model = _projects[indexPath.row];
    
    UIImage *placeProject = [UIImage imageNamed:@"thumb_project"];
    [cell.imvProject sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:model.image] placeholderImage:placeProject];
    
   
    cell.lblName.text = model.name;
    cell.lblFor.text = model.client;
    cell.txtNote.text = [NSString stringWithFormat:@"                %@",model.notes];
    
    PatternModel* pattern = [model getPatternModel];
    
    UIImage *placePattern = [UIImage imageNamed:@"thumb_pattern"];
    [cell.imvPattern sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:pattern.frontImage] placeholderImage:placePattern];

    CGRect rect = cell.viewFabrics.frame;
    int index = 0;
    CGFloat padding = 10;
    CGFloat width = rect.size.height;
    NSArray* fabricModels = [model getFabricModels];
    for (FabricModel* fmodel  in fabricModels) {
         CGFloat x = padding+(padding+width)*index;
         UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, width)];
         imgView.layer.masksToBounds = YES;
         imgView.layer.cornerRadius = width / 2;
         UIImage *placeholderImage = [UIImage imageNamed:@"fabric"];
         [cell.viewFabrics addSubview:imgView];
         [imgView sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:fmodel.imageUrl] placeholderImage:placeholderImage];
         index++;
         if (x>rect.size.width) {
             break;
         }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showConfirmDialog:indexPath];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark- SearchBar Delegate
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateAllTable];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self updateAllTable];
    [searchBar resignFirstResponder];
}
- (void)takePatternsFrom {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] getRequest:@"projects" parameter:nil withCallback:^(NSArray *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            _allProjects = [[NSMutableArray alloc] init];
            NSMutableArray* tempList = [[NSMutableArray alloc] init];
            for (NSDictionary* child in response) {
                ProjectModel* model = [[ProjectModel alloc] initWithData:child];
                [tempList addObject:model];
            }
            _allProjects = [tempList mutableCopy];
            
            [self updateAllTable];
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

- (void)deleteProject:(NSIndexPath*)indexPath {
    ProjectModel* model = _projects[indexPath.row];
    NSString* tag = [NSString stringWithFormat:@"projects/%ld",(long)model.fid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] deleteRequest:tag parameter:nil withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"fail" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                [_allProjects removeObject:model];
                [self updateAllTable];
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

- (void) updateAllTable{
    
    NSArray* tempPatterns = _allProjects;
    [_projects removeAllObjects];

    NSString *searchText = self.m_searchBar.text;
    
    if (searchText.length > 0) {
        for (ProjectModel* model in tempPatterns) {

            NSRange titleResultsRange = [model.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0 && titleResultsRange.location == 0){
                [_projects addObject:model];
            } else {
                NSRange idResultsRange = [model.client rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (idResultsRange.length > 0 && idResultsRange.location == 0){
                    [_projects addObject:model];
                }
            }
        }
    } else {
        for (ProjectModel* model in tempPatterns){
            [_projects addObject:model];
        }
        
    }
    [self.m_tableView reloadData];
}
- (void)showConfirmDialog:(NSIndexPath*)indexPath{
    NSString* title = @"Confirm";
    NSString* message = @"Are you sure to delete this project?";
    
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteProject:indexPath];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
