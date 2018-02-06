//
//  Define.h
//  PatternBox
//
//  Created by youandme on 29/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#ifndef PatternBox_Define_h
#define PatternBox_Define_h

#import "AppDelegate.h"

//#define KPatternBoxServerURL         @"http://192.168.1.5/patternbox/api/v2/"
#define KPatternBoxServerURL           @"http://patternbox.us/api/v2/"

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define KColorBasic         [UIColor colorWithRed:202.0 / 255 green:33.0 / 255 blue:39.0 / 255 alpha:1]
#define KColorButtonBackGround        [UIColor colorWithRed:206.0 / 255 green:206.0 / 255 blue:206.0 / 255 alpha:1]
#define KColorBackground    [UIColor colorWithRed:240.0 / 255 green:240.0 / 255 blue:240.0 / 255 alpha:1]
#define KColorHighlight     [UIColor colorWithRed:43.0 / 255  green:250.0 / 255 blue:131.0 / 255 alpha:1]

#define KUserAuthenticationToken    @"userAuthenticationToken"
#define KUserID                     @"userID"

#define VM_PDFs         0
#define VM_Scans        1
#define VM_Bookmarks    2
#define VM_NewPDF       3
#define VM_NewScan      4


#define PurchaseNonePay   0            //  Free Use
#define PurchasePluse     1            //  Must Pay 6.99$
#define PurchasePremium   2            //  Must Pay 3.99$( 2.99$ paid)
#define PurchaseDone      3            //  Aleady paid

#define KTypeScan           @"scan"
#define KTypePDF            @"pdf"

#define KPatternId          @"id"
#define KPatternIsPDF       @"is_pdf"
#define KPatternName        @"name"
#define KPatternKey         @"pattern_key"
#define KPatternCategories  @"categories"   //categories array
#define KPatternInfo        @"info"
#define KPatternFronPic     @"front_image_name"
#define KPatternBackPic     @"back_image_name"
#define KPatternBookMark    @"is_bookmark"
#define KPatternUrls        @"pdf_urls"
#define KPatternUserId      @"user_id"


//define  category
#define KCategoryId         @"id"
#define KCategoryName       @"category"
#define KCategoryIcon       @"icon"
#define KCategoryCreatedAt  @"createdAt"


//define fabic
#define KFabricId           @"id"
#define KFabricImageName    @"image"
#define KFabricCategories   @"categories"
#define KFabricBookMark     @"is_bookmark"

#define KFabricName         @"name"
#define KFabricType         @"type"
#define KFabricColor        @"color"
#define KFabricWidth        @"width"
#define KFabricLength       @"length"
#define KFabricWeight       @"weight"
#define KFabricStretch      @"stretch"
#define KFabricUses         @"uses"
#define KFabricCareInstructions @"care_instructions"
#define KFabricNotes        @"notes"


// define fabric status

#define PATTERN_STATUS_NONE           0
#define PATTERN_STATUS_SELECT         1
#define PATTERN_STATUS_EDIT           2


//define notion
#define KNotionId           @"id"

#define KNotionCategoryId   @"category_id"
#define KNotionType         @"type"
#define KNotionSize         @"size"
#define KNotionColor        @"color"



//define project
#define KProjectId         @"id"

#define KProjectName        @"name"
#define KProjectClient      @"client"
#define KProjectMeasurement @"measurement"
#define KProjectImageName   @"image"
#define KProjectPattern     @"pattern"
#define KProjectNotes       @"notes"
#define KProjectFabrics     @"fabrics"
#define KProjectNotions     @"notions"

#define mode_PenEdit        0
#define mode_Erase          1
#define mode_Zoom           2

#endif
