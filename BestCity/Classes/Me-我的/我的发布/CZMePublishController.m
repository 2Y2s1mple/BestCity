//
//  CZMePublishController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMePublishController.h"
#import "Masonry.h"

// 子控制器
#import "CZMePublishOneController.h"
#import "CZMePublishTwoController.h"
#import "CZMePublishThreeController.h"
#import "CZMePublishFourController.h"
// 问答
#import "CZMeAnswersPublishOneController.h" // 已发布
#import "CZMeAnswersPublishTwoController.h" // 审核中
#import "CZMeAnswersPublishThreeController.h" // 未通过

@interface CZMePublishController ()
/** <#注释#> */
@property (nonatomic, strong) UIButton *recordBtn;
/** <#注释#> */
@property (nonatomic, strong) UIView *navView;
/** <#注释#> */

@end

@implementation CZMePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 40)];
//    navView.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [self.view addSubview:navView];
    self.navView = navView;

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [navView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navView);
        make.left.equalTo(navView).offset(0);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];

    UIButton *title1 = [[UIButton alloc] init];
    [title1 setTitle:@"清单" forState:UIControlStateNormal];
    title1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [title1 setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
    [navView addSubview:title1];
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navView);
        make.centerX.equalTo(navView).offset(-40);
        make.width.equalTo(@(40));
        make.height.equalTo(@(26));
    }];
    [title1 addTarget:self action:@selector(didClickedTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    self.recordBtn = title1;

    UIButton *title2 = [[UIButton alloc] init];
    [title2 setTitle:@"问答" forState:UIControlStateNormal];
    title2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [title2 setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
    [navView addSubview:title2];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navView);
        make.centerX.equalTo(navView).offset(40);
        make.width.equalTo(@(40));
        make.height.equalTo(@(26));
    }];
    [title2 addTarget:self action:@selector(didClickedTitleAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickedTitleAction:(UIButton *)sender
{
    if (self.recordBtn == sender) {
        return;
    }

    if ([sender.titleLabel.text isEqualToString:@"清单"]) {
        self.isQingDan = YES;
        self.menuItemWidth = 50;
        NSString *margin = [NSString stringWithFormat:@"%lf", (SCR_WIDTH - self.menuItemWidth * 4 - 44) / 3.0];
        self.itemsMargins = @[@"22", margin, margin, margin, @"22"];
        [self reloadData];
    } else {
        self.isQingDan = NO;
        self.menuItemWidth = 50;
        NSString *margin = [NSString stringWithFormat:@"%lf", (SCR_WIDTH - self.menuItemWidth * 3 - 44) / 3.0];
        self.itemsMargins = @[@"22", margin, margin, @"22"];
        [self reloadData];
    }

    [sender setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
    [self.recordBtn setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
    self.recordBtn = sender;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.menuItemWidth = 50;
    NSString *margin = [NSString stringWithFormat:@"%lf", (SCR_WIDTH - self.menuItemWidth * 4 - 44) / 3.0];
    self.itemsMargins = @[@"22", margin, margin, margin, @"22"];
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = CZGlobalGray;
    self.titleColorSelected = [UIColor blackColor];
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
    self.isQingDan = YES;
    self.scrollEnable = NO;
    self.scrollView.scrollEnabled = NO;
    [super loadView];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    if (self.isQingDan) {
        return 4;
    } else {
        return 3;
    }
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{

    if (self.isQingDan) {
        switch (index) {
            case 0:
            {
                CZMePublishOneController *vc = [[CZMePublishOneController alloc] init];
                return vc;
            }
            case 1:
            {
                CZMePublishTwoController *vc = [[CZMePublishTwoController alloc] init];
                return vc;
            }
            case 2:
            {
                CZMePublishThreeController *vc = [[CZMePublishThreeController alloc] init];
                return vc;
            }
            case 3:
            {
                CZMePublishFourController *vc = [[CZMePublishFourController alloc] init];
                return vc;
            }
            default:
            {
                return [[UIViewController alloc] init];
            }
        }
    } else {
        switch (index) {
            case 0:
            {
                CZMeAnswersPublishOneController *vc = [[CZMeAnswersPublishOneController alloc] init];
                return vc;
            }
            case 1:
            {
                CZMeAnswersPublishTwoController *vc = [[CZMeAnswersPublishTwoController alloc] init];
                return vc;
            }
            case 2:
            {
                CZMeAnswersPublishThreeController *vc = [[CZMeAnswersPublishThreeController alloc] init];
                return vc;
            }
            default:
            {
                return [[UIViewController alloc] init];
            }
        }
    }

}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {

    if (self.isQingDan) {
        NSArray *titles = @[@"已发布", @"审核中", @"草稿箱", @"未通过"];
        return titles[index];
    } else {
        NSArray *titles = @[@"已发布", @"审核中", @"未通过"];
        return titles[index];
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, CZGetY(self.navView) + 18, SCR_WIDTH, 26);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, CZGetY(self.navView) + 18 + 26 + 18, SCR_WIDTH, SCR_HEIGHT - (CZGetY(self.navView) + 18 + 26 + 18 + (IsiPhoneX ? 34 : 0)));
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"测评--%@", info[@"title"]];
    NSDictionary *context = @{@"oneTab" : text};
//    [MobClick event:@"ID3" attributes:context];
//    NSLog(@"----%@", text);
}

@end
