//
//  AppDelegate.h
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setTitleViewOfNavigationBar:(UINavigationItem *)navigationItem;
- (void)setTitleViewOfNavigationBarWithTitle:(NSString *)title navi:(UINavigationItem *)navigationItem;
- (void)setViewMovedUp:(BOOL)movedUp view:(UIView*)view offset:(CGFloat)offset;
- (void)changeStoryboard;
- (void)logout;
@end

