//
//  NotionsForProjectVC.h
//  PatternBox
//
//  Created by mac on 4/20/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectEditController.h"

@interface NotionsForProjectVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@property (weak, nonatomic)   ProjectEditController *m_projectEditVC;
@property (strong, nonatomic) NSArray *m_notions;

-(void)updateNotionsWith:(NSArray*)notions;
- (IBAction)actionAddToProject:(id)sender;

@end
