//
//  CZTrialDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialDetailController.h"
#import "CZNavigationView.h"
#import "UIButton+CZExtension.h" // 按钮扩展
//模型
#import "CZTrailReportModel.h"
// 视图控制器
#import "CZTrialDetailTopController.h"
#import "CZTrialCommodityDetailController.h" // 商品详情
#import "CZTrialApplyForDetailController.h" // 申请流程
#import "CZTrialTestListController.h" // 试用商品
#import "CZTestReportController.h" // 使用报告

// 工具
#import "GXNetTool.h"

// 跳转
#import "CZAllCriticalController.h"
#import "CZOpenAlibcTrade.h" // 淘宝
#import "CZCoinCenterController.h" // 极币
#import "CZvoteUserController.h"//使用名单
#import "CZTrialAllReportHotController.h" // 查看使用报告
#import "CZShareView.h" // 分享
#import "CZUserInfoTool.h"
#import "TSLWebViewController.h"


@interface CZTrialDetailController () <UIScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
/** 分享 */
@property (nonatomic, strong) UIButton *shareButton;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;
/** 记录点击的主菜单Btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 导航栏 */
@property (nonatomic, strong) UIView *navView;
/** 最上部 */
@property (nonatomic, strong) CZTrialDetailTopController *topVc;
/** 菜单 */
@property (nonatomic, strong) UIView *menusView;
/** 商品详情 */
@property (nonatomic, strong) CZTrialCommodityDetailController *commodityVc;
/** 申请流程 */
@property (nonatomic, strong) CZTrialApplyForDetailController *applyFor;
/** 试用名单 */
@property (nonatomic, strong) CZTrialTestListController *test;
/** 使用报告 */
@property (nonatomic, strong) CZTestReportController *testReport;
/** 分享拉赞 */
@property (nonatomic, strong) UIButton *listBtn;
/** 分享拉赞URL */
@property (nonatomic, strong) NSString *voteShareUrl;

/** 分享 */
@property (nonatomic, strong) NSDictionary *shareDic;
@end

/** 最下面控件高度 */
static CGFloat const likeAndShareHeight = 49;

@implementation CZTrialDetailController

#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat menusViewOffsetY = CZGetY(self.topVc.lineView) - self.navView.height;
    NSLog(@"--%lf --- %lf", offsetY, menusViewOffsetY);
    if (offsetY > menusViewOffsetY) {
        self.navView.hidden = NO;
        self.menusView.y = CZGetY(self.navView);
        [self.view addSubview:self.menusView];
    } else {
        self.menusView.y = CZGetY(self.topVc.lineView);
        [self.scrollerView addSubview:self.menusView];
        self.navView.hidden = YES;
    }
    
    CGFloat commodityVcY = 0;
    CGFloat applyForY = self.applyFor.view.y - (self.navView.height + self.menusView.height);
    CGFloat testY = self.test.view.y - (self.navView.height + self.menusView.height);
    CGFloat testReport = self.testReport.view.y - (self.navView.height + self.menusView.height);
    
    if (offsetY >= commodityVcY && offsetY <= applyForY) {
       UIButton *btn = [self.menusView viewWithTag:100];
        [self setupBtn:btn];
    } else if (offsetY >= applyForY && offsetY <= testY) {
        UIButton *btn = [self.menusView viewWithTag:101];
        [self setupBtn:btn];
    } else if (offsetY >= testY && offsetY <= testReport) {
        UIButton *btn = [self.menusView viewWithTag:102];
        [self setupBtn:btn];
    } else if (offsetY >= testReport) {
        UIButton *btn = [self.menusView viewWithTag:103];
        [self setupBtn:btn];
    }
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

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

    CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
    share.cententText =  self.shareDic[@"content"];
    share.param = @{
                    @"shareUrl" : self.dataSource[@"shareUrl"],
                    @"shareTitle" : self.dataSource[@"shareTitle"],
                    @"shareContent" : self.dataSource[@"shareContent"],
                    @"shareImg" : self.dataSource[@"shareImg"],
                    };
    [self.view addSubview:share];
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    
    // 加载pop按钮
    [self.view addSubview:self.popButton];
    
    // 加载分享按钮
    [self.view addSubview:self.shareButton];
    
    // 获取数据, 加载视图
    [self trailDetailDataSorce];
    
    // 创建导航栏
    self.navView = [self setupNav];
    self.navView.hidden = YES;
    [self.view addSubview:self.navView];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heightChange:) name:@"CZTrialCommodityDetailControllerNoti" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CZUserInfoTool userInfoInformation:nil];
}

#pragma mark - 监听子控件的frame的变化
- (void)heightChange:(NSNotification *)notfi
{
    NSLog(@"%@", notfi);
    
    self.applyFor.view.y = CZGetY(self.commodityVc.view);
    self.test.view.y = CZGetY(self.applyFor.view);
    self.testReport.view.y = CZGetY(self.test.view);
    self.scrollerView.contentSize = CGSizeMake(SCR_WIDTH, CZGetY(self.testReport.view) + 20);
}

