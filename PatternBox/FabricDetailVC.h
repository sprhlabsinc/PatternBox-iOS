//
//  FabricDetailVC.h
//  PatternBox
//
//  Created by mac on 4/14/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FabricModel.h"
#import "CustomIOS7AlertView.h"
#import "MGImageViewer.h"

@interface FabricDetailVC : UIViewController<UITableViewDelegate, UITableViewDataSource,CustomIOS7AlertViewDelegate,MGImageViewerDelegate>{
    FabricInfo* _fabricInfo;
    MGImageViewer *_imgViewer;
}
@property (strong, nonatomic) FabricModel *m_fabricModel;

@property (weak, nonatomic) IBOutlet UIImageView *m_fabricView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_btnBookMark;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBookMark;
@property (weak, nonatomic) IBOutlet UITableView *fabricInfoTableView;

@property (weak, nonatomic) IBOutlet UILabel *m_lblCategory;


- (IBAction)actionBookMark:(id)sender;
@end
