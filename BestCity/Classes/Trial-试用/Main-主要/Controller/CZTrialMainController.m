//
//  CZTrialMainController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialMainController.h"
#import "CZNewProductTrialController.h"
#import "CZFreeChargeController.h"

@interface CZTrialMainController ()

@end

@implementation CZTrialMainController

- (void)loadView
{
    [super loadView];
    self.selectIndex = 0;
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewStyle = WMMenuViewStyleDefault;
    
    self.itemMargin = 10;
    
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = CZGlobalGray;
    self.titleColorSelected = [UIColor blackColor];
    self.titleSizeNormal = 18;
    self.titleSizeSelected = 18;
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 2;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            CZFreeChargeController *vc = [[CZFreeChargeController alloc] init];
            return vc;
        }
        default: {
            CZNewProductTrialController *vc = [[CZNewProductTrialController alloc] init];
            return vc;
        }
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return @[@"免单购", @"新品试用"][index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {

    return CGRectMake(0, (IsiPhoneX ? 44 : 20) + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + 50 + (IsiPhoneX ? 83 : 49)));
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"榜单--%@", info[@"title"]];
    NSDictionary *context = @{@"oneTab" : text};
    [MobClick event:@"ID1" attributes:context];
    NSLog(@"%@----%@", viewController, context);
}


@end
