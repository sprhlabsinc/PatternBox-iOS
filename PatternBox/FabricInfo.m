//
//  FabricInfo.m
//  PatternBox
//
//  Created by mac on 3/29/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "FabricInfo.h"
#import "Define.h"

@implementation FabricInfo
-(id)init{
    self = [super init];
    if (self) {
        self.name = @"";
        self.type = @"";
        self.color = @"";
        self.width = @"0";
        self.length = @"0";
        self.weight = @"0";
        self.strech = @"";
        self.uses =@"";
        self.careInstructions = @"";
        self.notes = @"";
        
        self.keyList = @[
                          KFabricName,
                          KFabricType,
                          KFabricColor,
                          KFabricWidth,
                          KFabricLength,
                          KFabricWeight,
                          KFabricStretch,
                          KFabricUses,
                          KFabricCareInstructions,
                          KFabricNotes
                          ];
    }
    return self;
}

-(id)initWithData:(NSDictionary *)data{
    self = [self init];
    if (self) {
        self.name =             [data objectForKey:KFabricName];
        self.type =             [data objectForKey:KFabricType];
        self.color =            [data objectForKey:KFabricColor];
        self.width =            [data objectForKey:KFabricWidth];
        self.length =           [data objectForKey:KFabricLength];
        self.weight =           [data objectForKey:KFabricWeight];
        self.strech =           [data objectForKey:KFabricStretch];
        self.uses =             [data objectForKey:KFabricUses];
        self.careInstructions = [data objectForKey:KFabricCareInstructions];
        self.notes =            [data objectForKey:KFabricNotes];
    }
    return self;
}

-(NSString*)getValueWithKey:(NSString*)key{
    NSString* value = @"";
    if ([key isEqualToString:self.keyList[0]]) {
        value = self.name;
    }else if([key isEqualToString:self.keyList[1]]){
        value = self.type;
    }else if([key isEqualToString:self.keyList[2]]){
        value = self.color;
    }else if([key isEqualToString:self.keyList[3]]){
        value = self.width;
    }else if([key isEqualToString:self.keyList[4]]){
        value = self.length;
    }else if([key isEqualToString:self.keyList[5]]){
        value = self.weight;
    }else if([key isEqualToString:self.keyList[6]]){
        value = self.strech;
    }else if([key isEqualToString:self.keyList[7]]){
        value = self.uses;
    }else if([key isEqualToString:self.keyList[8]]){
        value = self.careInstructions;
    }else if([key isEqualToString:self.keyList[9]]){
        value = self.notes;
    }
    return value;
}
-(NSString*)getValueWithIndex:(NSInteger)index{
    if (index >= self.keyList.count) {
        return @"";
    }
    return [self getValueWithKey:self.keyList[index]];
}
-(NSDictionary*)getDictionaryData{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for (NSString* key in self.keyList) {
        [dic setObject:[self getValueWithKey:key] forKey:[key lowercaseString]];
    }
    return dic;
}
-(void)setValueWithKey:(NSString *)key value:(NSString *)value{
    if ([key isEqualToString:self.keyList[0]]) {
        self.name = value;
    }else if([key isEqualToString:self.keyList[1]]){
        self.type= value;
    }else if([key isEqualToString:self.keyList[2]]){
        self.color= value;
    }else if([key isEqualToString:self.keyList[3]]){
        self.width= value;
    }else if([key isEqualToString:self.keyList[4]]){
        self.length= value;
    }else if([key isEqualToString:self.keyList[5]]){
        self.weight= value;
    }else if([key isEqualToString:self.keyList[6]]){
        self.strech= value;
    }else if([key isEqualToString:self.keyList[7]]){
        self.uses= value;
    }else if([key isEqualToString:self.keyList[8]]){
        self.careInstructions= value;
    }else if([key isEqualToString:self.keyList[9]]){
        self.notes= value;
    }
}
-(void)setValueWithIndex:(NSInteger)index value:(NSString *)value{
    [self setValueWithKey:self.keyList[index] value:value];
}
@end
