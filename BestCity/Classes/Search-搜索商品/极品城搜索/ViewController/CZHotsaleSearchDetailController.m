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
// 子控制
#import "CZSearchOneSubView.h"
#import "CZSearchTwoSubView.h"
#import "CZSearchThreeSubView.h"

#import "CZSearchFiveSubView.h"

@interface CZHotsaleSearchDetailController ()<UITextFieldDelegate>
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 当前的偏移量 */
@property (nonatomic, assign) CGFloat currentOffsetY;
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
/** <#注释#> */
@property (nonatomic, strong) NSArray *titleList;
@end

@implementation CZHotsaleSearchDetailController
- (NSArray *)titleList
{
    return @[@"榜单", @"清单", @"问答", @"评测", @"试用报告"];
}

#pragma mark - 数据
// 搜索框Y值
- (CGFloat)searchViewY
{
    return (IsiPhoneX ? 54 : 30);
}

// 搜索框H值
- (CGFloat)searchHeight
{
    return 44;
}
#pragma mark -- end

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
    [self setupTopViewWithFrame:CGRectMake(0, self.searchViewY, SCR_WIDTH, self.searchHeight)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneControllerScrollViewDidScroll:) name:@"CZSearchSubDetailOneController" object:nil];
}

#pragma mark - 创建搜索框以及方法
- (void)setupTopViewWithFrame:(CGRect)frame
{

    UIButton *popBtn = [[UIButton alloc] init];
    [popBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    popBtn.x = 0;
    popBtn.y =  self.searchViewY;
    popBtn.size = CGSizeMake(45, 44);
    popBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [popBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];

    UIView *backView = [[UIView alloc] init];
    backView.x = 45;
    backView.y = popBtn.y;
    backView.width = SCR_WIDTH - 45 - 15;
    backView.height = 44;
    backView.backgroundColor = UIColorFromRGB(0xD8D8D8);
    backView.layer.cornerRadius = 6;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];

    CZTextField *textF = [[CZTextField alloc] init];
    textF.width = backView.width - 48;
    textF.height = 44;
    textF.delegate = self;
    textF.text = self.textTitle;
    [backView addSubview:textF];

    UIButton *msgBtn = [[UIButton alloc] init];
    [msgBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    msgBtn.x = CGRectGetMaxX(textF.frame);
    msgBtn.size = CGSizeMake(40, 44);
    msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [msgBtn addTarget:self action:@selector(clearBtnaction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:msgBtn];


//    UIView *topView = [[UIView alloc] initWithFrame:frame];
//    [self.view addSubview:topView];
//
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
//    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
//    [topView addSubview:leftBtn];
//    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(topView).offset(2);
//        make.left.equalTo(topView).offset(0);
//        make.width.equalTo(@(40));
//        make.height.equalTo(@(topView.height));
//    }];
//
//    CZTextField *textField = [[CZTextField alloc] init];
//    textField.backgroundColor = [UIColor whiteColor];
//    textField.layer.borderColor = UIColorFromRGB(0xACACAC).CGColor;
//    textField.layer.borderWidth = 0.5;
//    [topView addSubview:textField];
//    textField.delegate = self;
//    textField.text = self.textTitle;
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(topView);
//        make.right.equalTo(topView).offset(-20);
//        make.left.equalTo(leftBtn.mas_right).offset(0);
//        make.height.equalTo(@(topView.height));
//    }];
//
//    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-search"]];
//    textField.leftView = image;
//    textField.leftViewMode = UITextFieldViewModeAlways;
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 20, 20);
//    button.centerY = topView.height / 2.0;
//    [button setImage:[UIImage imageNamed:@"search-close"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clearBtnaction) forControlEvents:UIControlEventTouchUpInside];
//    textField.rightView = button;
//    textField.rightViewMode = UITextFieldViewModeAlways;
//    return topView;
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
    return self.titleList.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleList[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    //    （1商品，2清单，3问答，4评测，5试用报告）
    switch (index) {
        case 0: {
            CZSearchOneSubView *vc = [[CZSearchOneSubView alloc] init];
            vc.textSearch = self.textTitle;
            return vc;
        }
        case 1: {
            CZSearchTwoSubView *vc = [[CZSearchTwoSubView alloc] init];
            vc.type = @"2";
            vc.textSearch = self.textTitle;
            return vc;
        }
        case 2: {
            CZSearchThreeSubView *vc = [[CZSearchThreeSubView alloc] init];
            vc.textSearch = self.textTitle;
            return vc;
        }
        case 3: {
            CZSearchTwoSubView *vc = [[CZSearchTwoSubView alloc] init];
            vc.type = @"4";
            vc.textSearch = self.textTitle;
            return vc;
        }
        case 4: {
            CZSearchFiveSubView *vc = [[CZSearchFiveSubView alloc] init];
            vc.textSearch = self.textTitle;
            return vc;
        }
            
        default:{
            CZSearchSubDetailTwoController *vc = [[CZSearchSubDetailTwoController alloc] init];
            vc.type = CZJIPINModuleTrail;
            vc.textSearch = self.textTitle;
            return vc;
        };
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, self.searchViewY + self.searchHeight + 10, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {

    CGFloat Y = self.searchViewY + self.searchHeight + 50 + 10;
    return CGRectMake(0, Y, SCR_WIDTH, SCR_HEIGHT - Y);
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
