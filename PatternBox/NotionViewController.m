//
//  NotionViewController.m
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "NotionViewController.h"
#import "NotionDetailCell.h"
#import "NotionDetailCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import "Define.h"
#import "NotionCategoryInfo.h"
#import "ProjectViewController.h"
#import <SCLAlertView_Objective_C/SCLAlertView.h>


@interface NotionViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{

    NSMutableArray *_notions;
    NSMutableArray *_allNotions;
    NotionModel* _selectedNotion;
    
    
}

@end

@implementation NotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"NOTIONS" navi:self.navigationItem];
    self.btnAddToProject.layer.cornerRadius = 20;
    self.btnAddToProject.layer.masksToBounds = YES;
    
    if (self.m_projectEditVC) {
        [self.btnAddToProject setTitle:@"ADD" forState:UIControlStateNormal];
    }else{
        [self.btnAddToProject setTitle:@"Add To Project" forState:UIControlStateNormal];
    }
    
    [self initParams];
    [self updateAllTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNotionEdit"]) {
        //NotionEditController *target = (NotionEditController *)segue.destinationViewController;
        //target.m_notionModel = _notions[_curIndexPath.row];
    }
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedNotion = _notions[indexPath.row];
    [self setNotionHowMany];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _notions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotionDetailCell *cell = (NotionDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NotionModel* model = _notions[indexPath.row];
    cell.lblType.text = model.type;
    cell.lblColor.text = model.color;
    cell.lblSize.text = model.size;
    cell.lblhowmany.text = [NSString stringWithFormat:@"%ld", model.howmany];
    
    if (model.howmany > 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
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
        //add code here for when you hit delete
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"EDIT" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NotionModel* info = _notions[indexPath.row];
                                         _selectedNotion = info;
                                         [self openEditDialog:YES];
                                     }];
    btnEdit.backgroundColor = [UIColor blueColor]; //arbitrary color
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"DELETE" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                       {
                                           NotionModel* info = _notions[indexPath.row];
                                           _selectedNotion = info;
                                           [self showDeleteConfirmDialog];
                                       }];
    btnDelete.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[btnEdit, btnDelete]; //array with all the buttons you want. 1,2,3, etc...
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

#pragma mark NotionCellDelegate
-(void)notionCell:(NSString *)value index:(NSInteger)index{
//    NotionCategoryInfo* info = _categories[index - 4];
//    info.content = value;
}

#pragma mark Notion CREATE, UPDATE and DELETE
-(void)createNotion:(NotionModel*)model{
    
    NSDictionary* parameter = [model getDictionaryData];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] postRequest:@"notion" parameter:parameter withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                
            }else{
                NSInteger notion_id = [[response objectForKey:@"notion_id"] integerValue];
                model.fid = notion_id;
                [[AppManager sharedInstance].notionList addObject:[model createClone]];
                [_allNotions addObject:model];
                
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                
                [self updateAllTable];
            }
        }else{
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

-(void)updateNotion:(NotionModel*)model{
    
    NSDictionary* parameter = [model getDictionaryData];
    NSString* tag = [NSString stringWithFormat:@"notion/%ld",_selectedNotion.fid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] putRequest:tag parameter:parameter withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                
            }else{
                _selectedNotion.type = model.type;
                _selectedNotion.size = model.size;
                _selectedNotion.color = model.color;
                
                NSMutableArray* temp = [AppManager sharedInstance].notionList;
                for (NotionModel* item in temp) {
                    if (item.fid == _selectedNotion.fid) {
                        item.type = model.type;
                        item.size = model.size;
                        item.color = model.color;
                        break;
                    }
                }
                
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                [self updateAllTable];
            }
        }else{
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}
-(void)deleteNotion{
    NSString* tag = [NSString stringWithFormat:@"notion/%ld",_selectedNotion.fid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] deleteRequest:tag parameter:nil withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
               
            }else{

                NSMutableArray* temp = [AppManager sharedInstance].notionList;
                for (NotionModel* model in temp) {
                    if (model.fid == _selectedNotion.fid) {
                        [temp removeObject:model];
                        break;
                    }
                }
                
                [_allNotions removeObject:_selectedNotion];
                
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
                [self updateAllTable];
            }
        }else{
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}
#pragma mark - Action
- (IBAction)actionCreateNotion:(id)sender {
    [self openEditDialog:false];
}

