//
//  FabricHomeViewController.m
//  PatternBox
//
//  Created by mac on 3/28/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricViewController.h"
#import "AppManager.h"
#import "FabricModel.h"
#import "FabricCell.h"
#import "FabricDetailVC.h"
#import "ProjectViewController.h"
#import "SlideViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

const CGFloat PADDING = 10;
const CGFloat MAX_CELL_WIDTH = 180;
const CGFloat CONTROL_HEIGHT = 100;

@interface FabricViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _selFabric;
    NSMutableArray *_fabrics;
    CGFloat _cellWidth;
    
}

@end

@implementation FabricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.m_isAddToProject){
        [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"ADD TO PROJECT" navi:self.navigationItem];
    }else if(self.m_ViewMode == VM_Bookmarks){
        [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"BOOKMARKS" navi:self.navigationItem];
    }else if (self.m_indexOfCategory >= 0) {
        FabricCategoryInfo* info = [AppManager sharedInstance].fabricCategoryList[self.m_indexOfCategory];
        NSString* title = [info.name uppercaseString];
        [APPDELEGATE setTitleViewOfNavigationBarWithTitle:title navi:self.navigationItem];
    }
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
   
    CGFloat width = (self.view.frame.size.width - 4* PADDING) / 2;
    _cellWidth = width > MAX_CELL_WIDTH ? MAX_CELL_WIDTH:width;
    _fabrics = [[NSMutableArray alloc] init];
    
    self.m_btnAddToProject.layer.cornerRadius = 15;
    self.m_btnAddToProject.clipsToBounds = YES;
    self.m_btnAddToProject.layer.borderColor = [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:205.0/255.0 alpha:1.0].CGColor;
    self.m_btnAddToProject.layer.borderWidth = 4;
    self.m_btnAddToProject.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateAllTable];
    [self updateUI];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueFabricDetail"]) {
        FabricDetailVC *target = (FabricDetailVC *)segue.destinationViewController;
        target.m_fabricModel = _fabrics[_selFabric] ;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _fabrics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FabricCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    FabricModel* model = _fabrics[indexPath.row];
    cell.lblName.text = [NSString stringWithFormat:@"Name: %@", model.info.name];
    cell.lblType.text = [NSString stringWithFormat:@"Type: %@", model.info.type];
    cell.index = indexPath.row;
    
    UIImage *placeholderImage = [UIImage imageNamed:@"fabric"];
    [cell.imgFabric sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:model.imageUrl] placeholderImage:placeholderImage];
    
    if (model.isBookMark) {
        cell.imgBookMark.hidden = NO;
    } else {
        cell.imgBookMark.hidden = YES;
    }
    [cell.imgCheck setHidden:!model.isSelected];
   
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_cellWidth, _cellWidth);
}
#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _selFabric = indexPath.row;
    if (self.m_isAddToProject) {
        FabricModel* model = _fabrics[indexPath.row];
        model.isSelected = !model.isSelected;
        [self.m_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self updateUI];
    }else{
       [self performSegueWithIdentifier:@"segueFabricDetail" sender:self];
    }
    [self.m_collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark- SearchBar Delegate
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateAllTable];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self updateAllTable];
    [searchBar resignFirstResponder];
}

#pragma mark - Common

- (void) updateAllTable{
    NSArray* tempFabrics = [AppManager sharedInstance].fabricList;
    [_fabrics removeAllObjects];
    
    NSString *searchText = self.m_searchBar.text;
    
    if (searchText.length > 0) {
        for (FabricModel* model in tempFabrics) {
            if (!self.m_isAddToProject) {
                if (self.m_ViewMode == VM_Bookmarks && !model.isBookMark) {
                    continue;
                }
                
                if (self.m_indexOfCategory >= 0) {
                    Boolean isExist = false;
                    
                    FabricCategoryInfo* info = [AppManager sharedInstance].fabricCategoryList[self.m_indexOfCategory];
                    for (NSString* cid in model.categories) {
                        if ([cid isEqualToString: info.fid]) {
                            isExist = true;
                            break;
                        }
                    }
                    if(!isExist) continue;
                }
            }

            NSRange titleResultsRange = [model.info.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0 && titleResultsRange.location == 0){
                [_fabrics addObject:model];
            } else {
                NSRange idResultsRange = [model.info.type rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (idResultsRange.length > 0 && idResultsRange.location == 0){
                    [_fabrics addObject:model];
                }else{
                    
                    for (NSString* category in model.getCategoryNameList) {
                        NSRange categorysRange = [category rangeOfString:searchText options:NSCaseInsensitiveSearch];
                        if (categorysRange.length > 0 && categorysRange.location == 0){
                            [_fabrics addObject:model];
                            break;
                        }
                    }
                }
            }
        }
    } else {
        
        for (FabricModel* model in tempFabrics){
            if (!self.m_isAddToProject) {
                if (self.m_ViewMode == VM_Bookmarks && !model.isBookMark) {
                    continue;
                }
                
                if (self.m_indexOfCategory >= 0) {
                    Boolean isExist = false;
                    
                    FabricCategoryInfo* info = [AppManager sharedInstance].fabricCategoryList[self.m_indexOfCategory];
                    for (NSString* cid in model.categories) {
                        if ([cid isEqualToString: info.fid]) {
                            isExist = true;
                            break;
                        }
                    }
                    if(!isExist) continue;
                }
            }
            [_fabrics addObject:model];
        }
        
    }
    
    for (FabricModel* model in _fabrics) {
        model.isSelected = NO;
    }
    for (FabricModel* sModel in self.m_selectedFabrics) {
        for (FabricModel* model in _fabrics) {
            if (sModel.fid == model.fid) {
                model.isSelected = YES;
                break;
            }
        }
    }
    [self.m_collectionView reloadData];
}
-(void)updateUI{
    Boolean isHidden = true;
    for (FabricModel* model in _fabrics) {
        if (model.isSelected) {
            isHidden = false;
            break;
        }
    }
    [self.m_viewButton setHidden:isHidden];
}
#pragma mark Action
- (IBAction)actionGoToProject:(id)sender {
    NSMutableArray* fabrics = [[NSMutableArray alloc] init];
    for (FabricModel* model in _fabrics) {
        if (model.isSelected) {
            [fabrics addObject:model];
        }
    }
    if(fabrics.count == 0){
        [[AppManager sharedInstance] showMessageWithTitle:@"" message:@"Please select one fabric at least." view:self ];
    }
    
    if(self.m_openStatus == PATTERN_STATUS_SELECT){
        
        if (self.m_projectEditVC) {
            [self.m_projectEditVC updateFabricModels:fabrics];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProjectViewController *projectVC = (ProjectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProjectViewController"];
        projectVC.m_fabrics=  [fabrics mutableCopy];
        [self.navigationController pushViewController:projectVC animated:YES];
    }
}

- (IBAction)actionGoHome:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SlideViewController *homeVC = (SlideViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SlideViewController"];
    APPDELEGATE.window.rootViewController = homeVC;
}
@end
