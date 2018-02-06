//
//  ViewController.m
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternViewController.h"
#import "Define.h"
#import "PatternEditViewController.h"
#import "SearchPatternsViewController.h"
#import "AppManager.h"
#import "PatternViewCell.h"
#import "PatternModel.h"
#import "NotionModel.h"
#import "PurchaseController.h"
#import "ProjectViewController.h"
#import "PatternCategoryInfo.h"
#import "WholePatternsViewController.h"
#import "PatternDetailViewController.h"
#import "SlideViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

const CGFloat P_PADDING = 10;
const CGFloat P_MAX_CELL_WIDTH = 180;
const CGFloat P_CONTROL_HEIGHT = 100;

@interface PatternViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate, PatternViewCellCellDelegate,UITextFieldDelegate,UITextViewDelegate>{
    NSMutableArray* _patterns;
    NSInteger _selPattern;
    CGFloat _cellWidth;
}

@end

@implementation PatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[APPDELEGATE setTitleViewOfNavigationBar:self.navigationItem];
    
    CGFloat width = (self.view.frame.size.width - 4* P_PADDING) / 2;
    _cellWidth = width > P_MAX_CELL_WIDTH ? P_MAX_CELL_WIDTH:width;
    _patterns = [[NSMutableArray alloc] init];
    
    if(self.m_isAddToProject){
       [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"ADD TO PROJECT" navi:self.navigationItem];
    }else if(self.m_ViewMode == VM_Bookmarks){
        [APPDELEGATE setTitleViewOfNavigationBarWithTitle:@"BOOKMARKS" navi:self.navigationItem];
    }else if (self.m_indexOfCategory >= 0) {
        PatternCategoryInfo* info = [AppManager sharedInstance].patternCategoryList[self.m_indexOfCategory];
        NSString* title = [info.name uppercaseString];
        [APPDELEGATE setTitleViewOfNavigationBarWithTitle:title navi:self.navigationItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateAllTable];
//    if (self.m_selectedPattern) {
//        for (int i = 0; i < _patterns.count; i++) {
//            PatternModel* model = _patterns[i];
//            if (self.m_selectedPattern.fid == model.fid) {
//                [self.view layoutIfNeeded];
//                NSIndexPath* indexPath =  [NSIndexPath indexPathWithIndex:i];
//                [self.m_viewCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
//                break;
//            }
//        }
//    }

}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"segueScanPattern"]) {
        WholePatternsViewController *target = (WholePatternsViewController *)segue.destinationViewController;
        target.m_ViewMode = VM_Bookmarks;
        target.m_isRemovable = NO;
        PatternModel* model = _patterns[_selPattern];
        target.m_pattern = model;
    }else if ([segue.identifier isEqualToString:@"seguePDFPattern"]) {
        PatternDetailViewController *target = (PatternDetailViewController *)segue.destinationViewController;
        PatternModel* model = _patterns[_selPattern] ;
        target.m_pattern = [model createClone];
        target.m_ViewMode = VM_PDFs;
    }
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _patterns.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PatternViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    PatternModel* model = _patterns[indexPath.row];
    cell.lblName.text = [NSString stringWithFormat:@"NAME: %@", model.name];
    cell.lblType.text = [NSString stringWithFormat:@"ID: %@", model.type];

    cell.index = indexPath.row;
    cell.delegate = self;
    
    UIImage *placeholderImage;
    if (model.isPDF) {
        placeholderImage = [UIImage imageNamed:@"icon_PDFdoc.png"];
    }else{
        placeholderImage = [UIImage imageNamed:@"icon_Camera.png"];
    }
    placeholderImage = [UIImage imageNamed:@"thumb_pattern_detail"];
    
    [cell.imgPattern sd_setImageWithURL:[[AppManager sharedInstance] downloadUrlWithFileName:model.frontImage] placeholderImage:placeholderImage];
    
    if (model.isBookMark) {
        cell.imgBookMark.hidden = NO;
    } else {
        cell.imgBookMark.hidden = YES;
    }
    
    if (self.m_selectedPattern && self.m_selectedPattern.fid == model.fid) {
        cell.layer.borderWidth = 4;
    }else{
        cell.layer.borderWidth = 0;
    }
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(P_PADDING, P_PADDING, P_PADDING, P_PADDING);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_cellWidth, _cellWidth);
}
#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _selPattern = indexPath.row;
    PatternModel* model = _patterns[_selPattern];
    
    if (self.m_isAddToProject) {
        if (self.m_projectEditVC) {
            [self.m_projectEditVC updatePatternModel:model];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProjectViewController *projectVC = (ProjectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProjectViewController"];
            projectVC.m_pattern=  model;
            [self.navigationController pushViewController:projectVC animated:YES];
        }
    }else{
        if (model.isPDF) {
            [self performSegueWithIdentifier:@"seguePDFPattern" sender:self];
        }else{
            [self performSegueWithIdentifier:@"segueScanPattern" sender:self];
        }
    }
    
    
}
#pragma mark PatternViewCellDelegate

