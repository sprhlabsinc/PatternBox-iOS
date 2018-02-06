//
//  CategoriesViewController.h
//  PatternBox
//
//  Created by youandme on 30/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource> {
    NSInteger _selCategory;
    NSInteger _preSelCategory;
    NSMutableArray * _categories;
}

@property (nonatomic) int m_ViewMode;

@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;


@end
