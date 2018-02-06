//
//  ViewController.h
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>

@interface PatternHomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *m_btnScanPattern;
@property (weak, nonatomic) IBOutlet UIButton *m_btnMyPatterns;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSearchPatterns;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBookMarks;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAddToProject;

@end

