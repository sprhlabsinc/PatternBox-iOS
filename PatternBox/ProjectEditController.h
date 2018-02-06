//
//  ProjectEditController.h
//  PatternBox
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"
#import "PatternModel.h"
#import "FabricModel.h"
#import "NotionModel.h"

@interface ProjectEditController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *m_imgProject;
@property (weak, nonatomic) IBOutlet UITextField *m_txtProjectName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtProjectMeasurment;
@property (weak, nonatomic) IBOutlet UITextField *m_txtProjectFor;
@property (weak, nonatomic) IBOutlet UITextView *m_txtProjectNote;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPattern;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPatternBookmark;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternType;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPatternCategories;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPattern;
@property (weak, nonatomic) IBOutlet UICollectionView *m_collectionView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFabric;
@property (weak, nonatomic) IBOutlet UITextView *m_txtNotion;
@property (weak, nonatomic) IBOutlet UIButton *m_btnNotion;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnSave;

@property (strong, nonatomic) ProjectModel* m_project;
@property (strong, nonatomic) PatternModel* m_pattern;
@property (strong, nonatomic) NSArray* m_fabrics;
@property (strong, nonatomic) NSArray* m_notions;

- (IBAction)actionSelectPattern:(id)sender;
- (IBAction)actionSelectFabric:(id)sender;
- (IBAction)actionSelectNotion:(id)sender;
- (IBAction)actionSaveProject:(id)sender;

-(void)updateFabricModels:(NSArray*)models;
-(void)updateNotionModels:(NSArray*)models isReplace:(Boolean)isReplace;
-(void)updatePatternModel:(PatternModel*)model;

@end
