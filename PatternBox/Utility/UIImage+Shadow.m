//
//  UIImage+Shadow.m
//  PatternBox
//
//  Created by mac on 4/20/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "UIImage+Shadow.h"

@implementation UIImage(Shadow)

- (UIImage *)imageWithFileShadow {
    static CGFloat pointScale = -1.0f;
    if (pointScale < 0.0f) {
        pointScale = [[UIScreen mainScreen] scale];
    }
    
    CGFloat imageWidth = (int)self.size.width;
    CGFloat imageHeight = (int)self.size.height;
    
    UIImage * shadowImage = [[UIImage imageNamed:@"shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 100.0f, 100.0f)];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, pointScale);
    [shadowImage drawInRect:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight) blendMode:kCGBlendModeNormal alpha:1.0f];
    [self drawInRect:CGRectMake(5.0f, 2.0f, self.size.width - 10.0f, self.size.height - 6.0f)];
    
    UIImage * mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mergedImage;
}
@end
