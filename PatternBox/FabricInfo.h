//
//  FabricInfo.h
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FabricInfo : NSObject
@property (strong, nonatomic) NSString *  name;
@property (strong, nonatomic) NSString *  type;
@property (strong, nonatomic) NSString *  color;
@property (strong, nonatomic) NSString *  width;
@property (strong, nonatomic) NSString *  length;
@property (strong, nonatomic) NSString *  weight;
@property (strong, nonatomic) NSString *  strech;
@property (strong, nonatomic) NSString *  uses;
@property (strong, nonatomic) NSString *  careInstructions;
@property (strong, nonatomic) NSString *  notes;

@property (nonatomic) NSArray *  keyList;


-(NSString*)getValueWithKey:(NSString*)key;
-(NSString*)getValueWithIndex:(NSInteger)index;
-(NSDictionary*)getDictionaryData;
-(void)setValueWithKey:(NSString*)key value:(NSString*)value;
-(void)setValueWithIndex:(NSInteger)index value:(NSString*)value;

-(id)initWithData:(NSDictionary*)data;

@end
