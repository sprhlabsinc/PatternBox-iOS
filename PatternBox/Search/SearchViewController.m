//
//  SearchViewController.m
//  PatternBox
//
//  Created by youandme on 05/08/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SearchViewController.h"
#import "PatternCell.h"
#import "Define.h"
#import "PatternDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [APPDELEGATE setTitleViewOfNavigationBar:self.navigationItem];
    _patterns = [[NSMutableArray alloc] initWithArray:[AppManager sharedInstance].patternList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"seguePatternDetailFromSearch"]) {
        PatternDetailViewController *target = (PatternDetailViewController *)segue.destinationViewController;
        PatternModel* model = _patterns[_curIndexPath.row];
        if (model.isPDF) {
            target.m_ViewMode = VM_PDFs;
        } else {
            target.m_ViewMode = VM_Scans;
        }
        target.m_pattern = model;
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _curIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"seguePatternDetailFromSearch" sender:self];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _patterns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatternCell *cell = (PatternCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    PatternModel* model = _patterns[indexPath.row];
    cell.m_patternName.text = [NSString stringWithFormat:@"NAME: %@", model.name];
    cell.m_patternID.text = [NSString stringWithFormat:@"ID: %@", model.type];
   

    NSString *imgUrl;
    UIImage *placeholderImage;
    NSInteger isPDF = model.isPDF;
    imgUrl = model.frontImage;
    if(isPDF == 0) {
        placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];

    } else {
        placeholderImage = [UIImage imageNamed:@"icon_PDFdoc.png"];
    }
    
    [cell.m_imgView sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:imgUrl] placeholderImage:placeholderImage];
    
    if (model.isBookMark) {
        cell.m_imgBookMark.hidden = NO;
    } else {
        cell.m_imgBookMark.hidden = YES;
    }

    NSString *categories = [[model getCategoryNameList] componentsJoinedByString:@","];
    cell.m_categoryName.text = [NSString stringWithFormat:@"CATEGORY: %@", categories];

    __weak typeof(cell.m_btnBookMark ) weakBtnRef = cell.m_btnBookMark;
    cell.m_actionBookMark = ^(id sender) {
        [self bookMarkPattern:indexPath];
        weakBtnRef.enabled = NO;
    };
    
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
#pragma mark- SearchBar Delegate
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    [self updateAllTable];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self updateAllTable];
    [self.m_searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}


- (void) updateAllTable {
    
    NSArray* tempFabrics = [AppManager sharedInstance].patternList;
    [_patterns removeAllObjects];
    
    NSString *searchText = self.m_searchBar.text;
    
    if (searchText.length > 0) {
        for (PatternModel* model in tempFabrics) {
            
            NSRange titleResultsRange = [model.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0 && titleResultsRange.location == 0){
                [_patterns addObject:model];
            } else {
                NSRange idResultsRange = [model.type rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (idResultsRange.length > 0 && idResultsRange.location == 0){
                    [_patterns addObject:model];
                }else{
                    
                    for (NSString* category in model.getCategoryNameList) {
                        NSRange categorysRange = [category rangeOfString:searchText options:NSCaseInsensitiveSearch];
                        if (categorysRange.length > 0 && categorysRange.location == 0){
                            [_patterns addObject:model];
                            break;
                        }
                    }
                }
            }
        }
    } else {
        for (PatternModel* model in tempFabrics){
            [_patterns addObject:model];
        }
        
    }
    
    [self.m_tableView reloadData];
}

#pragma mark - Common

- (void)deletePattern:(NSIndexPath*)indexPath {
    
    PatternModel* model = _patterns[indexPath.row];
    
    NSString* tag = [NSString stringWithFormat:@"patterns/%ld",(long)model.fid];
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
                
                [[AppManager sharedInstance].patternList removeObject:model];
                
                [_patterns removeObject:model];
                [self.m_tableView reloadData];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}
- (void)bookMarkPattern:(NSIndexPath *)indexPath {

}


- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message {
   
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showConfirmDialog:(NSIndexPath*)indexPath{
    NSString* title = @"Confirm";
    NSString* message = @"Are you sure to delete this pattern?";
    
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletePattern:indexPath];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
