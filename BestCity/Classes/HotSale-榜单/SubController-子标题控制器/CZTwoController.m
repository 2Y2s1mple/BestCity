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
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 150;
    }
    return _noDataView;
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
        
        [CZProgressHUD showProgressHUDWithText:nil];
        //获取数据
        [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodRank"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                if ([result[@"list"] count] > 0) {
                    // 没有数据图片
                    [self.noDataView removeFromSuperview];
                } else {
                    // 没有数据图片
                    [self.tableView addSubview:self.noDataView];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    
    // 设置头部标题
    [self setupHeaderView];

    // 设置tableView
    self.tableView.frame = CGRectMake(0, _recordHeight, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94) - _recordHeight);
    
    // 加载刷新控件
    [self setupRefresh];
    
    //获取标题1的数据
    [self getDataSourceWithId:self.subTitles[0].categoryid];
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

    // 最大列数
    CGFloat recoredWidth = 0.0;
    CGFloat width = [self.subTitles[0].categoryname sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size: 13]}].width;
    NSLog(@"width -- %f", width);
    for (CZHotSubTilteModel *titleModel in self.subTitles) {
       CGFloat subWidth = [titleModel.categoryname sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size: 13]}].width;
        if (subWidth > width) {
            recoredWidth = subWidth;
            NSLog(@"recoredWidth - %f", recoredWidth);
        }
    }
    
    CGFloat cols = 0;
    if (recoredWidth > width) {
        cols = SCR_WIDTH / (recoredWidth + 20);
        NSLog(@"最大的是recoredWidth = %f ---- 一共有%f", recoredWidth, cols);
        
    } else {
        cols = SCR_WIDTH / (width + 20);
        NSLog(@"最大的是width = %f ---- 一共有%f", width, cols);
    }
    
    NSLog(@"%ld", (NSInteger)cols);
    
    
    NSInteger maxCols = (NSInteger)cols;
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


@end
