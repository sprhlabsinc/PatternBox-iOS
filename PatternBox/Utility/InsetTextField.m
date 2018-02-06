//
//  InsetTextField.m
//  PatternBox
//
//  Created by mac on 4/19/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "InsetTextField.h"

@implementation InsetTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 30, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 30, 0);
}
@end
