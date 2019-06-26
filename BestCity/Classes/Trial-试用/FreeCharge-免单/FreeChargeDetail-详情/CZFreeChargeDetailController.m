//
//  CZFreeChargeDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeDetailController.h"
#import "CZScollerImageTool.h"
#import "GXNetTool.h"
#import "UIButton+CZExtension.h" // 按钮扩展
// 模型
#import "CZFreeChargeModel.h"

// 视图
#import "CZFreeDetailsubView.h"
#import "CZFreeAlertView.h"
#import "CZFreeAlertView2.h"
#import "CZOpenAlibcTrade.h"
#import "CZFreeSubOneController.h"
#import "CZFreeSubTwoController.h"
#import "CZFreeSubThreeController.h"
#import "CZCoinCenterController.h"
#import "CZShareView.h"

// 跳转
#import "TSLWebViewController.h"

// 工具
#import "CZUserInfoTool.h"

@interface CZFreeChargeDetailController () <UIScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
/** 分享 */
@property (nonatomic, strong) UIButton *shareButton;
/** 轮播图 */
@property (nonatomic, strong) CZScollerImageTool *imageView;
/** 数据 */
@property (nonatomic, strong) CZFreeChargeModel *dataSource;
/** 右边按钮 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 中间视图 */
@property (nonatomic, strong) CZFreeDetailsubView *topContent;

/** 下部分视图 */
@property (nonatomic, strong) UIView *menusView;
/** 记录点击的主菜单Btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 内容 */
@property (nonatomic, strong) UIScrollView *contentScrollView;

/** 菜单按钮 */
@property (nonatomic, strong) UIButton *menusbtn;

/** 分享 */
@property (nonatomic, strong) NSDictionary *shareDic;
/** statusView */
@property (nonatomic, strong) UIView *statusView;
@end

@implementation CZFreeChargeDetailController
#pragma mark - 创建视图
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.bounces = NO;
    }
    return _scrollerView;
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}


- (UIButton *)shareButton
{
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.frame = CGRectMake(SCR_WIDTH - 14 - 30, (IsiPhoneX ? 54 : 30), 30, 30);
        [_shareButton setImage:[UIImage imageNamed:@"Trail-share"] forState:UIControlStateNormal];
        _shareButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _shareButton.layer.cornerRadius = 15;
        _shareButton.layer.masksToBounds = YES;
    }
    return _shareButton;
}

- (void)shareButtonAction
{
    CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
    share.cententText =  self.shareDic[@"shareContent"];
    share.param = @{
                    @"shareUrl" : self.shareDic[@"shareUrl"],
                    @"shareTitle" : self.shareDic[@"shareTitle"],
                    @"shareContent" : self.shareDic[@"shareContent"],
                    @"shareImg" : self.shareDic[@"shareImg"],
                    };
    [self.view addSubview:share];
}

// 初始化底部菜单
- (void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.size = CGSizeMake(SCR_WIDTH, 49);
    bottomView.y = SCR_HEIGHT - (IsiPhoneX ? 83 : 49);
    [self.view addSubview:bottomView];

    // 两个按钮
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    commentBtn.frame = CGRectMake(0, 0, bottomView.width / 2.0, bottomView.height);
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [commentBtn setTitle:[NSString stringWithFormat:@"剩余%ld件", ([self.dataSource.count integerValue] - [self.dataSource.userCount integerValue])] forState:UIControlStateNormal];
    [commentBtn setTitleColor:UIColorFromRGB(0x151515) forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomView addSubview:commentBtn];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CZGlobalLightGray;
    lineView.x = 0;
    lineView.y = 0;
    lineView.width = commentBtn.width;
    lineView.height = 1;
    [bottomView addSubview:lineView];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(commentBtn.width, commentBtn.y, commentBtn.width, commentBtn.height);
    rightBtn.titleLabel.font = commentBtn.titleLabel.font;
    [rightBtn setTitle:@"即将开始" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.backgroundColor = UIColorFromRGB(0xF76D20);
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightBtn];
    _rightBtn = rightBtn;
}

