//
//  FabricModel.h
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FabricInfo.h"
#import "FabricCategoryInfo.h"

@interface FabricModel : NSObject
@property (strong, nonatomic) FabricInfo *  info;
@property (strong, nonatomic) NSString *  imageUrl;
@property (strong, nonatomic) NSArray *  categories;       // Fabric Category ID List
@property (nonatomic) NSInteger   isBookMark;
@property (nonatomic) NSInteger   fid;
@property (nonatomic)           BOOL          isSelected;

-(id)initWithData:(NSDictionary*)data;
-(NSArray*)getCategoryNameList;

-(NSDictionary*)getDictionaryData;
-(FabricModel*)createClone;

@end