- (IBAction)actionAddToProject:(id)sender {

    if (self.m_projectEditVC ) {

        [self.m_projectEditVC updateNotionsWith:[self getSelectedNotions]];

        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProjectViewController *projectVC = (ProjectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProjectViewController"];
        projectVC.m_notions= [[self getSelectedNotions] mutableCopy];
        [self.navigationController pushViewController:projectVC animated:YES];
    }
}
- (void)setNotionHowMany{
   

    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:@"How Many?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"HOW MANY";
        textField.text = _selectedNotion.howmany > 0 ? [NSString stringWithFormat:@"%ld",(long)_selectedNotion.howmany]:@"";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];

    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _selectedNotion.howmany = [alert.textFields[0].text integerValue];
        [self updateUI];
        [self.m_tableView reloadData];

    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Common

-(void)openEditDialog:(Boolean)isUpdate{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = KColorBasic;
    
    UITextField *txtType = [alert addTextField:@"Enter the notion type"];
    UITextField *txtColor = [alert addTextField:@"Enter the notion color"];
    UITextField *txtSize = [alert addTextField:@"Enter the notion size"];
    
    if (isUpdate) {
        txtType.text = _selectedNotion.type;
        txtColor.text = _selectedNotion.color;
        txtSize.text = _selectedNotion.size;
    }
    NSString* buttonTitle = isUpdate?@"Edit":@"Add";
    NSString* dlgTitle = isUpdate?@"Edit Notion":@"New Notion";
    
    [alert addButton:buttonTitle actionBlock:^(void) {
        NotionModel* newModel = [[NotionModel alloc] init];;
        newModel.categoryId = self.m_category.fid;
        newModel.type = txtType.text;
        newModel.color = txtColor.text;
        newModel.size = txtSize.text;
        if (isUpdate) {
            [self updateNotion:newModel];
        }else{
           [self createNotion:newModel];
        }
        
    }];
    
    [alert showEdit:self title:dlgTitle subTitle:@"" closeButtonTitle:@"Done" duration:0.0f];
}


- (void)showDeleteConfirmDialog{
    NSString* title = @"Confirm";
    NSString* message = @"Are you sure to delete this notion?";
    
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteNotion];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Common

- (void) updateAllTable{
    NSArray* temp = _allNotions;
    [_notions removeAllObjects];
    
    NSString *searchText = self.m_searchBar.text;
    
    if (searchText.length > 0) {
        for (NotionModel* model in temp) {
            if (![self.m_category.fid isEqualToString:model.categoryId]) {
                continue;
            }
            
            NSRange titleResultsRange = [model.type rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0 && titleResultsRange.location == 0){
                [_notions addObject:model];
            } else {
                NSRange idResultsRange = [model.color rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (idResultsRange.length > 0 && idResultsRange.location == 0){
                    [_notions addObject:model];
                }
            }
        }
    } else {
        
        for (NotionModel* model in temp){
            if (![self.m_category.fid isEqualToString:model.categoryId]) {
                continue;
            }
            [_notions addObject:model];
        }
        
    }
   

    [self.m_tableView reloadData];
    [self updateUI];
}
-(void)initParams{
    _notions = [[NSMutableArray alloc] init];
    _allNotions = [[NSMutableArray alloc] init];

    
    NSArray* temp = [AppManager sharedInstance].notionList;
    for (NotionModel* model in temp) {
        model.howmany = 0;
        for (NotionModel* item in self.m_notions) {
            if (model.fid == item.fid) {
                model.howmany = item.howmany;
                break;
            }
        }
        NotionModel* newItem = [model createClone];
        newItem.howmany = model.howmany;
        [_allNotions addObject:newItem];
    }
}
-(void)updateUI{
    Boolean isShow = false;
    for (NotionModel* model in _notions) {
        if (model.howmany > 0) {
            isShow = true;
            break;
        }
    }
    [self.btnAddToProject setHidden:!isShow];

}
-(NSArray*)getSelectedNotions{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NotionModel* model in _notions) {
        if (model.howmany > 0) {
            [result addObject:model];
        }
    }
    return result;
}
@end