#pragma mark - 获取数据
- (void)trailDetailDataSorce
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"trialId"] = self.trialId;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.shareDic = result;
            self.dataSource = result[@"data"];
            self.voteShareUrl = self.dataSource[@"voteShareUrl"];
            [self setupSubViews]; 
            // 创建底部按钮
            [self setupBottomView];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)setupSubViews
{
    // 最上面视图
    self.topVc = [[CZTrialDetailTopController alloc] init];
    self.topVc.detailData = self.dataSource;
    [self.scrollerView addSubview:self.topVc.view];
    [self addChildViewController:self.topVc];
    
    // 创建菜单
    self.menusView = [self setupMenus];
    self.menusView.y = CZGetY(self.topVc.lineView);
    [self.scrollerView addSubview:self.menusView];
    
    // 商品详情
    self.commodityVc = [[CZTrialCommodityDetailController alloc] init];
    self.commodityVc.goodsContentList = self.dataSource[@"goodsContentList"];
    self.commodityVc.view.y = CZGetY(self.menusView);
    [self.scrollerView addSubview:self.commodityVc.view];
    [self addChildViewController:self.commodityVc];
    
    // 申请流程
    self.applyFor = [[CZTrialApplyForDetailController alloc] init];
    self.applyFor.dataSource = self.dataSource;
    [self.scrollerView addSubview:self.applyFor.view];
    self.applyFor.view.y = CZGetY(self.commodityVc.view);
    [self addChildViewController:self.applyFor];
    
    // 试用名单
    self.test = [[CZTrialTestListController alloc] init];
    self.test.dataSource = self.dataSource;
    [self.scrollerView addSubview:self.test.view];
    self.test.view.y = CZGetY(self.applyFor.view);
    [self addChildViewController:self.test];
    
    // 使用报告
    self.testReport = [[CZTestReportController alloc] init];
    self.testReport.reportDatasArr = [CZTrailReportModel objectArrayWithKeyValuesArray:self.dataSource[@"reportArticleList"]];
    self.testReport.goodId = self.dataSource[@"goodsId"];
    [self.scrollerView addSubview:self.testReport.view];
    self.testReport.view.y = CZGetY(self.test.view);
    [self addChildViewController:self.testReport];
    
    // 计算高度
    self.scrollerView.contentSize = CGSizeMake(SCR_WIDTH, CZGetY(self.test.view) + 20);
}

- (NSArray *)thirdTitles
{
    return @[
             @{
                 @"title" : @"商品详情",
                 @"orderbyType" : @(1)
                 },
             @{
                 @"title" : @"申请流程",
                 @"orderbyType" : @(2)
                 },
             @{
                 @"title" : @"试用名单",
                 @"orderbyType" : @(5)
                 },
             @{  
                 @"title" : @"试用报告",
                 @"orderbyType" : @(3)
                 }
             ];
}

