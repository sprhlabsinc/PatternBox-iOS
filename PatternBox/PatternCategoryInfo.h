//
//  PatternCategoryInfo.h
//  PatternBox
//
//  Created by mac on 4/4/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatternCategoryInfo : NSObject

@property (strong, nonatomic) NSString*  fid;
@property (strong, nonatomic) NSString*  name;
@property (strong, nonatomic) NSString*  icon;
@property (nonatomic) Boolean           isDefault;

-(id)initWithName:(NSString *)name id:(NSString *)fid isDefault:(Boolean)isDefault;
-(id)initWithName:(NSString *)name id:(NSString *)fid icon:(NSString*)icon;
@end
