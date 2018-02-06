//
//  CustomLabel.m
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)resetSize{
    CGRect rect = self.frame;
    [self sizeToFit];
    CGRect fitRect = self.frame;
    CGFloat width = fitRect.size.width > _maxSize ? _maxSize :fitRect.size.width + 10;
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    if (_isLeft) {
        self.frame = CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: (CGSize){_radius, _radius}].CGPath;
        
    }else{

        self.frame = CGRectMake(rect.origin.x - (width - rect.size.width), rect.origin.y, width, rect.size.height);
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){_radius, _radius}].CGPath;
    }
    self.layer.mask = maskLayer;
    
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
- (void)setText:(NSString *)text {
    [super setText:text];
    if (_isAutoSize) {
        [self resetSize];
    }
}

@end
