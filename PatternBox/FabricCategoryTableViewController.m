//
//  FabricCategoryTableViewController.m
//  PatternBox
//
//  Created by mac on 3/31/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricCategoryTableViewController.h"
#import "AppManager.h"

#import <MBProgressHUD/MBProgressHUD.h>


@interface FabricCategoryTableViewController ()

@end

@implementation FabricCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _categories =[[NSMutableArray alloc] initWithArray:[self getCustomziedFabricCatoryList]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    FabricCategoryInfo* info = _categories[indexPath.row];
    cell.textLabel.text = info.name;
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
                                         _selectedCategory = _categories[indexPath.row];
                                         [self openEditDialog:YES];
                                     }];
    btnEdit.backgroundColor = [UIColor blueColor]; //arbitrary color
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"DELETE" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                       {
                                           FabricCategoryInfo* info = _categories[indexPath.row];
                                           _selectedCategory = info;
                                           [self showConfirmDialog:_selectedCategory];
                                       }];
    btnDelete.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[btnEdit, btnDelete]; //array with all the buttons you want. 1,2,3, etc...
}

#pragma mark - Add/Remove Customized Category

- (void)openEditDialog:(BOOL)isEdit{
    NSString* title = isEdit ? @"Edit Category":@"New Category";
    NSString* message = isEdit ?@"Type category name":@"Type new category name";
    
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
- (void)showConfirmDialog:(FabricCategoryInfo*)data{
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
-(void)deleteCategoryWithData:(FabricCategoryInfo*)item{
    
    NSString* categoryId = item.fid;
    NSString* tag = [NSString stringWithFormat:@"fabric_categories/%@",categoryId];
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
                
                [_categories removeObject:item];
                [[AppManager sharedInstance] resetFabricCategoryList:_categories];
                [self.tableView reloadData];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
}
- (void)editSelectedCategory:(NSString*)name {
    [self.view endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* categoryId = _selectedCategory.fid;
    NSString* tag = [NSString stringWithFormat:@"fabric_categories/%@",categoryId];
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
                [[AppManager sharedInstance] resetFabricCategoryList:_categories];
                [self.tableView reloadData];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
    
}
-(void)addCategory:(NSString*)name{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * parameters = @{@"category":name};
    [[AppManager sharedInstance] postRequest:@"fabric_categories" parameter:parameters withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                NSString* category_id = [response objectForKey:@"category_id"];
                category_id = [NSString stringWithFormat:@"%@",category_id];
                FabricCategoryInfo* newCategory = [[FabricCategoryInfo alloc] initWithName:name id:category_id isDefault:false];
                [_categories addObject:newCategory];
                [[AppManager sharedInstance] resetFabricCategoryList:_categories];
                [self.tableView reloadData];
            }
        }else{
          [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}

- (IBAction)addNewCategoryAction:(id)sender {
    [self openEditDialog:false];
}
#pragma mark Common
-(NSArray*)getCustomziedFabricCatoryList{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (FabricCategoryInfo* info in [AppManager sharedInstance].fabricCategoryList) {
        if (!info.isDefault) {
            [result addObject:info];
        }
    }
    return result;
}
@end
