//
//  ProjectViewController.h
//  PatternBox
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FabricModel.h"
#import "PatternModel.h"
#import "NotionModel.h"

@interface ProjectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;

@property (strong, nonatomic) PatternModel *m_pattern;
@property (strong, nonatomic) NSArray *m_fabrics;
@property (strong, nonatomic) NSArray *m_notions;

@end
