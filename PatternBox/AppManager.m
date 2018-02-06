//
//  AppManager.m
//  PatternBox
//
//  Created by Mac on 10/02/2017.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "AppManager.h"
#import "FabricCategoryInfo.h"
#import "PatternCategoryInfo.h"
#import "NotionCategoryInfo.h"

@implementation AppManager

@synthesize userAuthenticationToken, userID,openInURL, fabricCategoryList,fabricList,notionList;

+ (AppManager *) sharedInstance {
    static AppManager * _AppManager;
    if (!_AppManager) {
        _AppManager = [[AppManager alloc] init];
        
    }
    return _AppManager;
}

-(id)init{
    self = [super init];
    if (self) {
        
        //self.purchaseStatus = PurchaseNonePay;
        
        self.isLoadInitData = false;
        
        // Initialize Fabric Categories
        
        _defaultPatternCategories = @[
                                      [[PatternCategoryInfo alloc] initWithName:@"Tops" id:@"d0" icon:@"c_top"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Pants" id:@"d1" icon:@"c_pant"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Dresses" id:@"d2" icon:@"c_dress"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Skirts" id:@"d3" icon:@"c_skirt"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Outerwear" id:@"d4" icon:@"c_outerwear"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Knits" id:@"d5" icon:@"c_knit"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Accessories" id:@"d6" icon:@"c_accessory"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Children" id:@"d7" icon:@"c_children"],
                                      [[PatternCategoryInfo alloc] initWithName:@"Home" id:@"d8" icon:@"c_home"] //,[[PatternCategoryInfo alloc] initWithName:@"Misc" id:@"d9" icon:@"icon_Misc.png"]
                                      ];
        self.patternCategoryList = [[NSMutableArray alloc] initWithArray:_defaultPatternCategories];
        
        // Initialize Fabric Categories
        
        _defaultFabricCategories = @[
                                     [[FabricCategoryInfo alloc] initWithName:@"WOVENS" id:@"d1" isDefault:true],
                                     [[FabricCategoryInfo alloc] initWithName:@"KNIT" id:@"d2" isDefault:true],
                                     [[FabricCategoryInfo alloc] initWithName:@"DECOR" id:@"d3" isDefault:true],
                                     ];
        self.fabricCategoryList = [[NSMutableArray alloc] initWithArray:_defaultFabricCategories];
        self.fabricList = [[NSMutableArray alloc] init];
        
        //Initialize Notion Categories
        
        _defaultNotionCategories = @[
                                     [[NotionCategoryInfo alloc] initWithName:@"Zippers" id:@"d1" isDefault:true],
                                     [[NotionCategoryInfo alloc] initWithName:@"Buttons"  id:@"d2" isDefault:true],
                                     [[NotionCategoryInfo alloc] initWithName:@"Threads"  id:@"d3" isDefault:true],
                                     [[NotionCategoryInfo alloc] initWithName:@"Needles"  id:@"d4" isDefault:true]
                                     ];
        
        self.notionCategoryList = [[NSMutableArray alloc] initWithArray:_defaultNotionCategories];
        self.notionList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)resetCategoryList:(NSArray*)data{
    self.patternCategoryList = [NSMutableArray arrayWithArray:_defaultPatternCategories];
    [self.patternCategoryList addObjectsFromArray:data];
}

-(PatternModel*)getPatternModelFromID:(NSInteger)modelID{
    for (PatternModel* item in self.patternList) {
        if (item.fid == modelID) {
            return item;
        }
    }
    return nil;
}
-(FabricModel*)getFabricModelFromID:(NSInteger)modelID{
    for (FabricModel* item in self.fabricList) {
        if (item.fid == modelID) {
            return item;
        }
    }
    return nil;
}
-(NSArray*)getFabricModelsFromIDS:(NSArray *)idList{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSString* fid in idList) {
        FabricModel * model = [self getFabricModelFromID:[fid integerValue]];
        if (model) {
            [result addObject:model];
        }
    }
    return result;
}
-(NotionModel*)getNotionModelFromID:(NSInteger)modelID{
    for (NotionModel* item in self.notionList) {
        if (item.fid == modelID) {
            return item;
        }
    }
    return nil;
}
-(UIImage*)getThumbnailFromPDF:(NSData *)data{
    
    CFDataRef myPDFData = (__bridge CFDataRef)data;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    CGPDFDocumentRef dRef = CGPDFDocumentCreateWithProvider(provider);
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(dRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self resizeImage:image];
}

-(UIImage*)resizeImage:(UIImage*)image{
    if (!image)return nil;
    // ReSize
    NSInteger maxHeight = 200;
    NSInteger maxWidth = 200;
    NSInteger realHeight = image.size.height;
    NSInteger realWidth = image.size.width;
    CGSize newSize;
    
    if(realHeight > realWidth){
        newSize = CGSizeMake(maxHeight*realWidth / realHeight, maxHeight);
    }else{
        newSize = CGSizeMake(maxWidth, realHeight* maxWidth / realWidth );
    }
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark Save User Profile On Local
-(NSString*)userAuthenticationToken{
    if (!userAuthenticationToken || [userAuthenticationToken isEqual:[NSNull null]]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        userAuthenticationToken = [userDefault objectForKey:KUserAuthenticationToken];
    }
    return  userAuthenticationToken;
}
-(void)setUserAuthenticationToken:(NSString *)authenticationToken{
    userAuthenticationToken = authenticationToken;
    [[NSUserDefaults standardUserDefaults] setObject:userAuthenticationToken forKey:KUserAuthenticationToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)userID{
    if (!userID || userID == 0) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        userID = [[userDefault objectForKey:KUserID] integerValue];
    }
    return  userID;
}
-(void)setUserID:(NSInteger)userid{
    userID = userid;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userID] forKey:KUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark Network Manager
-(void)postRequest:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary * response, NSError* error))block {
    
    NSString* url = [NSString stringWithFormat:@"%@%@",KPatternBoxServerURL,tag];
    NSString* apiKey = [self userAuthenticationToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.requestSerializer=serializer;
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"Authorization1"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* result = [[NSMutableDictionary alloc] init];
        NSError* error;
        result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if(error){
            NSString* strErr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Parse JSON Dictionarys:%@",strErr);
        }
        
        block(result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}

-(void)getRequest:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSArray * response, NSError *error))block{
    
    NSString* url = [NSString stringWithFormat:@"%@%@",KPatternBoxServerURL,tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.requestSerializer=serializer;
    NSString* apiKey = [self userAuthenticationToken];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"Authorization1"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray* result = [[NSMutableArray alloc] init];
        NSError* error;
        result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if(error){
            NSString* strErr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Parse JSON Array:%@",strErr);
        }
        block(result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}
-(void)getRequestWithDictonary:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary *, NSError *))block{
    NSString* url = [NSString stringWithFormat:@"%@%@",KPatternBoxServerURL,tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.requestSerializer=serializer;
    NSString* apiKey = [self userAuthenticationToken];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"Authorization1"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* result = [[NSMutableDictionary alloc] init];
        NSError* error;
        result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if(error){
            NSString* strErr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Parse JSON Dictionarys:%@",strErr);
        }
        
        block(result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}
-(void)putRequest:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary *, NSError *))block{
    NSString* url = [NSString stringWithFormat:@"%@%@",KPatternBoxServerURL,tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.requestSerializer=serializer;
    NSString* apiKey = [self userAuthenticationToken];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"Authorization1"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* result = [[NSMutableDictionary alloc] init];
        NSError* error;
        result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if(error){
            NSString* strErr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Parse JSON Dictionarys:%@",strErr);
        }
        
        block(result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}
-(void)deleteRequest:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary *, NSError *))block{
    NSString* url = [NSString stringWithFormat:@"%@%@",KPatternBoxServerURL,tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.requestSerializer=serializer;
    NSString* apiKey = [self userAuthenticationToken];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"Authorization1"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* result = [[NSMutableDictionary alloc] init];
        NSError* error;
        result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if(error){
            NSString* strErr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Parse JSON Dictionarys:%@",strErr);
        }
        
        block(result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}
-(void)uploadFile:(NSString*)tag data:(NSArray *)data parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary *, NSError *))block{
    NSString* url = [NSString stringWithFormat:@"%@%@",KPatternBoxServerURL,tag];
    NSString* apiKey = [self userAuthenticationToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.requestSerializer=serializer;
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"Authorization1"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        for (NSDictionary* item in data) {
            NSString* fileName = [item objectForKey:@"name"];
            NSData* fileData = [item objectForKey:@"data"];
            NSString* mimeType = [self getMimeType:fileName];
            [formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"uploadFile[%d]",i] fileName:fileName mimeType:mimeType];
            i++;
        }
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* result = [[NSMutableDictionary alloc] init];
        NSError* error;
        result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if(error){
            NSString* strErr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Parse JSON Dictionarys:%@",strErr);
        }
        
        block(result,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}

-(void)loadInitDataFromServer:(void (^)(NSDictionary * response, NSError *error))block{
    
    NSString* tag = @"init";
    
    NSString* url = [NSString stringWithFormat:@"%@%@",KPatternBoxServerURL,tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.requestSerializer=serializer;
    NSString* apiKey = [self userAuthenticationToken];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"Authorization1"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:@{@"purchase":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* result = [[NSMutableDictionary alloc] init];
        NSError* error;
        result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        if(error){
            NSString* strErr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Parse JSON Dictionarys:%@",strErr);
            block(nil,error);
        }else{
            self.isLoadInitData = true;
            
            
            NSMutableArray* temp = [[NSMutableArray alloc] init];
            
            // GET PATTERNS
            
            for (NSDictionary* item in [result objectForKey:@"patterns"]) {
                PatternModel* patternModel = [[PatternModel alloc] initWithData:item];
                [temp addObject:patternModel];
            }
            self.patternList = [temp mutableCopy];
            
            // GET PATTERN'S CATEGORIES
            temp = [[NSMutableArray alloc] init];
            for (NSDictionary* item in [result objectForKey:@"pattern_categories"]) {
                NSString* fid = [item objectForKey:@"id"];
                NSString* name = [item objectForKey:@"category"];
                FabricCategoryInfo* info = [[FabricCategoryInfo alloc] initWithName:name id:fid isDefault:false];
                [temp addObject:info];
            }
            [self resetCategoryList:temp];
            
            // GET FABRIC'S CATEGORIES
            temp = [[NSMutableArray alloc] init];
            for (NSDictionary* item in [result objectForKey:@"fabric_categories"]) {
                NSString* fid = [item objectForKey:@"id"];
                NSString* name = [item objectForKey:@"category"];
                FabricCategoryInfo* info = [[FabricCategoryInfo alloc] initWithName:name id:fid isDefault:false];
                [temp addObject:info];
            }
            [self resetFabricCategoryList:temp];
            
            // GET FABRICS
            temp = [[NSMutableArray alloc] init];
            for (NSDictionary* item in [result objectForKey:@"fabrics"]) {
                FabricModel* fabricModel = [[FabricModel alloc] initWithData:item];
                [temp addObject:fabricModel];
            }
            self.fabricList = [temp mutableCopy];
            // GET NOTION'S CATEGORIES
            temp = [[NSMutableArray alloc] init];
            for (NSDictionary* item in [result objectForKey:@"notion_categories"]) {
                NSString* fid = [item objectForKey:@"id"];
                NSString* name = [item objectForKey:@"category"];
                NotionCategoryInfo* info = [[NotionCategoryInfo alloc] initWithName:name id:fid isDefault:false];
                [temp addObject:info];
            }
            [self resetNotionCategoryList:temp];
            
            // GET NOTIONS
            temp = [[NSMutableArray alloc] init];
            for (NSDictionary* item in [result objectForKey:@"notions"]) {
                NotionModel* notionModel = [[NotionModel alloc] initWithData:item];
                [temp addObject:notionModel];
            }
            self.notionList = [temp mutableCopy];
            
            
            block(@{},nil);
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}
-(NSString*)getMimeType:(NSString*)filename{
    NSArray* strArray = [filename componentsSeparatedByString:@"."];
    NSString* extention = [strArray objectAtIndex:strArray.count -1];
    NSString* type = [extention lowercaseString];
    NSString* mime  = @"";
    
    if ([type isEqualToString:@"pdf"]) {
        mime = @"application/pdf";
    }else if ([type isEqualToString:@"png"]) {
        mime = @"image/png";
    }else if([type isEqualToString:@"jpe"] || [type isEqualToString:@"jpeg"] || [type isEqualToString:@"jpg"]){
        mime = @"image/jpeg";
    }else if([type isEqualToString:@"gif"]){
        mime = @"image/gif";
    }else if([type isEqualToString:@"bmp"]){
        mime = @"image/bmp";
    }else if([type isEqualToString:@"ico"]){
        mime = @"image/vnd.microsoft.icon";
    }else if([type isEqualToString:@"tiff"] || [type isEqualToString:@"tif"] ){
        mime = @"image/tiff";
    }else if([type isEqualToString:@"svg"] || [type isEqualToString:@"svgz"] ){
        mime = @"image/svg+xml";
    }else{
        mime = @"image/jpeg";
    }
    
    return mime;
}
#pragma mark Download URL
- (NSURL*)downloadUrlWithFileName:(NSString*)fileName{
    NSInteger userId = [self userID];
    NSString* url = [NSString stringWithFormat:@"%@../upload/",KPatternBoxServerURL];
    NSString* extention = [fileName pathExtension];
    if ([extention isEqualToString:@"pdf"]) {
        url = [NSString stringWithFormat:@"%@pdf/%ld/%@",url,(long)userId,fileName];
    }else{
        url = [NSString stringWithFormat:@"%@image/%ld/%@",url,(long)userId,fileName];
    }
    return [NSURL URLWithString:url];
}


#pragma mark FABRIC


-(void)resetFabricCategoryList:(NSArray *)data{
    self.fabricCategoryList = [NSMutableArray arrayWithArray:_defaultFabricCategories];
    [self.fabricCategoryList addObjectsFromArray:data];
}

#pragma mark NOTION

-(void)resetNotionCategoryList:(NSArray *)data{
    self.notionCategoryList = [NSMutableArray arrayWithArray:_defaultNotionCategories];
    [self.notionCategoryList addObjectsFromArray:data];
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message view:(UIViewController*)view{
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [view presentViewController:alert animated:YES completion:nil];
}

-(UIImage*) createInitial:(NSString*)name{
    if (!name || [name isEqualToString:@""]) return nil;
    NSString* caps = [[name substringToIndex:1] uppercaseString];
    UIFont* font = [UIFont fontWithName:@"ArialRoundedMTBold" size:40];
    CGSize size = [caps sizeWithAttributes:@{NSFontAttributeName: font}];
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    [caps drawInRect:CGRectMake(0,0,size.width,size.height) withAttributes:@{NSFontAttributeName: font}];
    UIImage *testImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

@end
