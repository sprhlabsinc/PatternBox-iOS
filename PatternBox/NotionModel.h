//
//  NotionModel.h
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotionCategoryInfo.h"

@interface NotionModel : NSObject

@property (nonatomic)         NSInteger   fid;
@property (strong, nonatomic) NSString*   categoryId;
@property (strong, nonatomic) NSString*  type;
@property (strong, nonatomic) NSString*  size;
@property (strong, nonatomic) NSString*  color;
@property (nonatomic)         NSInteger  howmany;


-(id)initWithData:(NSDictionary*)data;
-(NSDictionary*)getDictionaryData;
-(NotionModel*)createClone;
-(NSString*)getDiscription;
-(NSAttributedString*)getHTMLDiscription;

@end
