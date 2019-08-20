//
//  CZViewController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMeIntelligentController.h"
#import "CZMeIntelligentView.h"
#import "UIButton+CZExtension.h" // 按钮扩展

#import "CZMeIntelligentSubController.h"

@interface CZMeIntelligentController ()<UIScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, strong) CZMeIntelligentView *headerView;
/** 菜单按钮 */
@property (nonatomic, strong) UIButton *menusbtn;
/** 记录点击的主菜单Btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 下部分视图 */
@property (nonatomic, strong) UIView *menusView;
/** statusView */
@property (nonatomic, strong) UIView *statusView;
/** 内容 */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/**x是否悬停了*/
@property (nonatomic , assign) BOOL  isHover;
@end

@implementation CZMeIntelligentController
#pragma mark - 创建视图
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = [UIColor whiteColor];
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.bounces = NO;
    }
    return _scrollerView;
}

// 创建底部视图
- (void)setupBottomContentView
{
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor greenColor];
    self.contentScrollView.x = 0;
    self.contentScrollView.y = CGRectGetMaxY(self.menusView.frame);
    self.contentScrollView.width = SCR_WIDTH;
    self.contentScrollView.height = SCR_HEIGHT - 50 - (IsiPhoneX ? 22 : 0);
    self.contentScrollView.delegate = self; // 只有内容设置代理
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    [self.scrollerView addSubview:self.contentScrollView];
    NSInteger count = self.childViewControllers.count;
    self.contentScrollView.contentSize = CGSizeMake(count * SCR_WIDTH, 0);

    // 默认显示第一个
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, (IsiPhoneX ? 44 : 20))];
    statusView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:statusView];
    self.statusView = statusView;
    self.statusView.hidden = YES;

    // 创建滚动视图
    [self.view addSubview:self.scrollerView];

    // 头部视图
    self.headerView = [[CZMeIntelligentView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0)];
    [self.scrollerView addSubview:self.headerView];

    self.menusView = [self setupMenus];
    self.menusView.y = CZGetY(self.headerView);
    [self.scrollerView addSubview:self.menusView];

    // 添加子控制器
    [self setupChildVc];

    // 添加承载菜单内容的父视图
    [self setupBottomContentView];

    self.scrollerView.contentSize = CGSizeMake(0,  CZGetY(self.headerView) + SCR_HEIGHT);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentViewIsScroll:) name:@"CZFreeChargeDetailControllerNoti" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.statusView.hidden = YES;
}

- (void)setupChildVc
{
    CZMeIntelligentSubController *social0 = [[CZMeIntelligentSubController alloc] init];
    social0.freeID = self.freeID;
    social0.type = @"4"; //分类（2清单，3问答，4评测）
//    social0.view.backgroundColor = RANDOMCOLOR;
    [self addChildViewController:social0];

    CZMeIntelligentSubController *social1 = [[CZMeIntelligentSubController alloc] init];
    social1.freeID = self.freeID;
    social1.type = @"2"; //分类（2清单，3问答，4评测）
//    social1.view.backgroundColor = RANDOMCOLOR;
    [self addChildViewController:social1];

    CZMeIntelligentSubController *social2 = [[CZMeIntelligentSubController alloc] init];
    social2.freeID = self.freeID;
    social2.type = @"3"; //分类（2清单，3问答，4评测）
//    social2.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:social2];
}

// 创建标题菜单
- (UIView *)setupMenus
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.height = 50;
    backView.width = SCR_WIDTH;

    UIButton *menusbtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 35, backView.height) backImage:@"nav-back" target:self action:@selector(popAction)];
    _menusbtn = menusbtn;
    [backView addSubview:menusbtn];
    _menusbtn.hidden = YES;

    NSInteger count = 3;
    NSArray *titles = @[@"评测", @"清单", @"问答"];
    CGFloat space = (SCR_WIDTH - 70 - count * 55) / (count - 1);
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        btn.size = CGSizeMake(55, 25);
        btn.centerY = backView.height / 2.0;
        btn.x = 35 + i * (space + 55);
        [backView addSubview:btn];
        [btn addTarget:self action:@selector(menuDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIView *view = [[UIView alloc] init];
        view.tag = i + 200;
        view.x = btn.x;
        view.y = backView.height - 4;
        view.width = btn.width;
        view.height = 3;
        view.backgroundColor = CZREDCOLOR;
        view.layer.cornerRadius = 2;
        [backView addSubview:view];
        view.hidden = YES;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(view), SCR_WIDTH, 1)];
        line.backgroundColor = CZGlobalLightGray;
        [backView addSubview:line];

        if (i == 0) {
            view.hidden = NO;
            [btn setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
            self.recordBtn = btn;
        }
    }
    return backView;
}

