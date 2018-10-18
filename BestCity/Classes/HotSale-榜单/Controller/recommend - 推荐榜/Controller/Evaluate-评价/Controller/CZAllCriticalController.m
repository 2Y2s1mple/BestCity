//
//  CZAllCriticalController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAllCriticalController.h"
#import "CZNavigationView.h"
#import "CZUserEvaluationView.h"
#import "CZAllCriticalCell.h"
#import "CZAllCriticalModel.h"

@interface CZAllCriticalController ()<UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) NSArray *criticals;
@end

@implementation CZAllCriticalController

- (NSArray *)criticals
{
    if (_criticals == nil) {
        NSArray *dateArr = @[@{
                                 @"icon" : @"head1",
                                 @"name" : @"李晓写",
                                 @"contentText" : @"与水直接接触的内胆、不锈钢材质安全放心，不易生锈、结垢、无异味、易清洁。",
                                 @"likeNumber" : @"234",
                                 @"time" : @"2018.09.21",
                                 },
                             @{
                                 @"icon" : @"head3",
                                 @"name" : @"张相同",
                                 @"contentText" : @"与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁。",
                                 @"likeNumber" : @"229",
                                 @"time" : @"2018.11.21",
                                 },
                             @{
                                 @"icon" : @"head3",
                                 @"name" : @"张相同",
                                 @"contentText" : @"与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁。的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁。的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁与水直接接触的内胆、不锈钢材质安钢材质安钢材质安全放心，不易生锈、结垢、无异味、易清洁。",
                                 @"likeNumber" : @"229",
                                 @"time" : @"2018.11.21",
                                 }];
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSDictionary *dic in dateArr) {
            CZAllCriticalModel *model = [CZAllCriticalModel allCriticalModelWithDic:dic];
            [mutArr addObject:model];
        }
        _criticals = mutArr;
        
    }
    return _criticals;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    
    //导航条
    CZNavigationView *nav = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"所有评论(58)" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:nav];
   
    //加载内容
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CZGetY(nav), SCR_WIDTH, SCR_HEIGHT - CZGetY(nav) - 60)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.backgroundColor = RANDOMCOLOR;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    //加载底部视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - 60, SCR_WIDTH, 60)];
    bottomView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:bottomView];
    
    UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, bottomView.width - 40, 40)];
    textFiled.font = [UIFont systemFontOfSize:15];
    textFiled.layer.borderWidth = 0.5;
    textFiled.layer.borderColor = CZGlobalGray.CGColor;
    textFiled.layer.cornerRadius = 5;
    textFiled.placeholder = @"  点击输入评论";
    [bottomView addSubview:textFiled];
    
    
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.criticals.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CZAllCriticalCell";
    CZAllCriticalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CZAllCriticalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = (CZAllCriticalModel *)self.criticals[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZAllCriticalModel *model = self.criticals[indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}












@end
