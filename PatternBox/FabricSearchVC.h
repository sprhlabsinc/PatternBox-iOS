//
//  FabricSearchVC.h
//  PatternBox
//
//  Created by mac on 4/14/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabricSearchVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    NSMutableArray *_fabrics;
    NSIndexPath *_curIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;
@end
