//
//  HomeViewController.h
//  PatternBox
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import "AppManager.h"

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *m_btnPatterns;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFabric;
@property (weak, nonatomic) IBOutlet UIButton *m_btnNotions;
@property (weak, nonatomic) IBOutlet UIButton *m_btnProjects;

- (IBAction)showFabric:(id)sender;
- (IBAction)showNotion:(id)sender;
- (IBAction)showProject:(id)sender;

@end
