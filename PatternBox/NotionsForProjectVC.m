//
//  NotionsForProjectVC.m
//  PatternBox
//
//  Created by mac on 4/20/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "NotionsForProjectVC.h"
#import "AppManager.h"
#import "NotionHeaderView.h"
#import "NotionViewController.h"
@interface NotionsForProjectVC ()<UITableViewDelegate, UITableViewDataSource, NotionHeaderViewDelegate>{
    NSMutableArray* _notions;
    NSMutableArray* _categories;
    NSInteger _sectionCollapsed[100];
    NSInteger _selectedCategoryIndex;

}

@end

@implementation NotionsForProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initParamsWithData:self.m_notions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNotion"]) {
        NotionViewController *target = (NotionViewController *)segue.destinationViewController;
        target.m_category = _categories[_selectedCategoryIndex];
        target.m_notions = [self getNotions];
        target.m_projectEditVC = self;
    }
}

#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _notions.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sectionCollapsed[section] == 1) {
        return 0;
    }else{
        NSArray* subNotions = _notions[section];
        return subNotions.count;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NotionCategoryInfo* info = _categories[section];
    return [info.name uppercaseString];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray* subNotions = _notions[indexPath.section];
    UILabel *lblName = (UILabel *)[cell viewWithTag:1];
    UILabel *lblHowmany = (UILabel *)[cell viewWithTag:2];
    NotionModel* model = subNotions[indexPath.row];
    
    lblName.text = [NSString stringWithFormat:@"%@,%@,%@", model.type, model.color, model.size];
    lblHowmany.text= [NSString stringWithFormat:@"%ld", model.howmany];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = tableView.frame;
    
    NotionCategoryInfo* info = _categories[section];
    NotionHeaderView *sectionView = [[NotionHeaderView alloc] initWithNibName:@"NotionHeaderView"];
    [sectionView setFrame:frame];
    sectionView.delegate = self;
    sectionView.section = section;
    sectionView.isCollapsed = _sectionCollapsed[section];
    
    
    int sum = 0;
    
    for (NotionModel* model in _notions[section]) {
        sum += model.howmany;
    }
   
    sectionView.lblTitle.text =[NSString stringWithFormat:@"%@ (%d)", [info.name uppercaseString],sum];
    return sectionView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
#pragma mark UITableView Delegate




#pragma mark NotionHeaderView Delegate

-(void)notionHeaderView:(NotionHeaderView *)view didAddNotions:(NSInteger)section{
    _selectedCategoryIndex = section;
    [self performSegueWithIdentifier:@"segueNotion" sender:self];
    
}
-(void)notionHeaderView:(NotionHeaderView *)view didCollapseTable:(Boolean)isCollapse section:(NSInteger)section{
    _sectionCollapsed[section] = isCollapse;
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self.m_tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

-(void)initParamsWithData:(NSArray*)originalData{
    _categories = [AppManager sharedInstance].notionCategoryList;
    _notions = [[NSMutableArray alloc] init];
    
    NSArray* allNotions = originalData;
    for (int i =0 ; i < _categories.count; i++) {
        NotionCategoryInfo* info = _categories[i];
        NSMutableArray* oneNotions = [[NSMutableArray alloc] init];
        for (NotionModel* model in allNotions) {
            if ([model.categoryId isEqualToString:info.fid]) {
                NotionModel* newItem = [model createClone];
                newItem.howmany = model.howmany;
                [oneNotions addObject:newItem];
            }
        }
        [_notions addObject:oneNotions];
        _sectionCollapsed[i] = 0;
    }
}
-(NSArray*)getNotions{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSArray* sub in _notions) {
        for (NotionModel* model in sub) {
            [result addObject:model];
        }
    }
    return result;
}

-(void)updateNotionsWith:(NSArray *)notions{
    _notions[_selectedCategoryIndex] = notions;
    [self.m_tableView reloadData];
}

- (IBAction)actionAddToProject:(id)sender {
    NSArray* notions = [self getNotions];
    if (notions.count == 0) {
        [[AppManager sharedInstance] showMessageWithTitle:@"" message:@"Please select one notion at least." view:self];
        return;
    }else{
        [self.m_projectEditVC updateNotionModels:notions isReplace:YES];;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
