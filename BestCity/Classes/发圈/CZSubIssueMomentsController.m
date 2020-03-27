//
//  CZSubIssueMomentsController.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSubIssueMomentsController.h"

@interface CZSubIssueMomentsController ()

@end

@implementation CZSubIssueMomentsController
- (void)loadView
{
    [super loadView];
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;

    self.progressHeight = 2.5;
    self.progressColor = UIColorFromRGB(0xFFD224);
    self.progressViewBottomSpace = 5;

    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = UIColorFromRGB(0xFFFFFF);
    self.titleColorSelected = UIColorFromRGB(0xFFD224);
    self.titleSizeNormal = 18;
    self.titleSizeSelected = 18;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            UIViewController *vc = [[UIViewController alloc] init];
            
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
        case 1:
        {
            UIViewController *vc = [[UIViewController alloc] init];

            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
        default:
        {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"每日精选", @"宣传素材"];
    return titles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
//    menuView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    return CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, (IsiPhoneX ? 44 + 44 : 20 + 44), SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 + 44 : 20 + 44) + (IsiPhoneX ? 83 : 49)));
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"测评--%@", info[@"title"]];
    NSLog(@"----%@", text);
    if ([info[@"title"] isEqualToString:@"关注"] || [info[@"title"] isEqualToString:@"推荐"]) {
    }
    if (![info[@"title"] isEqualToString:@"精选"]) {

    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"starScrollAd" object:nil];
    }
}


@end
