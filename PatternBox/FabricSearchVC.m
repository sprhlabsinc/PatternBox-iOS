//
//  FabricSearchVC.m
//  PatternBox
//
//  Created by mac on 4/14/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricSearchVC.h"
#import "PatternCell.h"
#import "Define.h"
#import "FabricDetailVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FabricSearchVC ()

@end

@implementation FabricSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"SEARCH FABRIC" navi:self.navigationItem];
    _fabrics = [[NSMutableArray alloc] initWithArray:[AppManager sharedInstance].fabricList];
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

    if ([segue.identifier isEqualToString:@"segueDetail"]) {
        FabricDetailVC *target = (FabricDetailVC *)segue.destinationViewController;
        FabricModel* model = _fabrics[_curIndexPath.row];
        target.m_fabricModel = model;
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _curIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"segueDetail" sender:self];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _fabrics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatternCell *cell = (PatternCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FabricModel* model = _fabrics[indexPath.row];
    cell.m_patternName.text = [NSString stringWithFormat:@"NAME: %@", model.info.name];
    cell.m_patternID.text = [NSString stringWithFormat:@"ID: %@", model.info.type];
    
    
    NSString *imgUrl = model.imageUrl;
    UIImage *placeholderImage = [UIImage imageNamed:@"fabric"];;
    
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
    
    NSArray* tempFabrics = [AppManager sharedInstance].fabricList;
    [_fabrics removeAllObjects];
    
    NSString *searchText = self.m_searchBar.text;
    
    if (searchText.length > 0) {
        for (FabricModel* model in tempFabrics) {
            
            NSRange titleResultsRange = [model.info.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0 && titleResultsRange.location == 0){
                [_fabrics addObject:model];
            } else {
                NSRange idResultsRange = [model.info.type rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (idResultsRange.length > 0 && idResultsRange.location == 0){
                    [_fabrics addObject:model];
                }else{
                    
                    for (NSString* category in model.getCategoryNameList) {
                        NSRange categorysRange = [category rangeOfString:searchText options:NSCaseInsensitiveSearch];
                        if (categorysRange.length > 0 && categorysRange.location == 0){
                            [_fabrics addObject:model];
                            break;
                        }
                    }
                }
            }
        }
    } else {
        for (FabricModel* model in tempFabrics){
            [_fabrics addObject:model];
        }
        
    }
    
    [self.m_tableView reloadData];
}

#pragma mark - Common

- (void)bookMarkPattern:(NSIndexPath *)indexPath {
    
}

- (void)deleteFabric:(NSIndexPath*)indexPath {
    FabricModel* model = _fabrics[indexPath.row];
    NSString* tag = [NSString stringWithFormat:@"fabrics/%ld",(long)model.fid];
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
                [[AppManager sharedInstance].fabricList removeObject:model];
                [_fabrics removeObject:model];
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                [self.m_tableView reloadData];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showConfirmDialog:(NSIndexPath*)indexPath{
    NSString* title = @"Confirm";
    NSString* message = @"Are you sure to delete this fabric?";
    
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteFabric:indexPath];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