// 创建上部内容
static BOOL isCountDownAction;
- (void)setupContentView
{
    // 创建轮播图
    _imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 375)];
    [self.scrollerView addSubview:_imageView];
    _imageView.imgList = self.dataSource.imgList;

    // 创建底部视图
    [self setupBottomView];

    // 初始化中部视图
    self.topContent = [self refreshModule];

    // 加载pop按钮
    [self.scrollerView addSubview:self.popButton];

    // 加载分享按钮
    [self.scrollerView addSubview:self.shareButton];

    // 添加子控制器
    [self setupChildVc];

    // 添加菜单视图
    self.menusView = [self setupMenus];
    self.menusView.y = CZGetY(self.topContent) + 10;
    [self.scrollerView addSubview:self.menusView];

    // 添加承载菜单内容的父视图
    [self setupBottomContentView];

    self.scrollerView.contentSize = CGSizeMake(0, CZGetY(self.menusView) + SCR_HEIGHT - (IsiPhoneX ? 83 : 49) - 50 - (IsiPhoneX ? 44 : 20));
}

// 刷新视图
- (CZFreeDetailsubView *)refreshModule
{
    isCountDownAction = NO;
    [self.topContent removeFromSuperview];
    //  -1未申请，0申请成功未付款，1已付款 applyStatus;
    if ([self.dataSource.applyStatus integerValue] == 0) { // 0申请成功未付款
        self.topContent = [CZFreeDetailsubView freeDetailsubView1:^{
            isCountDownAction = YES;
            [self->_rightBtn setTitle:@"前往购买" forState:UIControlStateNormal];
            self->_rightBtn.enabled = NO;
            self->_rightBtn.backgroundColor = UIColorFromRGB(0xFFD8D8D8);
        }];
        self.topContent.y = CZGetY(_imageView);
        self.topContent.width = SCR_WIDTH;
        self.topContent.model = self.dataSource;
    } else if ([self.dataSource.applyStatus integerValue] == 1) { // 1申请成功已付款
        self.topContent = [CZFreeDetailsubView freeDetailsubView2];
        self.topContent.y = CZGetY(_imageView);
        self.topContent.width = SCR_WIDTH;
        self.topContent.model = self.dataSource;
    } else {
        self.topContent = [CZFreeDetailsubView freeDetailsubView];
        self.topContent.y = CZGetY(_imageView);
        self.topContent.width = SCR_WIDTH;
        self.topContent.model = self.dataSource;
    }

    [self.scrollerView addSubview:self.topContent];

    self.scrollerView.contentSize = CGSizeMake(0, CZGetY(self.menusView) + SCR_HEIGHT - (IsiPhoneX ? 83 : 49) - 50 - (IsiPhoneX ? 44 : 20));

    self.menusView.y = CZGetY(self.topContent) + 10;

    self.contentScrollView.y = CGRectGetMaxY(self.menusView.frame);

    return self.topContent;
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

    NSInteger count = self.childViewControllers.count;
    CGFloat space = (SCR_WIDTH - 70 - count * 55) / (count - 1);
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [btn sizeToFit];
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

- (void)setupChildVc
{
    CZFreeSubOneController *social0 = [[CZFreeSubOneController alloc] init];
    social0.title = @"商品介绍";
    social0.goodsContentList = self.dataSource.goodsContentList;
    social0.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:social0];

    CZFreeSubTwoController *social1 = [[CZFreeSubTwoController alloc] init];
    social1.title = @"参与名单";
    social1.freeID = self.Id;
    social1.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:social1];

    CZFreeSubThreeController *social2 = [[CZFreeSubThreeController alloc] init];
    social2.title = @"规则说明";
    social2.stringHtml = self.dataSource.freeGuide;
    social2.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:social2];
}