#pragma mark - 事件
// 返回
- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 菜单点击方法
- (void)menuDidClickedBtn:(UIButton *)sender
{
    NSLog(@"%@", sender);
    NSInteger index = sender.tag - 100;
    [self.contentScrollView setContentOffset:CGPointMake(index * SCR_WIDTH, 0) animated:YES];
    [self setupBtn:sender];
}

- (void)setupBtn:(UIButton *)sender
{
    if (self.recordBtn != sender) {
        // 现在的btn
        [sender setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        NSInteger lineViewTag = sender.tag + 100;
        UIView *lineView =  [sender.superview viewWithTag:lineViewTag];
        lineView.hidden = NO;

        // 前一个Btn
        [self.recordBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        self.recordBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        UIView *recordLineView =  [sender.superview viewWithTag:self.recordBtn.tag + 100];
        recordLineView.hidden = YES;
        self.recordBtn = sender;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat headerViewHeight = self.headerView.height - 10;
    if (scrollView == self.scrollerView) {
        if (self.scrollerView.contentOffset.y < headerViewHeight) {
            _menusbtn.hidden = YES;
            self.statusView.hidden = YES;
            if (self.isHover) {
                self.scrollerView.contentOffset = CGPointMake(0, headerViewHeight);
            }
        } else { // 显示导航栏的时候
            _menusbtn.hidden = NO;
            self.statusView.hidden = NO;
            self.isHover = YES;
            self.scrollerView.contentOffset = CGPointMake(0, headerViewHeight);
        }
    }

    if (scrollView == self.contentScrollView) {
        self.selectedMenuItem(scrollView.contentOffset.x);
    }

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        CGFloat y = 0;
        CGFloat width = scrollView.width;
        CGFloat height = scrollView.height;
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        CZMeIntelligentSubController *showVc = self.childViewControllers[index];        showVc.view.frame = CGRectMake(x, y, width, height);
        [showVc.tableView reloadData];
        [scrollView addSubview:showVc.view];
    }
}

#pragma mark - 通知
- (void)currentViewIsScroll:(NSNotification *)noti
{
    UIScrollView *scrollView = noti.userInfo[@"isScroller"];
    if (scrollView.contentOffset.y <= 0) {
        self.isHover = NO;
        scrollView.contentOffset = CGPointZero;
        NSArray *tem  = self.childViewControllers;
        for (UIViewController *subV in tem) {
            for (UIScrollView *view in subV.view.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    view.contentOffset = CGPointZero;
                }
            }
        }
    } else {
        if (!self.isHover) {
            scrollView.contentOffset = CGPointZero;
            NSArray *tem  = self.childViewControllers;
            for (UIViewController *subV in tem) {
                for (UIScrollView *view in subV.view.subviews) {
                    if ([view isKindOfClass:[UIScrollView class]]) {
                        view.contentOffset = CGPointZero;
                    }
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

// 返回选中菜单按钮的样式
- (void (^)(CGFloat))selectedMenuItem
{
    return ^(CGFloat x){
        NSInteger index = x / SCR_WIDTH;
        switch (index) {
            case 0:
            {
                UIButton *btn = [self.menusView viewWithTag:100];
                [self setupBtn:btn];
                break;
            }
            case 1:
            {
                UIButton *btn = [self.menusView viewWithTag:101];
                [self setupBtn:btn];
                break;
            }
            case 2:
            {
                UIButton *btn = [self.menusView viewWithTag:102];
                [self setupBtn:btn];
                break;
            }
            default:
                break;
        }
    };
}

@end

