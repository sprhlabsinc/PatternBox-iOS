//
//  FabricCategoryVC.m
//  PatternBox
//
//  Created by mac on 4/14/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricCategoryVC.h"
#import "AppManager.h"
#import "CategoryCell.h"
#import "FabricViewController.h"
#import "FabricCategoryInfo.h"

@interface FabricCategoryVC ()

@end

@implementation FabricCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"FABRIC CATEGORIES" navi:self.navigationItem];
    
    _selCategory = -1;
    
    
    self.m_collectionView.delegate = self;
    self.m_collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _categories = [AppManager sharedInstance].fabricCategoryList;
    [self.m_collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"segueFabric"]) {
        FabricViewController *target = (FabricViewController *)segue.destinationViewController;
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
        FabricCategoryInfo* item = _categories[indexPath.row];
        NSString* categoryName = item.name;
        cell.m_lableCategoryName.text = [categoryName uppercaseString];
        cell.m_imgCategoryIcon.image = nil;
        
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
        
        [self performSegueWithIdentifier:@"segueCategory" sender:self];
    }else{
        [self performSegueWithIdentifier:@"segueFabric" sender:self];
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(30, 30, 30, 30);
}
@end