// 创建底部视图
- (void)setupBottomContentView
{
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.x = 0;
    self.contentScrollView.y = CGRectGetMaxY(self.menusView.frame);
    self.contentScrollView.width = SCR_WIDTH;
    self.contentScrollView.height = SCR_HEIGHT - self.menusView.height - (IsiPhoneX ? 83 : 49) - (IsiPhoneX ? 44 : 20);
    self.contentScrollView.delegate = self; // 只有内容设置代理
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    [self.scrollerView addSubview:self.contentScrollView];
    NSInteger count = self.childViewControllers.count;
    self.contentScrollView.contentSize = CGSizeMake(SCR_WIDTH * count, 0);

    // 默认显示第一个
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    isCountDownAction = NO;
    self.view.backgroundColor = CZGlobalWhiteBg;
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];

    //获取数据
    [self reloadNewDataSorce];

    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, (IsiPhoneX ? 44 : 20))];
    statusView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:statusView];
    self.statusView = statusView;
    self.statusView.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentViewIsScroll:) name:@"CZFreeChargeDetailControllerNoti" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 加载pop按钮
    [self.scrollerView addSubview:self.popButton];
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.statusView removeFromSuperview];
}

#pragma mark - 通知
- (void)currentViewIsScroll:(NSNotification *)noti
{
    NSLog(@"%@", noti.userInfo[@"isScroller"]);
    if ([noti.userInfo[@"isScroller"]  isEqual: @(1)]) {
        _scrollerView.scrollEnabled = YES;
    } else {
        _scrollerView.scrollEnabled = NO;;
    }
}

#pragma mark - 获取数据
- (void)reloadNewDataSorce
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"freeId"] = self.Id;

    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/free/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.shareDic = result[@"data"];
            self.dataSource = [CZFreeChargeModel objectWithKeyValues:result[@"data"]];
            // 创建上部内容
            if (!self.imageView) {
                [self setupContentView];
            }
            [self assignmentWithModule];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

#pragma mark - 赋值
- (void)assignmentWithModule
{
    if ([self.dataSource.applyStatus integerValue] == -1) { // 未申请
        switch ([self.dataSource.status integerValue]) { // （0即将开始，1进行中，2已售罄，3已结束）
            case 0:
                [_rightBtn setTitle:@"即将开始" forState:UIControlStateNormal];
                _rightBtn.enabled = YES;
                _rightBtn.backgroundColor = UIColorFromRGB(0xF76D20);
                break;
            case 1: //  -1未申请，0申请成功未付款，1已付款 applyStatus;
                [_rightBtn setTitle:@"免费抢购" forState:UIControlStateNormal];
                _rightBtn.enabled = YES;
                _rightBtn.backgroundColor = UIColorFromRGB(0xE31B3C);
                break;
            case 2:
                [_rightBtn setTitle:@"已售罄" forState:UIControlStateNormal];
                _rightBtn.enabled = NO;
                _rightBtn.backgroundColor = UIColorFromRGB(0xFFD8D8D8);
                break;

            default:
                break;
        }
    } else { // 已申请
        //  -1未申请，0申请成功未付款，1已付款 applyStatus;
        if ([self.dataSource.applyStatus integerValue] == 0) {
            if (isCountDownAction) return;
            NSString *title = [NSString stringWithFormat:@"前往购买 (可返回%@元)", self.dataSource.freePrice];
            NSMutableAttributedString *attriStr = [title addAttributeFont:[UIFont systemFontOfSize:13] Range:[title rangeOfString:[NSString stringWithFormat:@"(可返回%@元)", self.dataSource.freePrice]]];
            [attriStr addAttribute:NSForegroundColorAttributeName value:CZGlobalWhiteBg range:NSMakeRange(0, attriStr.length)];

            [_rightBtn setAttributedTitle:attriStr forState:UIControlStateNormal];
            _rightBtn.enabled = YES;
            _rightBtn.backgroundColor = UIColorFromRGB(0xE31B3C);
        } else if ([self.dataSource.applyStatus integerValue] == 1) {
            [_rightBtn setTitle:@"前往购买" forState:UIControlStateNormal];
            _rightBtn.enabled = YES;
            _rightBtn.backgroundColor = UIColorFromRGB(0xE31B3C);
        }
    }
}

