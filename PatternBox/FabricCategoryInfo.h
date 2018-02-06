//
//  FabricCategoryInfo.h
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FabricCategoryInfo : NSObject

@property (strong, nonatomic) NSString*  name;
@property (strong, nonatomic) NSString*  fid;
@property (nonatomic) Boolean            isDefault;


-(id)initWithName:(NSString*)name id:(NSString *)fid isDefault:(Boolean)isDefault;
@end
