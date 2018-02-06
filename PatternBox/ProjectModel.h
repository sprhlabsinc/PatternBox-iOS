//
//  ProjectModel.h
//  PatternBox
//
//  Created by mac on 4/10/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatternModel.h"
#import "NotionModel.h"
#import "FabricModel.h"

@interface ProjectModel : NSObject

@property (nonatomic) NSInteger   fid;
@property (strong, nonatomic) NSString *  name;
@property (strong, nonatomic) NSString *  client; // Project For
@property (strong, nonatomic) NSString *  notes;
@property (strong, nonatomic) NSString *  measurements;
@property (strong, nonatomic) NSString *  image;
@property (nonatomic)         NSInteger   pattern;
@property (strong, nonatomic) NSArray *   fabrics;    // Fabric ID Array
@property (nonatomic)         NSArray *   notions;    // Notion (ID, HowMany) Array

-(id)initWithData:(NSDictionary*)data;


-(PatternModel*)getPatternModel;
-(NSArray*)getFabricModels;
-(NSArray*)getNotionModels;

@end
