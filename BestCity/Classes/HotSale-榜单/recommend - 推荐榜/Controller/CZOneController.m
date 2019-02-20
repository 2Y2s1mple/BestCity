//
//  CZOneController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZOneController.h"
#import "CZHotSaleCell.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZRecommendListModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CZSubButton.h"
#import "CZHotListController.h" // 热卖榜

@interface CZOneController ()<UIScrollViewDelegate>
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZOneController
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

#pragma mark - 获取数据
- (void)getDataSource
{
    [CZProgressHUD showProgressHUDWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"client"] = @(2);
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getTopGoodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)getHotListData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @"0";
    if (!self.titleModel.categoryId) {
        [self.tableView.mj_header endRefreshing];
        return;
    };
    param[@"category1Id"] = self.titleModel.categoryId;
    param[@"orderbyType"] = @(self.type);
    param[@"client"] = @(2);
    
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
                self.tableView.tableFooterView = [self creatFooterView];;
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
                self.tableView.tableFooterView = nil;
            }
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
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
}

- (void)getHotList2Data
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @"0";
    if (!self.titleModel.categoryId) {
        [self.tableView.mj_header endRefreshing];
        return;
    };
    param[@"category2Id"] = self.titleModel.categoryId;
    param[@"orderbyType"] = @(self.type);
    param[@"client"] = @(2);
    
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsList2"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
                self.tableView.tableFooterView = [self creatFooterView];;
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
                self.tableView.tableFooterView = nil;
            }
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
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
}
#pragma mark -控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //line
    CZTOPLINE;
    
    self.tableView.frame = CGRectMake(0, 10, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94) + 50);
    if (!self.isHotList) {    
        self.tableView.tableHeaderView = [self setupHeaderView];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"type"] = @(0);
        param[@"clientVersionCode"] = @"1.00";
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getAppVersion"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                NSNumber *appVersion1 = result[@"data"][@"open"];
                if (![appVersion1 isEqual:@(0)]) {} else {}
                //有新版本
                [CZSaveTool setObject:result[@"data"] forKey:requiredVersionCode];
                // 判断是否更新
                [self isNeedUpdate];
            }
        } failure:^(NSError *error) {}];
    }
    // 创建刷新控件
    [self setupRefresh];
}

- (void)isNeedUpdate
{
    NSDictionary *versionContrl = [CZSaveTool objectForKey:requiredVersionCode];
    if (![versionContrl[@"needUpdate"] isEqual:@(0)]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本%@",versionContrl[@"versionName"]] message:versionContrl[@"content"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction * update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到App Store
            NSString *urlStr = [NSString stringWithFormat:@"%@",versionContrl[@"downloadUrl"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }];
        [alert addAction:ok];
        [alert addAction:update];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData
{
    if (self.isHotList) {
        if (self.isList2) {
            [self getHotList2Data];
        } else {        
            [self getHotListData];
        }
    } else {    
        [self getDataSource];
    }
}

#pragma mark - 创建头视图
- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 263)];
//    backView.backgroundColor = CZREDCOLOR;
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, 157);
    [backView addSubview:imageView];
    
    CGFloat w = 44;
    CGFloat h = w + 25;
    CGFloat space = (SCR_WIDTH - 40 - 4 * w) / 3;
    NSArray *titles = @[@"热卖榜", @"轻奢榜", @"新品榜", @"性价比榜"];
    for (int i = 0; i < 4; i++) {
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = w;
        btn.height = h;
        btn.x = 20 + i * (w + space);
        btn.y = CZGetY(imageView) + 24;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"title-hot%d", i]] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(subTitleAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
    }
    return backView;
}

- (void)subTitleAction:(UIButton *)sender
{
    CZHotListController *hotVc = [[CZHotListController alloc] init];
    hotVc.selectIndex = 0;
    hotVc.menuViewStyle = WMMenuViewStyleLine;
    //        hotVc.progressWidth = 30;
    hotVc.itemMargin = 10;
    hotVc.progressHeight = 3;
    hotVc.automaticallyCalculatesItemWidths = YES;
    hotVc.titleFontName = @"PingFangSC-Medium";
    hotVc.titleColorNormal = CZGlobalGray;
    hotVc.titleColorSelected = CZRGBColor(5, 5, 5);
    hotVc.titleSizeNormal = 15.0f;
    hotVc.titleSizeSelected = 15;
    hotVc.progressColor = CZREDCOLOR;
    hotVc.subTitles = self.titlesArray;
    hotVc.type = sender.tag - 100 + 1;
    [hotVc reloadData];
    switch (sender.tag - 100) {
        case 0:
            hotVc.mainTitle = @"热卖榜";
            break;
        case 1:
            hotVc.mainTitle = @"轻奢榜";
            break;
        case 2:
            hotVc.mainTitle = @"新品榜";
            break;
        case 3:
            hotVc.mainTitle = @"性价比榜";
            break;
        default:
            break;
    }
    
    NSLog(@"点击 %@", hotVc.mainTitle);
    [self.navigationController pushViewController:hotVc animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *OneControllerScrollViewDidScroll = @"CZOneControllerScrollViewDidScroll";
    [[NSNotificationCenter defaultCenter] postNotificationName:OneControllerScrollViewDidScroll object:nil userInfo:@{@"scrollView" : scrollView}];
}


@end
