//
//  ViewController.h
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectEditController.h"
#import "PatternModel.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PatternViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *m_viewCollection;

@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_contraintTopViewHeight;

@property (weak, nonatomic) ProjectEditController *m_projectEditVC;
@property (nonatomic) NSInteger m_openStatus;
@property( nonatomic) PatternModel* m_selectedPattern;

@property (nonatomic) NSInteger m_ViewMode;
@property (nonatomic) NSInteger m_indexOfCategory;
@property (nonatomic) Boolean   m_isAddToProject;
- (IBAction)actionGoHome:(id)sender;

@end

