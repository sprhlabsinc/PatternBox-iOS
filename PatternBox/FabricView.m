//
//  FabricView.m
//  PatternBox
//
//  Created by mac on 3/31/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricView.h"

@implementation FabricView

-(id)initWithNibName:(NSString*)nibNameOrNil {
    self = [super init];
    
    if (self) {
        // Initialization code
        NSArray* _nibContents = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                              owner:self
                                                            options:nil];
        self = [_nibContents objectAtIndex:0];
        
        [self initialUIAtLaunch];

    }
    
    return self;
}


#pragma mark - Actions
- (IBAction)actionEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FabricView:didPressedEditButton:)]) {
        [self.delegate FabricView:self didPressedEditButton:sender];
    }
}

- (IBAction)actionBookmark:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FabricView:didPressedBookmarkButton:)]) {
        [self.delegate FabricView:self didPressedBookmarkButton:sender];
    }
}

- (IBAction)actionInfoEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FabricView:didPressedInfoEditButton:)]) {
        [self.delegate FabricView:self didPressedInfoEditButton:sender];
    }
}

- (IBAction)actionDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FabricView:didPressedDeleteButton:)]) {
        [self.delegate FabricView:self didPressedDeleteButton:sender];
    }
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    [self.m_scrollView setContentSize:self.m_imgView.frame.size];
    self.m_scrollView.maximumZoomScale = 2.0;
    self.m_scrollView.minimumZoomScale = 1.0;
}
@end
