//
//  SelectModel.h
//  PatternBox
//
//  Created by mac on 4/7/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectModel : NSObject
@property (strong, nonatomic)   NSString*     key;
@property (nonatomic)           BOOL          isSelected;

-(id)initWithName:(NSString *)key;
-(id)initWithName:(NSString *)key id:(BOOL)isSelected;

@end
