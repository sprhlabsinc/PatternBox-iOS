//
//  DrawingImageView.m
//  PatternBox
//
//  Created by youandme on 04/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "DrawingImageView.h"

@implementation DrawingImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _red = 0.0/255.0;
        _green = 0.0/255.0;
        _blue = 0.0/255.0;
        _brush = 10.0;
        _opacity = 1.0;
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mode == mode_Zoom) return;
    
    _mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    _lastPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mode == mode_Zoom) return;

    _mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    if (_mode == mode_Erase) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
        CGContextBeginTransparencyLayer(ctx, NULL);
        {
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 0.5);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brush);
            CGContextBeginPath(UIGraphicsGetCurrentContext());
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextStrokePath(ctx);
        }
        CGContextEndTransparencyLayer(ctx);
        self.image = UIGraphicsGetImageFromCurrentImageContext();
    } else {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), _red, _green, _blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        [self setAlpha:_opacity];
    }
    
    UIGraphicsEndImageContext();
    _lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mode == mode_Zoom) return;

    if(!_mouseSwiped && (_mode != mode_Erase)) {
        UIGraphicsBeginImageContext(self.frame.size);
        [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), _red, _green, _blue, _opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

#pragma mark - Globals
- (void)setPencil:(CGFloat)brush red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue opacity:(CGFloat)opacity {
    _red = red/255.0;
    _green = green/255.0;
    _blue = blue/255.0;
    _brush = brush;
    _opacity = opacity;
}

- (void)setMode:(int)mode {
    _mode = mode;
    if (_mode == mode_Zoom) {
        self.userInteractionEnabled = NO;
    } else {
        self.userInteractionEnabled = YES;
    }
}

@end
