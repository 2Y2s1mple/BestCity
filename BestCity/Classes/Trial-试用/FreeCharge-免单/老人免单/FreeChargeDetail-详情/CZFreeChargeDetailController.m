//
//  CZFreeChargeDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeDetailController.h"
// 模型
#import "CZFreeChargeModel.h"

// 视图
#import "CZFreeDetailsubView.h"
#import "CZFreeSubOneController.h"
#import "CZFreeSubTwoController.h"
#import "CZFreeSubThreeController.h"
#import "CZCoinCenterController.h"
#import "CZShareView.h"
#import "CZFreeAlertView3.h"
#import "CZFreeAlertView2.h"
#import "CZFreeAlertView.h"
#import "CZScollerImageTool.h"

// 跳转
#import "TSLWebViewController.h"

// 工具
#import "CZOpenAlibcTrade.h"
#import "CZUMConfigure.h"
#import "CZUserInfoTool.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import "UIButton+CZExtension.h" // 按钮扩展
#import "GXNetTool.h"

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

/**x是否悬停了*/
@property (nonatomic , assign) BOOL  isHover;
/** <#注释#> */
@property (nonatomic, assign) CGFloat headerViewHeight;

/** 控制分享按钮的点击 */
@property (nonatomic, assign) NSInteger controlClickedNumber;
@end

// universal links
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>


@implementation CZFreeChargeDetailController
//实现带有场景参数的初始化方法，并根据场景参数还原该控制器：
-(instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    if (self = [super init]) {
        self.Id = scene.params[@"id"];
    }
    return self;
}

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
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    [self getShareImage];
}

- (void)getShareImage
{
    self.controlClickedNumber++;
    if (self.controlClickedNumber > 1) {
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"freeId"] = self.Id;
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/free/createFreePoster"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD hideAfterDelay:0];
            NSString *param = result[@"data"];
            [[CZFreeAlertView freeAlertViewRightBlock:^(CZFreeAlertView * _Nonnull alertView) {
                UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
                UINavigationController *nav = tabbar.selectedViewController;
                UIViewController *currentVc = nav.topViewController;
                NSInteger type;
                if (self.isOldUser) {
                    type = 11;
                } else {
                    type = 12;
                }
                [[CZUMConfigure shareConfigure] shareToPlatformType:UMSocialPlatformType_WechatSession currentViewController:currentVc webUrl:@"https://www.jipincheng.cn" Title:self.shareDic[@"shareTitle"] subTitle:self.shareDic[@"shareContent"] thumImage:self.shareDic[@"shareImg"] shareType:type object:self.shareDic[@"id"]];
            } leftBlock:^(CZFreeAlertView * _Nonnull alertView) {
                CURRENTVC(currentVc);
                [[CZUMConfigure shareConfigure] sharePlatform:UMSocialPlatformType_WechatTimeLine controller:currentVc url:@"https://www.jipincheng.cn" Title:self.shareDic[@"shareTitle"] subTitle:self.shareDic[@"shareContent"] thumImage:param shareType:CZUMConfigureTypeImage object:@""];
            }] show];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:1.5];
        }
        self.controlClickedNumber = 0;
        //隐藏菊花
    } failure:^(NSError *error) {
        [CZProgressHUD hideAfterDelay:0];
        self.controlClickedNumber = 0;
    }];
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
    commentBtn.frame = CGRectMake(0, 0, bottomView.width - 160, bottomView.height);
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"购买后补贴¥%@", self.dataSource.freePrice]];
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} range:NSMakeRange(0, 6)];
    [string addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size: 19]} range:NSMakeRange(6, self.dataSource.freePrice.length)];
    [string addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE25838)} range:NSMakeRange(0, string.length)];
    [commentBtn setAttributedTitle:string forState:UIControlStateNormal];
    [bottomView addSubview:commentBtn];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CZGlobalLightGray;
    lineView.x = 0;
    lineView.y = 0;
    lineView.width = commentBtn.width;
    lineView.height = 1;
    [bottomView addSubview:lineView];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(commentBtn.width, commentBtn.y, 160, commentBtn.height);
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];

    [rightBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.backgroundColor = UIColorFromRGB(0xF76D20);
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightBtn];
    _rightBtn = rightBtn;
}

// 创建上部内容
- (void)setupContentView
{
    // 创建轮播图
    _imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 320)];
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
    [self.topContent removeFromSuperview];
    self.topContent = [CZFreeDetailsubView freeDetailsubView];
    self.topContent.isOldUser = self.isOldUser;
    self.topContent.y = CZGetY(_imageView);
    self.topContent.width = SCR_WIDTH;
    self.topContent.model = self.dataSource;
    [self.scrollerView addSubview:self.topContent];

    self.menusView.y = CZGetY(self.topContent);
    self.contentScrollView.y = CGRectGetMaxY(self.menusView.frame);
    self.scrollerView.contentSize = CGSizeMake(0, CZGetY(self.menusView) + SCR_HEIGHT - (IsiPhoneX ? 83 : 49) - 50 - (IsiPhoneX ? 44 : 20));
    return self.topContent;
}

