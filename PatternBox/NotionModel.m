//
//  NotionModel.m
//  PatternBox
//
//  Created by mac on 4/3/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "NotionModel.h"
#import "Define.h"
#import "AppManager.h"
#import "NotionCategoryInfo.h"

@implementation NotionModel
-(id)init{
    self = [super init];
    if (self) {
        self.fid = -1;
    }
    return self;
}
-(id)initWithData:(NSDictionary *)data{
    self = [self init];
    if (self) {
        self.fid = [[data objectForKey:KNotionId] integerValue];
        self.categoryId = [data objectForKey:KNotionCategoryId];
        self.type = [data objectForKey:KNotionType];
        self.color = [data objectForKey:KNotionColor];
        self.size = [data objectForKey:KNotionSize];
     }
    return self;
}
-(NSDictionary*)getDictionaryData{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.categoryId forKey:KNotionCategoryId];
    [dic setObject:self.type forKey:KNotionType];
    [dic setObject:self.color forKey:KNotionColor];
    [dic setObject:self.size forKey:KNotionSize];
    return dic;
}

-(NotionModel*)createClone{
    NSDictionary* dic = [self getDictionaryData];
    NotionModel* model = [[NotionModel alloc] initWithData:dic];
    model.fid = self.fid;
    return model;
}

-(NSString*)getDiscription{
    return [NSString stringWithFormat:@"%@, %@, %@, %ld", self.type, self.color, self.size, self.howmany];
}



-(NSAttributedString*)getHTMLDiscription{
   
    NSString* description = @"";
//    description = [self htmlStringWithTitle:description title:self.zipper.name content:[self.zipper getNotionDescription] isNew:false];
//    description = [self htmlStringWithTitle:description title:self.button.name content:[self.button getNotionDescription] isNew:false];
//    description = [self htmlStringWithTitle:description title:self.thread.name content:[self.thread getNotionDescription] isNew:false];
//    description = [self htmlStringWithTitle:description title:self.needle.name content:[self.needle getNotionDescription] isNew:false];
//
//    int i = 0;
//    for (NotionCategoryInfo* info in self.custom) {
//        Boolean isNew = i==0 ? true:false;
//        description = [self htmlStringWithTitle:description title:info.name content:[info getNotionDescription] isNew:isNew];
//        i++;
//    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attributedString;
}

-(NSString*)htmlStringWithTitle:(NSString*)text title:(NSString*)title content:(NSString*)content isNew:(Boolean)isNew{
    NSString* html = text;
    if (isNew) {
        html = [NSString stringWithFormat:@"%@<br>",html];
    }
    html = [NSString stringWithFormat:@"%@ <font size='3' color='red'>%@:</font> %@",html,[title uppercaseString] ,content];
    return html;
}
@end
