//
//  SearchViewController.h
//  PatternBox
//
//  Created by youandme on 05/08/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    NSMutableArray *_patterns;
    NSIndexPath *_curIndexPath;

}

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;

@end
