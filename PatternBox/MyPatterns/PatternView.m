//
//  PatternView.m
//  PatternBox
//
//  Created by youandme on 03/09/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PatternView.h"

@implementation PatternView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithNibName:(NSString*)nibNameOrNil {
    self = [super init];
    
    if (self) {
        // Initialization code
        NSArray* _nibContents = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                              owner:self
                                                            options:nil];
        self = [_nibContents objectAtIndex:0];
        
        [self initialUIAtLaunch];
        self.m_isFrontImage = YES;
    }
    
    return self;
}

#pragma mark - Actions
- (IBAction)actionEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PatternView:didPressedEditButton:)]) {
        [self.delegate PatternView:self didPressedEditButton:sender];
    }
}

- (IBAction)actionBookmark:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PatternView:didPressedBookmarkButton:)]) {
        [self.delegate PatternView:self didPressedBookmarkButton:sender];
    }
}

- (IBAction)actionInfoEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PatternView:didPressedInfoEditButton:)]) {
        [self.delegate PatternView:self didPressedInfoEditButton:sender];
    }
}

- (IBAction)actionDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PatternView:didPressedDeleteButton:)]) {
        [self.delegate PatternView:self didPressedDeleteButton:sender];
    }
}

- (IBAction)actionTurnImage:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PatternView:didPressedButton:)]) {
        [self.delegate PatternView:self didPressedButton:sender];
    }
}

#pragma mark - Zoom
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents:scrollView];
}

- (void)centerScrollViewContents:(UIScrollView*)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect contentsFrame = self.m_imgView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.m_imgView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.m_imgView;
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    [self.m_scrollView setContentSize:self.m_imgView.frame.size];
    self.m_scrollView.maximumZoomScale = 2.0;
    self.m_scrollView.minimumZoomScale = 1.0;
}

@end
