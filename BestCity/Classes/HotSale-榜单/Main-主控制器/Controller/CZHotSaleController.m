//
//  CZHotSaleController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotSaleController.h"
#import "CZHotSearchView.h"
#import "CZOneController.h"
#import "CZTwoController.h"
#import "CZHotsaleSearchController.h"
#import "MJExtension.h"
#import "CZHotTitleModel.h"
#import "GXNetTool.h"
// 我的界面系统消息
#import "CZSystemMessageController.h"


@interface CZHotSaleController ()
/** 主标题数组 */
@property (nonatomic, strong) NSArray *mainTitles;
/** 首页的数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *search;
@end

@implementation CZHotSaleController

- (void)obtainTtitles
{
    [CZHotTitleModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"subtilte" : @"CZHotSubTilteModel"
                 };
    }];
    //获取数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodsCategory"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        self.dataDic = result;
        if ([result[@"msg"] isEqualToString:@"success"]) {
            //标题的数据
            self.mainTitles = [CZHotTitleModel objectArrayWithKeyValuesArray:result[@"list"]];
            
            //刷新WMPage控件
            [self reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 获取未读消息
- (void)obtainReadMessage
{
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/message/selectCount"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        self.dataDic = result;
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 未读消息
            self.search.unreaderCount = [result[@"count"] integerValue] > 99 ? 99 : [result[@"count"] integerValue];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置搜索栏
    [self setupTopView];
    
    // 获取未读数
    [self obtainReadMessage];
    
    // 获取标题
    [self obtainTtitles];
    
    // 接受系统消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageRead) name:systemMessageDetailControllerMessageRead object:nil];
}

// 监听系统消息
- (void)messageRead
{
    // 获取未读数
    [self obtainReadMessage];
}


- (void)setupTopView
{
    self.search = [[CZHotSearchView alloc] initWithFrame:CGRectMake(10, 30, SCR_WIDTH - 20, 34) msgAction:^(NSString *title){
        NSLog(@"消息");
        CZSystemMessageController *vc = [[CZSystemMessageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.search.textFieldActive = NO;
    [self.view addSubview:self.search];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchController)];
    [self.search addGestureRecognizer:tap];
}

- (void)pushSearchController
{
    CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            CZOneController *vc = [[CZOneController alloc] init];
            return vc;
        }
        case 1: {
            CZTwoController *vc = [[CZTwoController alloc] init];
            vc.subTitles = [self.mainTitles[index] subtilte];
            return vc;
        }
        case 2: {
            CZTwoController *vc = [[CZTwoController alloc] init];
            vc.subTitles = [self.mainTitles[index] subtilte];
            return vc;
        }
        case 3: {
            CZTwoController *vc = [[CZTwoController alloc] init];
            vc.subTitles = [self.mainTitles[index] subtilte];
            return vc;
        }
        case 4: {
            CZTwoController *vc = [[CZTwoController alloc] init];
            vc.subTitles = [self.mainTitles[index] subtilte];
            return vc;
        }
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    CZHotTitleModel *model = self.mainTitles[index];
    return model.tilte.categoryname;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 30 + 34, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 30 + 34 + 50, SCR_WIDTH, SCR_HEIGHT - (30 + 34 + 50 + 49));
}






@end
