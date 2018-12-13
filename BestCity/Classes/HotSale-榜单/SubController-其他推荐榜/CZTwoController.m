//
//  CZTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTwoController.h"
#import "CZHotSaleCell.h"
#import "CZHotTitleModel.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CZSubTitleButton.h"
#import "TSLWebViewController.h"
#import "UIImageView+WebCache.h"

@interface CZTwoController ()
/** 记录高度 */
@property (nonatomic, assign) CGFloat recordHeight;
/** 记录点击的按钮 */
@property (nonatomic, strong) UIButton *recordBtn;
/** 记录Id避免重复点击刷新 */
@property (nonatomic, strong) NSString *recordID;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZTwoController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 180;
    }
    return _noDataView;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    
    // 设置头部标题
    [self setupHeaderView];
    
    // 设置tableView
    self.tableView.frame = CGRectMake(0, _recordHeight, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94) - _recordHeight);
    self.tableView.tableHeaderView = [self headerView];
    
    // 加载刷新控件
    [self setupRefresh];
    
    //获取标题1的数据
    [self getDataSourceWithId:self.subTitles[0].categoryid];
}

- (void)getDataSourceWithId:(NSString *)SourceId
{
    [CZRecommendListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"goodsScopeList" : @"CZHotScoreModel"
                 };
    }];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"mark"] = @"0";
        param[@"category2Id"] = SourceId;
        param[@"client"] = @(2);
        
        [CZProgressHUD showProgressHUDWithText:nil];
        //获取数据
        [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodRank"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                if ([result[@"list"] count] > 0) {
                    // 删除noData图片
                    [self.noDataView removeFromSuperview];
                    self.tableView.tableFooterView = [self creatFooterView];;
                } else {
                    // 加载NnoData图片
                    [self.tableView addSubview:self.noDataView];
                    self.tableView.tableFooterView = nil;
                }
                self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"list"]];
                [self.tableView reloadData];
            }
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
        }];
        self.recordID = SourceId;
}



- (void)setupRefresh
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
    //    NSArray *titles = @[@"剃须刀", @"计步器", @"吹风机", @"足浴盆", @"体重计", @"剃/脱毛器", @"美容仪", @"按摩椅", @"理发器", @"电动牙刷"];
    CGFloat space = 8;
    CGFloat h = 40;
    for (int i = 0; i < self.subTitles.count; i++) {
        // 创建按钮
        CZSubTitleButton *btn = [CZSubTitleButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = RANDOMCOLOR;
        // 设置模型
        CZHotSubTilteModel *model = self.subTitles[i];
        model.indexBtn = i;
        btn.model = model;
        [btn sizeToFit];
        
        // 添加监听
        [btn addTarget:self action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            _recordBtn = btn;
            btn.x = space;
            btn.y = 0;
            btn.height = h;
        } else {
            CGFloat leftSpace = CZGetX(backView.subviews[i - 1]) + space;
            if (self.view.width - leftSpace > btn.width) {
                btn.x = leftSpace;
                btn.y = backView.subviews[i - 1].y;
            } else {
                btn.x = space;
                btn.y = CZGetY(backView.subviews[i - 1]);
            }
            btn.height = h;
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
    // 获取点击数据
    if (self.recordID != sender.model.categoryid) {
        [self getDataSourceWithId:sender.model.categoryid];
    }
    _recordBtn = sender;
}

#pragma mark - 头视图
- (UIView *)headerView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 180)];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, backView.height - 10);
    [backView addSubview:imageView];
    
    return backView;
}


@end
