//
//  CustomizeViewController.h
//  PatternBox
//
//  Created by Mac on 14/02/2017.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "PatternCategoryInfo.h"

@interface CustomizeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    PatternCategoryInfo* _selectedCategory;
    NSMutableArray* _categories;
}

@property (nonatomic)  BOOL isRefresh;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
- (IBAction)addNewCategory:(id)sender;


@end
