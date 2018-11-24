//
//  CZAllCriticalController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAllCriticalController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"


#import "CZAllCriticalfHeaderCell.h"
#import "CZEvaluateModel.h"

@interface CZAllCriticalController ()<UITableViewDelegate, UITableViewDataSource, CZAllCriticalfHeaderCellDelegate>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation CZAllCriticalController
- (NSMutableArray *)evaluateArr
{
    if (_evaluateArr == nil) {
        _evaluateArr = [NSMutableArray array];
    }
    return _evaluateArr;
}
// 获取评价数据
- (void)getDataSource
{
    [CZEvaluateModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"userCommentList" : @"CZCommentModel"
                 };
    }];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"articId"] = self.model.goodsId;
    param[@"articId"] = @"545363931984";
    param[@"page"] = @(0);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/comment"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.evaluateArr = [CZEvaluateModel objectArrayWithKeyValuesArray:result[@"list"]];
            // 创建用户评价
            [self.tableView reloadData];
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
        }
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
 
    // 获取数据
    [self getDataSource];
    
    //导航条
    NSString *title = [NSString stringWithFormat:@"所有评论(%@)", self.totalCommentCount];
    CZNavigationView *nav = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:title rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:nav];
   
    //加载内容
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CZGetY(nav), SCR_WIDTH, SCR_HEIGHT - CZGetY(nav) - 60) style:UITableViewStylePlain];
    /** 在tableView初始化时加入下面属性 */
    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = CZGlobalWhiteBg;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview: self.tableView];
    
    // 加载刷新控件
    [self setupRefresh];
    
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

- (void)setupRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata)];
}


- (void)loadMoredata
{
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"articId"] = self.model.goodsId;
    param[@"articId"] = @"545363931984";
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/comment"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *evaluationData = [CZEvaluateModel objectArrayWithKeyValuesArray:result[@"list"]];
            
            [self.evaluateArr addObjectsFromArray:evaluationData];
            
            // 创建用户评价
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
         [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.evaluateArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"commtentTopCell";
    CZAllCriticalfHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CZAllCriticalfHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.delegate = self;
    CZEvaluateModel *model = self.evaluateArr[indexPath.row];
    model.indexPath = indexPath;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZEvaluateModel *model = self.evaluateArr[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld条", indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - <CZAllCriticalfHeaderCellDelegate>
- (void)showMoreCommentCell:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld条", indexPath.row);
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    //3.传入数组，对当前cell进行刷新
//    [self.tableView reloadData];
    
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
 
}








@end
