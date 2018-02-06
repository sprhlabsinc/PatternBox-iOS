//
//  NotionViewController.h
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotionsForProjectVC.h"
#import "NotionCategoryInfo.h"

@interface NotionViewController : UIViewController

@property (strong,nonatomic) NotionCategoryInfo* m_category;
@property (strong, nonatomic) NSArray *m_notions;

@property (weak, nonatomic) IBOutlet UIButton *btnAddToProject;
@property (nonatomic) NSInteger m_openStatus;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@property (weak, nonatomic) NotionsForProjectVC *m_projectEditVC;

@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;

- (IBAction)actionCreateNotion:(id)sender;
- (IBAction)actionAddToProject:(id)sender;

@end
