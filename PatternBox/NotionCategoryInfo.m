//
//  NotionCategoryInfo.m
//  PatternBox
//
//  Created by mac on 4/5/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "NotionCategoryInfo.h"
#import "AppManager.h"

@implementation NotionCategoryInfo

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
