//
//  NotionHomeVC.h
//  PatternBox
//
//  Created by mac on 4/20/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectEditController.h"
#import "NotionModel.h"

@interface NotionHomeVC : UIViewController

@property (nonatomic) NSInteger m_openStatus;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@property (weak, nonatomic) ProjectEditController *m_projectEditVC;

@property (weak, nonatomic) IBOutlet UILabel *m_lblComment;

- (IBAction)actionCreateNotion:(id)sender;
@end
