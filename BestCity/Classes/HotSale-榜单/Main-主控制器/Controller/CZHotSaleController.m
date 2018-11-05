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
#import "CZProgressHUD.h"


@interface CZHotSaleController ()
/** 主标题数组 */
@property (nonatomic, strong) NSArray *mainTitles;
/** 首页的数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置搜索栏
    [self setupTopView];
    
    // 获取标题
    [self obtainTtitles];
}

- (void)setupTopView
{
    CZHotSearchView *search = [[CZHotSearchView alloc] initWithFrame:CGRectMake(10, 30, SCR_WIDTH - 20, FSS(34)) msgAction:^{
        NSLog(@"消息");
    }];
    search.textFieldActive = NO;
    
    [self.view addSubview:search];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchController)];
    [search addGestureRecognizer:tap];
}

- (void)pushSearchController
{
    CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    return self.mainTitles.count;
    return 5;
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
    return CGRectMake(0, 30 + FSS(34), SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 30 + FSS(34) + 50, SCR_WIDTH, SCR_HEIGHT - (30 + FSS(34) + 50 + 49));
}






@end
