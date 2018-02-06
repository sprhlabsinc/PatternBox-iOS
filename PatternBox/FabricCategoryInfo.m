//
//  FabricCategoryInfo.m
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricCategoryInfo.h"

@implementation FabricCategoryInfo

-(id)initWithName:(NSString *)name id:(NSString *)fid isDefault:(Boolean)isDefault{
    self = [super init];
    if(self){
        self.name = name;
        self.fid = fid;
        self.isDefault = isDefault;
    }
    return self;
}

@end