#pragma mark - 事件
// 返回
- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 免费抢购
- (void)rightBtnAction:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqual:@"即将开始"]) {
        [CZProgressHUD showProgressHUDWithText:@"活动暂未开始!"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    if ([JPUSERINFO[@"point"] integerValue] < [self.dataSource.point integerValue]) {
        CZFreeAlertView2 *vc = [CZFreeAlertView2 freeAlertView:^(CZFreeAlertView2 *alert){
            CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        vc.point = self.dataSource.point;
        [vc show];
        return;
    }


    if ([btn.titleLabel.text  isEqual: @"免费抢购"]) {
        CZFreeAlertView *vc = [CZFreeAlertView freeAlertView:^(CZFreeAlertView *alert){
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"freeId"] = self.Id;
            //获取详情数据
            [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/free/apply"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
                if ([result[@"code"] isEqual:@(0)]) {
                    [self refreshDataSource];

                    [CZProgressHUD showProgressHUDWithText:@"参与成功"];
                    [CZProgressHUD hideAfterDelay:1.5];
                    [alert hide];
                } else {
                    [CZProgressHUD showProgressHUDWithText:@"请求错误, 请刷新界面"];
                    [CZProgressHUD hideAfterDelay:1.5];
                    [alert hide];
                }
            } failure:^(NSError *error) {}];
        }];
        vc.point = self.dataSource.point;
        [vc show];
    } else {
        [self buyBtnAction];
    }
}


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

// 刷新数据
- (void)refreshDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"freeId"] = self.Id;
    //获取数据
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/free/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = [CZFreeChargeModel objectWithKeyValues:result[@"data"]];
            //
            [self refreshModule];
            [self assignmentWithModule];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

/** 购买*/
- (void)buyBtnAction
{
    NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
    if (specialId.length == 0) {
        TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/taobao/login?token=%@", JPSERVER_URL, JPTOKEN]] actionblock:^{
            [CZProgressHUD showProgressHUDWithText:@"授权成功"];
            [CZProgressHUD hideAfterDelay:1.5];
            [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];
        }];
        [self presentViewController:webVc animated:YES completion:nil];
    } else {
        // 打开淘宝
        [self openAlibcTradeWithId:self.dataSource.goodsId];
    }

//    NSString *text = @"试用--商品--优惠购买";
//    NSDictionary *context = @{@"goods" : text};
//    [MobClick event:@"ID4" attributes:context];
//    NSLog(@"----%@", text);
}

- (void)openAlibcTradeWithId:(NSString *)ID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = ID;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsBuyLink"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:self];
        } else {
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        CGFloat y = 0;
        CGFloat width = scrollView.width;
        CGFloat height = scrollView.height;
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        UIViewController *showVc = self.childViewControllers[index];
        if (self.scrollerView.contentOffset.y < (CGRectGetMinY(self.menusView.frame) - (IsiPhoneX ? 44 : 20))) {
            self.scrollerView.scrollEnabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeDetailsubViewNoti" object:nil userInfo:@{@"isScroller" : @(NO)}]; //不滚
        } else { // 显示导航栏的时候
            self.scrollerView.scrollEnabled = NO; // 大view不能滑
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeDetailsubViewNoti" object:nil userInfo:@{@"isScroller" : @(YES)}]; // 小view能滑
        }
        showVc.view.frame = CGRectMake(x, y, width, height);
        [scrollView addSubview:showVc.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollerView) {
        if (self.scrollerView.contentOffset.y < (CGRectGetMinY(self.menusView.frame) - (IsiPhoneX ? 44 : 20))) {
            _menusbtn.hidden = YES;
            self.statusView.hidden = YES;
            self.scrollerView.scrollEnabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeDetailsubViewNoti" object:nil userInfo:@{@"isScroller" : @(NO)}]; //不滚

        } else { // 显示导航栏的时候
            _menusbtn.hidden = NO;
            self.statusView.hidden = NO;
            
            self.scrollerView.scrollEnabled = NO; // 大view不能滑
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeDetailsubViewNoti" object:nil userInfo:@{@"isScroller" : @(YES)}];// 小view能滑
        }
    }

    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x / SCR_WIDTH;
        NSLog(@"contentScrollView - %ld", index);
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

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end
