//
//  CZHotsaleSearchDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotsaleSearchDetailController.h"
#import "CZTextField.h"
#import "Masonry.h"
#import "GXNetTool.h"
#import "CZSearchSubDetailOneController.h"
#import "CZSearchSubDetailTwoController.h"

@interface CZHotsaleSearchDetailController ()<UITextFieldDelegate>
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 当前的偏移量 */
@property (nonatomic, assign) CGFloat currentOffsetY;
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
@end

@implementation CZHotsaleSearchDetailController
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置搜索栏
    UIView *searchView = [self setupTopViewWithFrame:CGRectMake(0, 30, SCR_WIDTH, 34)];
    [self.view addSubview:searchView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneControllerScrollViewDidScroll:) name:@"CZSearchSubDetailOneController" object:nil];
}

#pragma mark - 创建搜索框以及方法
- (UIView *)setupTopViewWithFrame:(CGRect)frame
{
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:topView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    [topView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView).offset(2);
        make.left.equalTo(topView).offset(0);
        make.width.equalTo(@(40));
        make.height.equalTo(@(topView.height));
    }];

    CZTextField *textField = [[CZTextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderColor = UIColorFromRGB(0xACACAC).CGColor;
    textField.layer.borderWidth = 0.5;
    [topView addSubview:textField];
    textField.delegate = self;
    textField.text = self.textTitle;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(-20);
        make.left.equalTo(leftBtn.mas_right).offset(0);
        make.height.equalTo(@(topView.height));
    }];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-search"]];
    textField.leftView = image;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    button.centerY = topView.height / 2.0;
    [button setImage:[UIImage imageNamed:@"search-close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearBtnaction) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = button;
    textField.rightViewMode = UITextFieldViewModeAlways;
    return topView;
}

- (void)clearBtnaction
{
    [self.currentDelegate HotsaleSearchDetailController:self isClear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.currentDelegate HotsaleSearchDetailController:self isClear:NO];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

- (void)cancleAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"商品", @"发现", @"评测", @"试用报告"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0: {
            CZSearchSubDetailOneController *vc = [[CZSearchSubDetailOneController alloc] init];
            vc.textSearch = self.textTitle;
            return vc;
        }
        case 1: {
            CZSearchSubDetailTwoController *vc = [[CZSearchSubDetailTwoController alloc] init];
            vc.type = CZDChoicenessControllerTypeDiscover;
            vc.textSearch = self.textTitle;
            return vc;
        }
        case 2: {
            CZSearchSubDetailTwoController *vc = [[CZSearchSubDetailTwoController alloc] init];
            vc.type = CZDChoicenessControllerTypeEvaluation;
            vc.textSearch = self.textTitle;
            return vc;
        }
            
        default:{
            CZSearchSubDetailTwoController *vc = [[CZSearchSubDetailTwoController alloc] init];
            vc.type = CZDChoicenessControllerTypeTry;
            vc.textSearch = self.textTitle;
            return vc;
        };
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 54 : 30) + 34, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, (IsiPhoneX ? 54 : 30) + 34 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + 84) + 50);
}

#pragma mark - 通知: 监听scrollerView的滚动
- (void)oneControllerScrollViewDidScroll:(NSNotification *)notifx
{
    UIScrollView *scrollView = notifx.userInfo[@"scrollView"];
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0 && offsetY < scrollView.contentSize.height - scrollView.height) {
        if (offsetY - self.recordOffsetY >= 0) {
            NSLog(@"向上滑动");
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, -50, SCR_WIDTH, SCR_HEIGHT + 50);
                self.currentOffsetY = -50;
            }];
        } else {
            NSLog(@"向下滑动");
            
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT);
                self.currentOffsetY = 0;
            }];
        } 
    }
    self.recordOffsetY = offsetY;
}

@end
