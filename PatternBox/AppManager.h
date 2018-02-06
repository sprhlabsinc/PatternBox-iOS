//
//  AppManager.h
//  PatternBox
//
//  Created by Mac on 10/02/2017.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Define.h"
#import <CloudKit/CloudKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "FabricModel.h"
#import "NotionModel.h"
#import "PatternModel.h"

@interface AppManager : NSObject{
    NSArray* _defaultPatternCategories;
    NSArray* _defaultFabricCategories;
    NSArray* _defaultNotionCategories;
}

+ (AppManager *) sharedInstance;
@property (nonatomic, strong) NSString * userAuthenticationToken;
@property (nonatomic)         NSInteger  userID;
@property(nonatomic, strong) NSString*  openInURL;

@property(nonatomic, strong) NSMutableArray*  patternList;           // Customized Pattern Categories List
@property(nonatomic, strong) NSMutableArray*  patternCategoryList;           // Customized Pattern Categories List
@property(nonatomic, strong) NSMutableArray*  fabricCategoryList;           // Customized Fabric Categories List
@property(nonatomic, strong) NSMutableArray*  fabricList;                   // Fabric List
@property(nonatomic, strong) NSMutableArray*  notionList;                   // Notion List
@property(nonatomic, strong) NSMutableArray*  notionCategoryList;           // Customized Notion Categories List
//@property (nonatomic)         NSInteger  purchaseStatus;
@property(nonatomic) BOOL  isLoadInitData;



-(UIImage*) getThumbnailFromPDF:(NSData*) data;
-(UIImage*)resizeImage:(UIImage*)image;
-(void)showMessageWithTitle:(NSString *)title message:(NSString *)message view:(UIViewController*)view;
-(void)resetCategoryList:(NSArray*)data;
-(PatternModel*)getPatternModelFromID:(NSInteger)modelID;
-(FabricModel*)getFabricModelFromID:(NSInteger)modelID;
-(NSArray*)getFabricModelsFromIDS:(NSArray*)idList;
-(NotionModel*)getNotionModelFromID:(NSInteger)modelID;


//  FABRIC

-(void)resetFabricCategoryList:(NSArray*)data;

// NOTION
-(void)resetNotionCategoryList:(NSArray*)data;

// Call API
-(void)postRequest:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary * response, NSError* error))block;
-(void)getRequest:(NSString *)tag  parameter:(NSDictionary *)parameter withCallback:(void (^)(NSArray * response, NSError* error))block;
-(void)getRequestWithDictonary:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary * response, NSError* error))block;
-(void)putRequest:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary * response, NSError* error))block;
-(void)deleteRequest:(NSString *)tag parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary * response, NSError* error))block;
-(void)uploadFile:(NSString *)tag data:(NSArray *)data parameter:(NSDictionary *)parameter withCallback:(void (^)(NSDictionary * response, NSError* error))block;
-(void)loadInitDataFromServer:(void (^)(NSDictionary * response, NSError *error))block;

//return download url
- (NSURL*)downloadUrlWithFileName:(NSString*)fileName;
// Create Initial Image
-(UIImage*) createInitial:(NSString*)name;
@end
