//
//  NotionCategoryInfo.h
//  PatternBox
//
//  Created by mac on 4/5/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotionCategoryInfo : NSObject

@property (strong, nonatomic) NSString*  fid;
@property (strong, nonatomic) NSString*  name;
@property (nonatomic) Boolean            isDefault;

-(id)initWithName:(NSString*)name id:(NSString *)fid isDefault:(Boolean)isDefault;

@end
