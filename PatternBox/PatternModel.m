//
//  PatternModel.m
//  PatternBox
//
//  Created by mac on 4/4/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "PatternModel.h"
#import "Define.h"
#import "PatternCategoryInfo.h"
#import "AppManager.h"
@implementation PatternModel



-(id)init{
    self = [super init];
    if (self) {
        self.fid = -1;
    }
    return self;
}

-(id)initWithData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        self.fid = [[data objectForKey:KPatternId] integerValue];
        self.name = [data objectForKey:KPatternName];
        self.type = [data objectForKey:KPatternKey];
        self.frontImage = [data objectForKey:KPatternFronPic];
        self.backImage = [data objectForKey:KPatternBackPic];
        self.notes = [data objectForKey:KPatternInfo];
        self.isBookMark = [[data objectForKey:KPatternBookMark] integerValue];
        self.isPDF = [[data objectForKey:KPatternIsPDF] integerValue];
        
        NSString* strCategories = [data objectForKey:KPatternCategories];
        self.categories = [strCategories componentsSeparatedByString:@","];
        
        NSString* strUrls = [data objectForKey:KPatternUrls];
        self.pdfUrls = [strUrls componentsSeparatedByString:@","];
    }
    return self;
}

-(void)updateWithData:(NSDictionary *)data{
    self.name = [data objectForKey:KPatternName];
    self.type = [data objectForKey:KPatternKey];
    self.notes = [data objectForKey:KPatternInfo];
    NSString* strCategories = [data objectForKey:KPatternCategories];
    self.categories = [strCategories componentsSeparatedByString:@","];
}
-(NSArray*)getCategoryNameList{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSString* cid in self.categories) {
        for (PatternCategoryInfo* info in [AppManager sharedInstance].patternCategoryList) {
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
    if (self.fid) [dic setObject:[NSNumber numberWithInteger:self.fid] forKey:KPatternId];
    if (self.name) [dic setObject:self.name forKey:KPatternName];
    if (self.type) [dic setObject:self.type forKey:KPatternKey];
    if (self.frontImage) [dic setObject:self.frontImage forKey:KPatternFronPic];
    if (self.backImage) [dic setObject:self.backImage forKey:KPatternBackPic];
    if (self.notes) [dic setObject:self.notes forKey:KPatternInfo];
    if (self.isBookMark) [dic setObject:[NSNumber numberWithInteger:self.isBookMark] forKey:KPatternBookMark];
    if (self.isPDF) [dic setObject:[NSNumber numberWithInteger:self.isPDF] forKey:KPatternIsPDF];
    if (self.categories) {
        NSString* strCate = [self.categories componentsJoinedByString:@","];
        [dic setObject:strCate forKey:KPatternCategories];
    }
    if (self.pdfUrls) {
        NSString* strCate = [self.pdfUrls componentsJoinedByString:@","];
        [dic setObject:strCate forKey:KPatternUrls];
    }
   
    return dic;
}

-(PatternModel*)createClone{
    NSDictionary* dic = [self getDictionaryData];
    PatternModel* model = [[PatternModel alloc] initWithData:dic];
    model.fid = self.fid;
    return model;
}
@end