- (UIView *)setupMenus
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.height = 60;
    backView.width = SCR_WIDTH;
    
    
    NSArray *titles = self.thirdTitles;
    CGFloat space = (SCR_WIDTH - 30 - titles.count * 55) / (titles.count - 1);
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:titles[i][@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.centerY = backView.height / 2.0;
        btn.x = 15 + i * (space + 55);
        [backView addSubview:btn];
        [btn addTarget:self action:@selector(contentViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
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

- (void)contentViewDidClickedBtn:(UIButton *)sender
{
//    self.scrollerView.delegate = nil;
    CGPoint point;
    NSInteger tag = sender.tag - 100;
    switch (tag) {
        case 0:
            point = CGPointMake(0, 0);
            break;
        case 1:
            point = CGPointMake(0, self.applyFor.view.y - (self.navView.height + self.menusView.height));
            break;
        case 2:
            point = CGPointMake(0, self.test.view.y - (self.navView.height + self.menusView.height));
            break;
        case 3:
            point = CGPointMake(0, self.testReport.view.y - (self.navView.height + self.menusView.height));
            break;
            
        default:
            point = CGPointMake(0, 0);
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollerView.contentOffset = point;
    } completion:^(BOOL finished) {
        self.scrollerView.delegate = self;
    }];
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

#pragma mark - 初始化底部菜单
- (void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.size = CGSizeMake(SCR_WIDTH, 49);
    bottomView.y = SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight);
    [self.view addSubview:bottomView];
    
    // 三个按钮
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    commentBtn.frame = CGRectMake(0, 0, bottomView.width / 2 - 25, bottomView.height);
    [commentBtn setImage:[UIImage imageNamed:@"Trail-community"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [commentBtn setTitle:[NSString stringWithFormat:@"%@", self.dataSource[@"commentCount"]] forState:UIControlStateNormal];
    [commentBtn setTitleColor:CZBLACKCOLOR forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:commentBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CZGlobalLightGray;
    lineView.x = 0;
    lineView.y = 0;
    lineView.width = commentBtn.width;
    lineView.height = 1;
    [bottomView addSubview:lineView];

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(commentBtn.width, commentBtn.y, (SCR_WIDTH - commentBtn.width) / 2.0, commentBtn.height);
    buyBtn.titleLabel.font = commentBtn.titleLabel.font;
    [buyBtn setTitle:@"优惠购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = CZREDCOLOR;
    [buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
    
    //2进行中 3试用中，4结束
    NSString *status = self.dataSource[@"status"];
    switch ([status integerValue]) {
        case 2:
        {
            NSInteger applied = [self.dataSource[@"applied"] integerValue];
            status = @"进行中"; // applied是否申请：0未申请，1已申请
            status = applied == 0 ? @"免费申请" : @"分享拉赞";
            break;
        }
        case 3: //3试用中
            status = @"查看名单";
            break;
        case 4:
            status = @"查看试用报告";
            break;
            
        default:
            break;
    }
    
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.listBtn = listBtn;
    listBtn.frame = CGRectMake(CZGetX(buyBtn), buyBtn.y, buyBtn.width, buyBtn.height);
    listBtn.titleLabel.font = commentBtn.titleLabel.font;
    [listBtn setTitle:status forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    listBtn.backgroundColor = UIColorFromRGB(0x4A90E2);
    [listBtn addTarget:self action:@selector(listBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:listBtn];
}

- (UIView *)setupNav 
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, (IsiPhoneX ? 44 + 40 : 20 + 40))];
    topView.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [topView addSubview:leftBtn];
    leftBtn.size = CGSizeMake(60, 40);
    leftBtn.y = (IsiPhoneX ? 44 : 20);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"试用商品";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    titleLabel.textColor = [UIColor blackColor];
    [topView addSubview:titleLabel];
    [titleLabel sizeToFit];
    titleLabel.centerX = topView.width / 2.0;
    titleLabel.centerY = leftBtn.centerY;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"Trail-share-black"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"Trail-share-black"] forState:UIControlStateSelected];

    [rightBtn addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [topView addSubview:rightBtn];
    rightBtn.size = CGSizeMake(60, 40);
    rightBtn.centerY = leftBtn.centerY;
    rightBtn.x = topView.width - rightBtn.width;
    
    return topView;
}


#pragma mark - 事件
/** 跳转评论*/
- (void)commentBtnAction:(UIButton *)sender
{
    CZAllCriticalController *vc = [[CZAllCriticalController alloc] init];
    vc.goodsId = self.trialId;
    vc.type = [CZJIPINSynthesisTool getModuleTypeNumber:CZJIPINModuleTrail];;
    vc.totalCommentCount = self.dataSource[@"commentCount"];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 优惠购买*/
- (void)buyBtnAction:(UIButton *)sender
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
        [self openAlibcTradeWithId:self.dataSource[@"goodsId"]];
    }

    NSString *text = @"试用--商品--优惠购买";
    NSDictionary *context = @{@"goods" : text};
    [MobClick event:@"ID4" attributes:context];
    NSLog(@"----%@", text);
}

- (void)openAlibcTradeWithId:(NSString *)ID
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
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

/** 免费申请*/
- (void)listBtnAction:(UIButton *)sender
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"免费申请"]) {
        NSString *text = @"试用--商品--申请试用";
        NSDictionary *context = @{@"goods" : text};
        [MobClick event:@"ID4" attributes:context];
        NSInteger point = [JPUSERINFO[@"point"] integerValue];
        NSInteger applyPoint = [self.dataSource[@"applyPoint"] integerValue];
        if (point >=  applyPoint) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"商品试用需要支付%ld极币，是否确认参与", applyPoint] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"trialId"] = self.trialId;
                //获取详情数据
                [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/apply"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
                    if ([result[@"code"] isEqual:@(0)] && [result[@"msg"] isEqual:@"success"]) {
                        self.voteShareUrl = result[@"voteShareUrl"];
                        [CZProgressHUD showProgressHUDWithText:@"已提交，赶快去拉赞吧"];
                        [self.listBtn setTitle:@"分享拉赞" forState:UIControlStateNormal];
                    } 
                    //隐藏菊花
                    [CZProgressHUD hideAfterDelay:1.5];
                    
                } failure:^(NSError *error) {
                    //隐藏菊花
                    [CZProgressHUD hideAfterDelay:0];
                }];
            }]];
            [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"极币数不足，请前往获取极币" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"去赚极币" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
                [self.navigationController pushViewController:vc animated:YES
                 ];
            }]];
            
            [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
        }
    } else if ([sender.titleLabel.text isEqualToString:@"查看名单"]) {
        CZvoteUserController *vc = [[CZvoteUserController alloc] init];
        vc.dataSource = self.dataSource;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"查看试用报告"]) {
        CZTrialAllReportHotController *vc = [[CZTrialAllReportHotController alloc] init];
        vc.goodsId = self.trialId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"分享拉赞"]) {
        CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
        share.param = @{
                        @"shareUrl" : self.voteShareUrl,
                        @"shareTitle" : self.dataSource[@"voteShareTitle"],
                        @"shareContent" : self.dataSource[@"voteShareContent"],
                        @"shareImg" : self.dataSource[@"voteShareImg"],
                        };
        [self.view addSubview:share];
    }
}

@end
