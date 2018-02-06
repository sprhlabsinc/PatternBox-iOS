//
//  FabricCategoryTableViewController.h
//  PatternBox
//
//  Created by mac on 3/31/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FabricCategoryInfo.h"

@interface FabricCategoryTableViewController : UITableViewController{
    NSMutableArray* _categories;
    FabricCategoryInfo* _selectedCategory;
}

- (IBAction)addNewCategoryAction:(id)sender;

@end
