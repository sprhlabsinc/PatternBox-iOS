//
//  WholePatternsViewController.h
//  PatternBox
//
//  Created by youandme on 03/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternView.h"
#import "PatternModel.h"

@interface WholePatternsViewController : UIViewController <UIScrollViewDelegate, PatternViewDelegate> {
    NSMutableArray *_patterns;
    NSInteger _curIndex;
    NSMutableArray *_visiblePatternViews;
    BOOL _isFront;
}

@property (nonatomic) int m_ViewMode;
@property (nonatomic) BOOL m_isRemovable;
@property (nonatomic) NSInteger m_indexOfCategory;
@property (weak, nonatomic) PatternModel *m_pattern;



@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@end
