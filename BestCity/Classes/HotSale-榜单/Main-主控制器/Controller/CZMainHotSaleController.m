//
//  CZMainHotSaleController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainHotSaleController.h"

// 工具
#import "GXNetTool.h"

// 视图
#import "CZMainHotSaleHeaderView.h"
#import "CZMainHotSaleCategoryView.h"

// 模型
#import "CZHotTitleModel.h"

// 跳转
#import "CZHotsaleSearchController.h"

@interface CZMainHotSaleController ()
/** 滚动 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 记录btn */
@property (nonatomic, strong) UIButton *recordBtn;
@end

@implementation CZMainHotSaleController
#pragma mark - 创建视图
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49));
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)setupHeaderView
{
    CZMainHotSaleHeaderView *headerView = [[CZMainHotSaleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 209) action:^{
        ISPUSHLOGIN
        NSString *text = @"首页搜索框";
        NSDictionary *context = @{@"message" : text};
        [MobClick event:@"ID1" attributes:context];
        CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return headerView;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.scrollView];
    // 头部视图
    [self.scrollView addSubview:self.setupHeaderView];
    // 获取数据
    WS(weakself);
    [self getCategoryListData:^(NSArray<CZHotTitleModel *> *modelList) {
        // 创建菜单视图
        CZMainHotSaleCategoryView *categoryView = [[CZMainHotSaleCategoryView alloc] initWithFrame:CGRectMake(0, CZGetY([self.scrollView.subviews lastObject]), SCR_WIDTH, 0)];
        categoryView.dataSource = modelList;
        [self.scrollView addSubview:categoryView];

    }];
}

#pragma mark - 数据
- (void)getCategoryListData:(void (^)(NSArray <CZHotTitleModel *> *))categoryList
{
    [CZHotTitleModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"children" : @"CZHotSubTilteModel"
                 };
    }];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsCategoryList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *list = result[@"data"];
            //标题的数据
            categoryList([CZHotTitleModel objectArrayWithKeyValuesArray:list]);
        }
    } failure:^(NSError *error) {
    }];
}
@end