// 创建标题菜单
- (UIView *)setupMenus
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.height = 50;
    backView.width = SCR_WIDTH;



    NSInteger count = self.childViewControllers.count;
    CGFloat width = SCR_WIDTH / count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.width = width;
        btn.centerY = backView.height / 2.0;
        btn.x = i * width;
        [backView addSubview:btn];
        [btn addTarget:self action:@selector(menuDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIView *view = [[UIView alloc] init];
        view.tag = i + 200;
        view.y = backView.height - 4;
        view.width = 55;
        view.height = 3;
        view.centerX = btn.centerX;
        view.backgroundColor = CZREDCOLOR;
        view.layer.cornerRadius = 2;
        [backView addSubview:view];
        view.hidden = YES;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(view), SCR_WIDTH, 1)];
        line.backgroundColor = CZGlobalLightGray;
        [backView addSubview:line];

        if (i == 0) {
            view.hidden = NO;
            [btn setTitleColor:UIColorFromRGB(0x050505) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
            self.recordBtn = btn;
        }
    }

    UIButton *menusbtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 35, backView.height) backImage:@"nav-back" target:self action:@selector(popAction)];
    menusbtn.backgroundColor = [UIColor clearColor];
    _menusbtn = menusbtn;
    [backView addSubview:menusbtn];
    _menusbtn.hidden = YES;
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

    if (_isOldUser) {
        CZFreeSubThreeController *social2 = [[CZFreeSubThreeController alloc] init];
        social2.title = @"免单技巧";
        social2.stringHtml = self.dataSource.freeGuide;
        social2.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:social2];
    }
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
    self.contentScrollView.contentSize = CGSizeMake(count * SCR_WIDTH, 0);

    // 默认显示第一个
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

#pragma mark - 赋值
- (void)assignmentWithModule
{
    NSString *statusText;
    if ([self.dataSource.myInviteUserCount integerValue] < [self.dataSource.inviteUserCount integerValue]) {
        statusText = @"立即邀请";
    } else {
        statusText = @"立即购买";
    }
    [_rightBtn setTitle:statusText forState:UIControlStateNormal];
    _rightBtn.backgroundColor = UIColorFromRGB(0xE25838);
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = CZGlobalWhiteBg;
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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


#pragma mark - 获取数据
- (void)reloadNewDataSorce
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"freeId"] = self.Id;
    param[@"type"] = @(1);

    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/free/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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

#pragma mark - 事件
// 返回
- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 立即购买, 立即邀请
- (void)rightBtnAction:(UIButton *)btn
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }

    if ([btn.titleLabel.text isEqualToString:@"立即购买"]) {

        if (_isOldUser) {
            CZFreeAlertView2 *alertView = [CZFreeAlertView2 freeAlertView:^(CZFreeAlertView2 * _Nonnull alertView) {
                [self buyBtnAction];
            }];
            alertView.param = self.dataSource;
            [alertView show];
        } else {
            CZFreeAlertView3 *alertView = [CZFreeAlertView3 freeAlertView:^(CZFreeAlertView3 * _Nonnull alertView) {
                [self buyBtnAction];
            }];
            alertView.param = self.dataSource;
            [alertView show];
        }
    } else {
        [self getShareImage];
    }
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
        [sender setTitleColor:UIColorFromRGB(0x050505) forState:UIControlStateNormal];
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

// 购买
- (void)buyBtnAction
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *naVc = tabbar.selectedViewController;
    UIViewController *toVC = naVc.topViewController;
    NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
    if (specialId.length == 0) {
        [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
        [[ALBBSDK sharedInstance] auth:toVC successCallback:^(ALBBSession *session) {
            NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
            NSLog(@"%@", tip);
            TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@""] actionblock:^{
                [CZProgressHUD showProgressHUDWithText:@"授权成功"];
                [CZProgressHUD hideAfterDelay:1.5];
                [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];
            }];
            [tabbar presentViewController:webVc animated:YES completion:nil];

            //拉起淘宝
            AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
            showParam.openType = AlibcOpenTypeAuto;
            showParam.backUrl = @"tbopen25267281://xx.xx.xx";
            showParam.isNeedPush = YES;
            showParam.nativeFailMode = AlibcNativeFailModeJumpH5;

            [CZProgressHUD hideAfterDelay:1.5];

            [[AlibcTradeSDK sharedInstance].tradeService
             openByUrl:[NSString stringWithFormat:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=25612235&redirect_uri=https://www.jipincheng.cn/qualityshop-api/api/taobao/returnUrl&state=%@&view=wap", JPTOKEN]
             identity:@"trade"
             webView:webVc.webView
             parentController:tabbar
             showParams:showParam
             taoKeParams:nil
             trackParam:nil
             tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                 NSLog(@"-----AlibcTradeSDK------");
                 if(result.result == AlibcTradeResultTypeAddCard){
                     NSLog(@"交易成功");
                 } else if(result.result == AlibcTradeResultTypeAddCard){
                     NSLog(@"加入购物车");
                 }
             } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                 NSLog(@"----------退出交易流程----------");
             }];
        } failureCallback:^(ALBBSession *session, NSError *error) {
            NSString *tip=[NSString stringWithFormat:@"登录失败:%@",@""];
            NSLog(@"%@", tip);
        }];
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
        UIViewController *showVc = self.childViewControllers[index];        showVc.view.frame = CGRectMake(x, y, width, height);
        [scrollView addSubview:showVc.view];
    }

    if (scrollView == self.contentScrollView) {
        self.selectedMenuItem(scrollView.contentOffset.x);
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.headerViewHeight = (CGRectGetMinY(self.menusView.frame) - (IsiPhoneX ? 44 : 20));

    if (scrollView == self.scrollerView) {
        if (self.scrollerView.contentOffset.y < self.headerViewHeight) {
            _menusbtn.hidden = YES;
            self.statusView.hidden = YES;
            if (self.isHover) {
                self.scrollerView.contentOffset = CGPointMake(0, _headerViewHeight);
            }
        } else { // 显示导航栏的时候
            _menusbtn.hidden = NO;
            self.statusView.hidden = NO;
            self.isHover = YES;
            self.scrollerView.contentOffset = CGPointMake(0, self.headerViewHeight);
        }
    }

//    if (scrollView == self.contentScrollView) {
//        self.selectedMenuItem(scrollView.contentOffset.x);
//    }
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

#pragma mark - 业务处理方法

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
