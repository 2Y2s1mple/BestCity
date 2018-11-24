//
//  CZTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTwoController.h"
#import "CZHotSaleCell.h"
#import "CZOneDetailController.h"
#import "CZHotTitleModel.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CZSubTitleButton.h"
#import "TSLWebViewController.h"

@interface CZTwoController ()<UITableViewDelegate, UITableViewDataSource>
/** 记录高度 */
@property (nonatomic, assign) CGFloat recordHeight;
/** 记录点击的按钮 */
@property (nonatomic, strong) UIButton *recordBtn;
/** 当前数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;

/** 记录Id避免重复点击刷新 */
@property (nonatomic, strong) NSString *recordID;
@end

@implementation CZTwoController

- (void)getDataSourceWithId:(NSString *)SourceId
{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"mark"] = @"0";
        param[@"goodsId"] = SourceId;
        
        [CZProgressHUD showProgressHUDWithText:nil];
        //获取数据
        [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodRank"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"list"]];
                [self.tableView reloadData];
            }
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
        }];
        self.recordID = SourceId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    [CZRecommendListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"goodsScopeList" : @"CZHotScoreModel"
                 };
    }];
    
    // 设置头部标题
    [self setupHeaderView];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _recordHeight, SCR_WIDTH, SCR_HEIGHT - HOTContentY - 49 - _recordHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 加载刷新控件
    [self setupRefreshTableView];
    
    //获取标题1的数据
    [self getDataSourceWithId:self.subTitles[0].categoryid];
}

- (void)setupRefreshTableView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

- (void)loadNewData
{
    [self getDataSourceWithId:self.recordID];
}


- (void)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 180)];
    backView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:backView];

    // 最大列数
    NSInteger maxCols = 5;
    CGFloat w = SCR_WIDTH / maxCols;
    CGFloat h = 40;
    //    NSArray *titles = @[@"剃须刀", @"计步器", @"吹风机", @"足浴盆", @"体重计", @"剃/脱毛器", @"美容仪", @"按摩椅", @"理发器", @"电动牙刷"];
    
    for (int i = 0; i < self.subTitles.count; i++) {
        // 创建按钮
        CZSubTitleButton *btn = [CZSubTitleButton buttonWithType:UIButtonTypeCustom];
        
        // 设置模型
        CZHotSubTilteModel *model = self.subTitles[i];
        model.indexBtn = i;
        btn.model = model;
        
        //设置frame
        NSInteger col = i % maxCols;
        NSInteger row = i / maxCols;
        btn.x = w * col;
        btn.y = h * row;
        btn.width = w;
        btn.height = h;
        
        // 添加监听
        [btn addTarget:self action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            _recordBtn = btn;
        }
        [backView addSubview:btn];
        _recordHeight = CZGetY(btn);
    }
    backView.frame = CGRectMake(0, 0, SCR_WIDTH, _recordHeight);
}

- (void)didClickedBtn:(CZSubTitleButton *)sender
{
    _recordBtn.selected = NO;
    sender.selected = YES;
    NSLog(@"点击了%@个按钮, ID是: %@", sender.model.categoryname, sender.model.categoryid);
    // 获取点击数据
    if (self.recordID != sender.model.categoryid) {
        [self getDataSourceWithId:sender.model.categoryid];
    }
    _recordBtn = sender;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource[indexPath.row] cellHeight];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"hotSaleCell";
    CZHotSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZHotSaleCell class]) owner:nil options:nil] lastObject];
    }
    CZRecommendListModel *model = self.dataSource[indexPath.row];
    model.indexNumber = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
//    CZOneDetailController *vc = [[CZOneDetailController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    CZRecommendListModel *model = self.dataSource[indexPath.row];
    
    [GXNetTool GetNetWithUrl:@"http://192.168.5.165:8080/qualityshop-admin/goodsEvalway/selectJ/1" body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        NSLog(@"%@", result[@"goodsRanklist"][@"content"]);
        TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://192.168.5.186:8080/ea_cs_tmall_app/showhistory"]];
        vc.stringHtml = result[@"goodsRanklist"][@"content"];
        [self.navigationController pushViewController:vc animated:YES];

    } failure:^(NSError *error) {
        
    }];
    
    
}

@end
