//
//  PatternCategoryInfo.m
//  PatternBox
//
//  Created by mac on 4/4/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "PatternCategoryInfo.h"

@implementation PatternCategoryInfo
-(id)initWithName:(NSString *)name id:(NSString *)fid isDefault:(Boolean)isDefault{
    self = [super init];
    if(self){
        self.name = name;
        self.fid = fid;
        self.isDefault = isDefault;
    }
    return self;
}
-(id)initWithName:(NSString *)name id:(NSString *)fid icon:(NSString *)icon{
    self = [super init];
    if(self){
        self.name = name;
        self.fid = fid;
        self.icon = icon;
        self.isDefault = YES;
    }
    return self;
}
@end
