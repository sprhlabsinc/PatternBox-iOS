//
//  FabricCategoryVC.h
//  PatternBox
//
//  Created by mac on 4/14/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabricCategoryVC : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource> {
    NSInteger _selCategory;
    NSInteger _preSelCategory;
    NSString* _userID;
    NSMutableArray * _categories;
}
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;
@end
