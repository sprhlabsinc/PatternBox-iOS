//
//  NotionHomeVC.m
//  PatternBox
//
//  Created by mac on 4/20/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "NotionHomeVC.h"
#import "NotionCell.h"
#import "ZipperCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppManager.h"
#import "Define.h"
#import "NotionCategoryInfo.h"
#import "ProjectViewController.h"
#import "NotionViewController.h"

@interface NotionHomeVC ()<UITableViewDelegate, UITableViewDataSource, NotionCellDelegate>{
    
    NSMutableArray *_categories;
    NotionCategoryInfo* _selectedCategory;
    NotionModel* _model;
}

@end

@implementation NotionHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"NOTIONS" navi:self.navigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _categories = [AppManager sharedInstance].notionCategoryList;
    [self showComment];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNotions"]) {
        NotionViewController *target = (NotionViewController *)segue.destinationViewController;
        target.m_category = _selectedCategory;
    }
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedCategory = _categories[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NotionCell *cell = (NotionCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NotionCategoryInfo* info = _categories[indexPath.row];
    [cell.btnNotionCategory setTitle:info.name forState:UIControlStateNormal];
    cell.index = row;
    cell.delegate = self;
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
    if(indexPath.row < 4)
    {
        return  UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *btnEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"EDIT" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NotionCategoryInfo* info = _categories[indexPath.row];
                                         _selectedCategory = info;
                                         [self openEditDialog:YES];
                                     }];
    btnEdit.backgroundColor = [UIColor blueColor]; //arbitrary color
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"DELETE" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                       {
                                           NotionCategoryInfo* info = _categories[indexPath.row];
                                           _selectedCategory = info;
                                           [self showConfirmDialog:_selectedCategory];
                                       }];
    btnDelete.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[btnEdit, btnDelete]; //array with all the buttons you want. 1,2,3, etc...
}

#pragma mark ZipperCellDelegate

#pragma mark NotionCellDelegate
-(void)notionCell:(NSInteger)index{
    _selectedCategory = _categories[index];
    [self performSegueWithIdentifier:@"segueNotions" sender:self];
}
#pragma mark - Action
- (IBAction)actionCreateNotion:(id)sender {
    [self openEditDialog:false];
}


#pragma mark - Add/Remove Customized Category

- (void)openEditDialog:(BOOL)isEdit{
    NSString* title = isEdit ? @"Edit Notion":@"New Notion";
    NSString* message = @"Type new notion name";
    
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"name";
        if(isEdit)textField.text = _selectedCategory.name;
        
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* name = alert.textFields[0].text;
        if (!name || [name isEqualToString:@""]) {
            return;
        }
        if(isEdit){
            [self editSelectedCategory:name];
        }else{
            [self addCategory:name];
        }
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)editSelectedCategory:(NSString*)name {
    [self.view endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* categoryId = _selectedCategory.fid;
    NSString* tag = [NSString stringWithFormat:@"notion_categories/%@",categoryId];
    NSDictionary * parameters = @{@"category":name};
    [[AppManager sharedInstance] putRequest:tag parameter:parameters withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                message = [message isEqualToString:@""] || !message ? @"fail" : message;
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                _selectedCategory.name = name;
                for (NotionCategoryInfo* info in [AppManager sharedInstance].notionCategoryList) {
                    if (info.fid == _selectedCategory.fid) {
                        info.name = _selectedCategory.name;
                        break;
                    }
                }
                [self.m_tableView reloadData];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
}
-(void)addCategory:(NSString*)name{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * parameters = @{@"category":name};
    [[AppManager sharedInstance] postRequest:@"notion_categories" parameter:parameters withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                NSString* category_id = [response objectForKey:@"category_id"];
                NotionCategoryInfo* newCategory = [[NotionCategoryInfo alloc] initWithName:name id:category_id isDefault:false];
                [_categories addObject:newCategory];
                [self showComment];
                [self.m_tableView reloadData];
            }
        }else{
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

-(void)deleteCategoryWithData:(NotionCategoryInfo*)item{
    
    NSString* categoryId = item.fid;
    NSString* tag = [NSString stringWithFormat:@"notion_categories/%@",categoryId];
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
                
                for (NotionCategoryInfo* info in [AppManager sharedInstance].notionCategoryList) {
                    if (info.fid == item.fid) {
                        [[AppManager sharedInstance].notionCategoryList removeObject:info];
                        break;
                    }
                }
                [_categories removeObject:item];
                [self showComment];
                [self.m_tableView reloadData];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
}
- (void)showConfirmDialog:(NotionCategoryInfo*)data{
    NSString* title = @"Confirm";
    NSString* message = @"Are you sure to delete this category?";
    
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCategoryWithData:data];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark Common
-(void)showComment{
    if (_categories.count > 0) {
        [self.m_lblComment setHidden:NO];
    }else{
        [self.m_lblComment setHidden:YES];
    }
}

@end
