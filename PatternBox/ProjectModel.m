//
//  ProjectModel.m
//  PatternBox
//
//  Created by mac on 4/10/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "ProjectModel.h"
#import "Define.h"
#import "AppManager.h"

@implementation ProjectModel
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
        self.fid = [[data objectForKey:KProjectId] integerValue];
        self.name = [data objectForKey:KProjectName];
        self.notes = [data objectForKey:KProjectNotes];
        self.client = [data objectForKey:KProjectClient];
        self.measurements = [data objectForKey:KProjectMeasurement];
        self.image = [data objectForKey:KProjectImageName];
        
        self.pattern = [[data objectForKey:KProjectPattern] integerValue];
        NSString* strFabrics = [data objectForKey:KProjectFabrics];
        if (strFabrics && ![strFabrics isEqualToString:@""]) {
            self.fabrics = [strFabrics componentsSeparatedByString:@","];
        }else{
            self.fabrics= [[NSArray alloc] init];
        }
        
        
        NSString* content = [data objectForKey:KProjectNotions];

        NSArray* vals = [content componentsSeparatedByString:@":"];
        NSMutableArray* temp = [[NSMutableArray alloc] init];
        for (NSString* strNotion in vals) {
            NSArray* strVal = [strNotion componentsSeparatedByString:@","];
            if (strVal && strVal.count == 2) {
                [temp addObject:strNotion];
             }
        }
        self.notions = temp;

    }
    return self;
}

-(PatternModel*)getPatternModel{
    return [[AppManager sharedInstance] getPatternModelFromID:self.pattern];
}

-(NSArray*)getFabricModels{
    return [[AppManager sharedInstance] getFabricModelsFromIDS:self.fabrics];
}

-(NSArray*)getNotionModels{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (NSString* strVal in self.notions) {
         NSArray* vals = [strVal componentsSeparatedByString:@","];
         NSInteger nId = [vals[0] integerValue];
         NSInteger nHowmany = [vals[1] integerValue];
         NotionModel* model = [[[AppManager sharedInstance] getNotionModelFromID:nId] createClone];
         model.howmany = nHowmany;
         [result addObject:model];
    }
    return result;
}
@end
