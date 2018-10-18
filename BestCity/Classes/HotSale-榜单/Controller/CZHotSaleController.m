//
//  CZHotSaleController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotSaleController.h"
#import "CZTextField.h"
#import "UIButton+CZExtension.h"
#import "CZOneController.h"
#import "CZTwoController.h"
#import "CZHotsaleSearchController.h"
//暂时没用上
#import "CZThreeController.h"
#import "CZFourController.h"
#import "CZFiveController.h"

#import "GXNetTool.h"
#import "CZProgressHUD.h"


@interface CZHotSaleController ()
/** 主标题数组 */
@property (nonatomic, strong) NSArray *mainTitles;
/** 首页的数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation CZHotSaleController

- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"推荐榜", @"个护健康", @"厨卫电器", @"生活家电", @"家用大电"];
    }
    return _mainTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    //设置搜索栏
    [self setupTopViewWithFrame:CGRectMake(0, 30, SCR_WIDTH, FSS(34))];
    
//    //加载菊花
//    [CZProgressHUD showProgressHUDWithText:nil];
//    //获取数据
//    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"ea_cs_tmall_app/ranklist"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
//        self.dataDic = result;
//        //标题的数据
//        self.mainTitles = self.dataDic[@"goodstypes"];
    
//        //刷新WMPage控件
//        [self reloadData];
//
//        //隐藏菊花
//        [CZProgressHUD hideAfterDelay:0];
//    } failure:^(NSError *error) {
//        //隐藏菊花
//        [CZProgressHUD hideAfterDelay:0];
//    }];
    
}

- (void)setupTopViewWithFrame:(CGRect)frame
{
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchController)];
    [topView addGestureRecognizer:tap];
    
    
    UIButton *messageBtn = [UIButton buttonWithFrame:CGRectMake(topView.width - 21 - 14, 7, FSS(21), FSS(21)) backImage:@"nav-message" target:self action:@selector(messageAction)];
    [topView addSubview:messageBtn];
    messageBtn.center = CGPointMake(messageBtn.center.x, topView.height / 2);
    
    CZTextField *textField = [[CZTextField alloc] initWithFrame:CGRectMake(14, 0, CGRectGetMinX(messageBtn.frame) - 24, topView.height)];
    textField.enabled = NO;
    textField.backgroundColor = CZGlobalLightGray;
    textField.font = [UIFont systemFontOfSize:14];
    textField.layer.cornerRadius = 17;
    textField.placeholder = @"搜索商品榜";
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-search"]];
    textField.leftView = image;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [topView addSubview:textField];
}

- (void)pushSearchController
{
    CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageAction
{
    NSLog(@"%s", __func__);
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    return self.mainTitles.count;
    return 5;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            CZOneController *vc = [[CZOneController alloc] init];
            vc.dataDic = self.dataDic;
            return vc;
        }
        case 1: return [[CZTwoController alloc] init];
        case 2: return [[CZOneController alloc] init];
        case 3: return [[CZOneController alloc] init];
        case 4: return [[CZOneController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 30 + FSS(34), SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 30 + FSS(34) + 50, SCR_WIDTH, SCR_HEIGHT - (30 + FSS(34) + 50 + 49));
}






@end
