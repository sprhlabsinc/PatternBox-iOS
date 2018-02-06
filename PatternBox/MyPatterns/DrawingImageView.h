//
//  DrawingImageView.h
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface DrawingImageView : UIImageView {
    CGPoint _lastPoint;
    CGFloat _red;
    CGFloat _green;
    CGFloat _blue;
    CGFloat _brush;
    CGFloat _opacity;
    
    BOOL _mouseSwiped;
    int _mode;
}

- (void)setPencil:(CGFloat)brush red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue opacity:(CGFloat)opacity;
- (void)setMode:(int)mode;

@end
