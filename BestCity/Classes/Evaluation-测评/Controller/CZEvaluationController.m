//
//  CZEvaluationController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationController.h"
#import "CZEvaluationChoicenessController.h"
#import "GXNetTool.h"
#import "CZEvaluationTitleModel.h"
#import "MJExtension.h"

@interface CZEvaluationController ()

@property (nonatomic, strong) NSArray *mainTitles;
@end

@implementation CZEvaluationController

- (void)obtainTtitles
{
    //获取数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/evalWay/selectCategory"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            //标题的数据
            self.mainTitles = [CZEvaluationTitleModel objectArrayWithKeyValuesArray:result[@"list"]];
            
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

- (void)reloadData
{
    [super reloadData];
    !self.evalutionDelegate ? : [self.evalutionDelegate reloadChildControlerData];
}



/**
 主标题数组
 */
//- (NSArray *)mainTitles
//{
//    if (_mainTitles == nil) {
//        _mainTitles = @[@"精选榜", @"个护健康", @"厨卫电器", @"生活家电", @"家用大电"];
//    }
//    return _mainTitles;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 获取数据
    [self obtainTtitles];
    
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            CZEvaluationChoicenessController *vc = [[CZEvaluationChoicenessController alloc] init];
            self.evalutionDelegate = vc;
            vc.titleModel = self.mainTitles[index];
            return vc;
        }
        case 1: return [[CZEvaluationChoicenessController alloc] init];
        case 2: return [[CZEvaluationChoicenessController alloc] init];
        case 3: return [[CZEvaluationChoicenessController alloc] init];
        case 4: return [[CZEvaluationChoicenessController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    CZEvaluationTitleModel *model = self.mainTitles[index];
    return model.categoryName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 20, SCR_WIDTH, HOTTitleH);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 72, SCR_WIDTH, SCR_HEIGHT - 72 - 49);
}

@end
