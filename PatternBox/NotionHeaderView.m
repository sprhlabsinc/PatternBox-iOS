//
//  NotionHeaderView.m
//  PatternBox
//
//  Created by mac on 4/20/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "NotionHeaderView.h"

@implementation NotionHeaderView

-(id)initWithNibName:(NSString*)nibNameOrNil {
    self = [super init];
    
    if (self) {
        NSArray* _nibContents = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                              owner:self
                                                            options:nil];
        self = [_nibContents objectAtIndex:0];
        
        self.isCollapsed = false;
       
    }
    
    return self;
}

- (IBAction)actionArrow:(id)sender {
    if (self.isCollapsed) {
        self.isCollapsed = false;
        [self.btnArrow setImage:[UIImage imageNamed:@"arrow_bottom"] forState:UIControlStateNormal];
    }else{
        self.isCollapsed = true;
        [self.btnArrow setImage:[UIImage imageNamed:@"arrow_top"] forState:UIControlStateNormal];
    }
    [self.delegate notionHeaderView:self didCollapseTable:self.isCollapsed section:self.section];
}

- (IBAction)actionAdd:(id)sender {
    [self.delegate notionHeaderView:self didAddNotions:self.section];
}

-(void)setIsCollapsed:(Boolean)isCollapsed{
    _isCollapsed = isCollapsed;
    if (self.isCollapsed) {
        [self.btnArrow setImage:[UIImage imageNamed:@"arrow_bottom"] forState:UIControlStateNormal];
    }else{
        [self.btnArrow setImage:[UIImage imageNamed:@"arrow_top"] forState:UIControlStateNormal];
    }
}
@end
