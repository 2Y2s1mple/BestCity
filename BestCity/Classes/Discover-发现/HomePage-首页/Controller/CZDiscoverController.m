//
//  CZDiscoverController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDiscoverController.h"
#import "CZDChoicenessController.h"
#import "MJExtension.h"
#import "GXNetTool.h"
#import "CZDiscoverTitleModel.h"


@interface CZDiscoverController ()
@property (nonatomic, strong) NSArray *mainTitles;
@end

@implementation CZDiscoverController

- (void)obtainTtitles
{
    //获取数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/findGoods/selectCategory"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            //标题的数据
            self.mainTitles = [CZDiscoverTitleModel objectArrayWithKeyValuesArray:result[@"list"]];
            
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
    self.view.backgroundColor = CZGlobalWhiteBg;
    
    // 获取标题
    [self obtainTtitles];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    CZDiscoverTitleModel *model = self.mainTitles[index];
    switch (index) {
        case 0: return [[CZDChoicenessController alloc] init];
        case 1:
        {
            CZDChoicenessController *vc = [[CZDChoicenessController alloc] init];
            vc.titleID = model.categoryId;
            return vc;
        }
        case 2:
        {
            CZDChoicenessController *vc = [[CZDChoicenessController alloc] init];
            vc.titleID = model.categoryId;
            return vc;
        }
        case 3:
        {
            CZDChoicenessController *vc = [[CZDChoicenessController alloc] init];
            vc.titleID = model.categoryId;
            return vc;
        }
        case 4:
        {
            CZDChoicenessController *vc = [[CZDChoicenessController alloc] init];
            vc.titleID = model.categoryId;
            return vc;
        }
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    CZDiscoverTitleModel *model = self.mainTitles[index];
    return model.categoryName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, HOTTitleH);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, (IsiPhoneX ? 44 : 20) + HOTTitleH, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + HOTTitleH) - (IsiPhoneX ? 83 : 49));
}



@end