-(void)patternViewCellSelected:(NSInteger)index{
    if (self.m_selectedPattern) {
        [self.m_projectEditVC updatePatternModel:_patterns[index]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProjectViewController *projectVC = (ProjectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProjectViewController"];
        projectVC.m_pattern = _patterns[index];
        [self.navigationController pushViewController:projectVC animated:YES];
    }
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


- (void) updateAllTable {
    
    NSArray* tempFabrics = [AppManager sharedInstance].patternList;
    [_patterns removeAllObjects];
    
    NSString *searchText = self.m_searchBar.text;
    
    if (searchText.length > 0) {
        for (PatternModel* model in tempFabrics) {
            if (!self.m_isAddToProject) {
                if (self.m_ViewMode == VM_Bookmarks && !model.isBookMark) {
                    continue;
                }
                
                if(self.m_ViewMode == VM_PDFs && !model.isPDF){
                    continue;
                }
                
                if(self.m_ViewMode == VM_Scans && model.isPDF){
                    continue;
                }
                if (self.m_indexOfCategory >= 0) {
                    Boolean isExist = false;
                    PatternCategoryInfo* info = [AppManager sharedInstance].patternCategoryList[self.m_indexOfCategory];
                    for (NSString* cid in model.categories) {
                        if ([cid isEqualToString: info.fid]) {
                            isExist = true;
                            break;
                        }
                    }
                    if(!isExist) continue;
                }
            }
            
            NSRange titleResultsRange = [model.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0 && titleResultsRange.location == 0){
                [_patterns addObject:model];
            } else {
                NSRange idResultsRange = [model.type rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (idResultsRange.length > 0 && idResultsRange.location == 0){
                    [_patterns addObject:model];
                }else{
                    
                    for (NSString* category in model.getCategoryNameList) {
                        NSRange categorysRange = [category rangeOfString:searchText options:NSCaseInsensitiveSearch];
                        if (categorysRange.length > 0 && categorysRange.location == 0){
                            [_patterns addObject:model];
                            break;
                        }
                    }
                }
            }
        }
    } else {
        for (PatternModel* model in tempFabrics){
            
            if (!self.m_isAddToProject) {
                if (self.m_ViewMode == VM_Bookmarks && !model.isBookMark) {
                    continue;
                }
                
                if(self.m_ViewMode == VM_PDFs && !model.isPDF){
                    continue;
                }
                
                if(self.m_ViewMode == VM_Scans && model.isPDF){
                    continue;
                }
                if (self.m_indexOfCategory >= 0) {
                    Boolean isExist = false;
                    PatternCategoryInfo* info = [AppManager sharedInstance].patternCategoryList[self.m_indexOfCategory];
                    for (NSString* cid in model.categories) {
                        if ([cid isEqualToString: info.fid]) {
                            isExist = true;
                            break;
                        }
                    }
                    if(!isExist) continue;
                }
            }
            [_patterns addObject:model];
        }
        
    }
    
    [self.m_viewCollection reloadData];
}
#pragma mark - Common

- (void)takePatternsFrom {
    _patterns = [[NSMutableArray alloc] initWithArray:[AppManager sharedInstance].patternList];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[AppManager sharedInstance] getRequest:@"patterns" parameter:nil withCallback:^(NSArray *response, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (!error) {
//            NSMutableArray* tempList = [[NSMutableArray alloc] init];
//            for (NSDictionary* child in response) {
//                PatternModel* model = [[PatternModel alloc] initWithData:child];
//                [tempList addObject:model];
//            }
//            _patterns = [tempList mutableCopy];
//            [AppManager sharedInstance].patternList = tempList;
//            
//            [self.m_viewCollection reloadData];
//        } else {
//            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
//        }
//    }];
}


- (IBAction)actionGoHome:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SlideViewController *homeVC = (SlideViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SlideViewController"];
    APPDELEGATE.window.rootViewController = homeVC;
}
@end
