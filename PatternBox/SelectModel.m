//
//  SelectModel.m
//  PatternBox
//
//  Created by mac on 4/7/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "SelectModel.h"

@implementation SelectModel

-(id)initWithName:(NSString *)key{
    self = [super init];
    if(self){
        self.key = key;
        self.isSelected = NO;
    }
    return self;
}
-(id)initWithName:(NSString *)key id:(BOOL)isSelected{
    self = [super init];
    if(self){
        self.key = key;
        self.isSelected = isSelected;
    }
    return self;
}

@end
