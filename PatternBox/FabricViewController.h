//
//  FabricHomeViewController.h
//  PatternBox
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Define.h"

#import "ProjectEditController.h"

@interface FabricViewController : UIViewController

@property (nonatomic) NSInteger m_openStatus;
@property( nonatomic) NSArray* m_selectedFabrics;


@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;
@property (weak, nonatomic) IBOutlet UIView *m_viewButton;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAddToProject;

@property (weak, nonatomic) ProjectEditController *m_projectEditVC;
- (IBAction)actionGoToProject:(id)sender;
- (IBAction)actionGoHome:(id)sender;

@property (nonatomic) NSInteger m_ViewMode;
@property (nonatomic) NSInteger m_indexOfCategory;
@property (nonatomic) Boolean   m_isAddToProject;

@end
