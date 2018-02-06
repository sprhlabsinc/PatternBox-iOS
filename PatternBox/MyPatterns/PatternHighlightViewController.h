//
//  PatternHighlightViewController.h
//  PatternBox
//
//  Created by youandme on 03/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "DrawingImageView.h"
#import "PatternModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PatternHighlightViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {
    NSMutableDictionary *_pattern;
    NSArray *_categoryNames;
    
    NSIndexPath *_curPDFIndex;

}

@property (nonatomic) int m_ViewMode;
@property (nonatomic) BOOL m_isFront;
@property (nonatomic) PatternModel *m_pattern;

@property (weak, nonatomic) IBOutlet UISegmentedControl *m_segment;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIView *m_imgContainterView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgView;
@property (weak, nonatomic) IBOutlet DrawingImageView *m_drawingImgView;

- (IBAction)actionChangeTool:(id)sender;
@end
