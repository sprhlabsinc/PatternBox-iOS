//
//  CategoriesViewController.m
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "CategoriesViewController.h"
#import "Define.h"
#import "PatternViewController.h"
#import "WholePatternsViewController.h"
#import "CustomizeViewController.h"
#import "AppManager.h"
#import "CategoryCell.h"

@interface CategoriesViewController ()

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"PATTERN CATEGORIES" navi:self.navigationItem];
    
    self.m_collectionView.delegate = self;
    self.m_collectionView.dataSource = self;
    
    _selCategory = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _categories = [AppManager sharedInstance].patternCategoryList;
    [self.m_collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"seguePatternDetail"]) {
        PatternViewController *target = (PatternViewController *)segue.destinationViewController;
        target.m_ViewMode = self.m_ViewMode;
        target.m_indexOfCategory = _selCategory;
    }
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section{
    return _categories.count + 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CategoryCell *cell = (CategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == _categories.count) {
        cell.m_imgCategoryIcon.image = [UIImage imageNamed:@"c_plus"];
        cell.m_lableCategoryName.text = @"";
        [cell setCellSelect:false];
        
    }else{
        PatternCategoryInfo* item = _categories[indexPath.row];
        NSString* categoryName = item.name;
        cell.m_lableCategoryName.text = [categoryName uppercaseString];
        if (item.isDefault) {
            UIImage* image = [UIImage imageNamed:item.icon];
            cell.m_imgCategoryIcon.image = image;
        }else{
            cell.m_imgCategoryIcon.image = [[AppManager sharedInstance] createInitial:item.name];
        }
       
        if (_selCategory == indexPath.row) {
            [cell setCellSelect:true];
        }else{
            [cell setCellSelect:false];
        }
    }

    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath * preIndex = [NSIndexPath indexPathWithIndex:_preSelCategory];
    CategoryCell *precell = (CategoryCell *)[self.m_collectionView cellForItemAtIndexPath:preIndex];
    [precell setCellSelect:false];
    _selCategory = indexPath.row;
    _preSelCategory = _selCategory;
    CategoryCell *cell = (CategoryCell *)[self.m_collectionView cellForItemAtIndexPath:indexPath];
    [cell setCellSelect:true];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if (indexPath.row == _categories.count) {
        
        [self performSegueWithIdentifier:@"sequeCategory" sender:self];
    }else{
        [self performSegueWithIdentifier:@"seguePatternDetail" sender:self];
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(30, 30, 30, 30);
}

@end
