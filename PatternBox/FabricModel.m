//
//  FabricModel.m
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricModel.h"
#import "FabricInfo.h"
#import "Define.h"
#import "AppManager.h"

@implementation FabricModel
-(id)initWithData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        self.fid = [[data objectForKey:KFabricId] integerValue];
        self.imageUrl = [data objectForKey:KFabricImageName];
        self.isBookMark = [[data objectForKey:KFabricBookMark] integerValue];
        NSString* strCategories = [data objectForKey:KFabricCategories];
        self.categories = [strCategories componentsSeparatedByString:@","];
        self.info = [[FabricInfo alloc] initWithData:data];
    }
    return self;
}
-(NSArray*)getCategoryNameList{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSString* cid in self.categories) {
        for (FabricCategoryInfo* info in [AppManager sharedInstance].fabricCategoryList) {
            if ([cid isEqualToString:info.fid]) {
                [result addObject:info.name];
                break;
            }
        }
    }

    return result;
}
-(NSDictionary*)getDictionaryData{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (self.fid) [dic setObject:[NSNumber numberWithInteger:self.fid] forKey:KFabricId];
    if (self.imageUrl) [dic setObject:self.imageUrl forKey:KFabricImageName];
    if (self.isBookMark) [dic setObject:[NSNumber numberWithInteger:self.isBookMark] forKey:KFabricBookMark];
    if (self.categories) {
        NSString* strCate = [self.categories componentsJoinedByString:@","];
        [dic setObject:strCate forKey:KFabricCategories];
    }
    if (self.info) {
        NSDictionary* infoDic = [self.info getDictionaryData];
        [dic addEntriesFromDictionary:infoDic];
    }
    return dic;
}

-(FabricModel*)createClone{
    NSDictionary* dic = [self getDictionaryData];
    FabricModel* model = [[FabricModel alloc] initWithData:dic];
    model.isSelected = self.isSelected;
    return model;
}
@end
