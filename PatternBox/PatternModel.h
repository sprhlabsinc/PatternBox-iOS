//
//  PatternModel.h
//  PatternBox
//
//  Created by mac on 4/4/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatternModel : NSObject

@property (nonatomic) NSInteger   fid;

@property (strong, nonatomic) NSString *  name;
@property (strong, nonatomic) NSString *  type;
@property (strong, nonatomic) NSString *  notes;
@property (strong, nonatomic) NSString *  frontImage;
@property (strong, nonatomic) NSString *  backImage;
@property (strong, nonatomic) NSArray *  categories;
@property (strong, nonatomic) NSArray *  pdfUrls;
@property (nonatomic) NSInteger   isBookMark;
@property (nonatomic) NSInteger   isPDF;

-(NSArray*)getCategoryNameList;
-(id)initWithData:(NSDictionary*)data;
-(void)updateWithData:(NSDictionary*)data;
-(NSDictionary*)getDictionaryData;
-(PatternModel*)createClone;
@end
