//
//  CZMeController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeController.h"
#import "GXNetTool.h"

#import "CZMeCell.h"
#import "CZMeArrowCell.h"
#import "CZMyProfileController.h"

#import "WMPageController.h"
#import "CZMutContentButton.h"

#import "CZLoginController.h"
#import "UIImageView+WebCache.h"
#import "CZMainAttentionController.h"
#import "CZCoinCenterController.h"
#import "CZUserInfoTool.h"
#import "CZMeIntelligentController.h"// 达人主页
#import "CZMePublishController.h"
#import "CZMyWalletController.h" // 我的钱包
#import "CZSubFreePreferentialController.h" // 特惠购

@interface CZMeController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/** 登录按钮加用户名 */
@property (weak, nonatomic) IBOutlet CZMutContentButton *loginBtn;
/** 邀请码 */
@property (nonatomic, weak) IBOutlet UILabel *invitationCodeLabel;
/** 津贴余额 */
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
/** 极币数 */
@property (nonatomic, weak) IBOutlet UILabel *attentionLabel;
/** 收藏 */
@property (nonatomic, weak) IBOutlet UILabel *fansLabel;
/** 团队人数 */
@property (nonatomic, weak) IBOutlet UILabel *voteLabel;
/** 弹出点赞数 */
@property (nonatomic, strong) UIView *backView;
/** 背景图 */
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
/** <#注释#> */
@property (nonatomic, strong) NSString *messageCount;
// 我的补贴
/** 共省 */
@property (nonatomic, weak) IBOutlet UILabel *totalFeeLabel;
/** 可提现 */
@property (nonatomic, weak) IBOutlet UILabel *withdrawLabel;
/** 即将到账 */
@property (nonatomic, weak) IBOutlet UILabel *preFeeLabel;
/** 累计到账 */
@property (nonatomic, weak) IBOutlet UILabel *finalFeeLabel;
@end

@implementation CZMeController
/** 达人页面 */
- (IBAction)pushIntelligen
{
    CZMeIntelligentController *vc = [[CZMeIntelligentController alloc] init];
    vc.freeID = JPUSERINFO[@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 复制到剪切板 */
- (IBAction)generalPaste
{
    NSString *text = @"我的--点击复制（邀请码）";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];

    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = JPUSERINFO[@"invitationCode"];
    [CZProgressHUD showProgressHUDWithText:@"复制成功"];
    [CZProgressHUD hideAfterDelay:1.5];
}

#pragma mark - 团队人数
- (IBAction)voteBtnAction:(UIButton *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZMeTeamMembersController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

// 收藏夹
- (void)pushVoteBtnAction
{
    WMPageController *hotVc = (WMPageController *)[[NSClassFromString(@"CZCollectController") alloc] init];
    [self.navigationController pushViewController:hotVc animated:YES];
}

#pragma mark - 我的钱包, 我的补贴
- (IBAction)walletAction:(UIButton *)sender {
    NSString *text = @"我的--我的钱包";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    // 跳钱包
    CZMyWalletController *toVc = [[CZMyWalletController alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

// 跳关注
- (void)pushAttentionAction
{
    NSString *text = @"我的--关注";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    WMPageController *hotVc = [[CZMainAttentionController alloc] init];
    hotVc.selectIndex = 0;
    hotVc.menuViewStyle = WMMenuViewStyleLine;
    //        hotVc.progressWidth = 30;
    hotVc.itemMargin = 10;
    hotVc.progressHeight = 3;
    hotVc.automaticallyCalculatesItemWidths = YES;
    hotVc.titleFontName = @"PingFangSC-Medium";
    hotVc.titleColorNormal = CZGlobalGray;
    hotVc.titleColorSelected = CZREDCOLOR;
    hotVc.titleSizeNormal = 15.0f;
    hotVc.titleSizeSelected = 15;
    hotVc.progressColor = CZREDCOLOR;
    [self.navigationController pushViewController:hotVc animated:YES];
}

#pragma mark - 跳收藏
- (IBAction)fansAction:(UIButton *)sender {
    [self pushVoteBtnAction];
}

// 粉丝
- (void)pushFans
{
    NSString *text = @"我的--粉丝";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    WMPageController *hotVc = [[CZMainAttentionController alloc] init];
    hotVc.selectIndex = 1;
    hotVc.menuViewStyle = WMMenuViewStyleLine;
    //        hotVc.progressWidth = 30;
    hotVc.itemMargin = 10;
    hotVc.progressHeight = 3;
    hotVc.automaticallyCalculatesItemWidths = YES;
    hotVc.titleFontName = @"PingFangSC-Medium";
    hotVc.titleColorNormal = CZGlobalGray;
    hotVc.titleColorSelected = CZREDCOLOR;
    hotVc.titleSizeNormal = 15.0f;
    hotVc.titleSizeSelected = 15;
    hotVc.progressColor = CZREDCOLOR;
    [self.navigationController pushViewController:hotVc animated:YES];
}

#pragma mark - 跳我的资料
- (IBAction)loginAction:(UIButton *)sender {
    NSString *text = @"我的--点赞";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];

    CZMyProfileController *vc = [[CZMyProfileController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 跳转特惠购
- (IBAction)gotoPreferentialController
{
    CZSubFreePreferentialController *vc = [[CZSubFreePreferentialController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 极币数
- (IBAction)AttentionAction:(UIButton *)sender {
    [self pushCoinAction];
}

#pragma mark - 跳转到极币中心
- (IBAction)coinAction:(UIButton *)sender {
    [self pushCoinAction];
}

// 跳转到极币中心
- (void)pushCoinAction
{
    NSString *text = @"我的--极币中心";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 从plist文件加载数据 */
- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CZMeArrow.plist" ofType:nil];
        _dataSource = [NSArray arrayWithContentsOfFile:path];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = CZGlobalLightGray;
    // 设置样式
    [self setPropertyStyle];

    // 头像的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction:)];
    [self.headImage addGestureRecognizer:tap];
    self.headImage.layer.borderWidth = 2;
    self.headImage.layer.borderColor = CZGlobalWhiteBg.CGColor;

    // 接收登录时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpUserInfo) name:loginChangeUserInfo object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取用户数据
    [self getNetworkUserInfo];
    // 获取消息数
    [self getMessageCount];
    // 获取佣金数据
    [self getCommssionSummary];
    [MobClick beginLogPageView:@"我的我的"]; //("Pagename"为页面名称，可自定义)

    [self.tableView reloadData];
}

#pragma mark - 设置属性样式
- (void)setPropertyStyle {
    // 津贴余额 // 关注
    self.attentionLabel.font = self.voteLabel.font = self.fansLabel.font = self.moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];;
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的我的"];
}

#pragma mark - 获取用户信息
- (void)getNetworkUserInfo
{
    __weak typeof(self) weakSelf = self;
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {
        [weakSelf setUpUserInfo];
    }];
}

#pragma mark - 获取佣金
- (void)getCommssionSummary
{
    [CZUserInfoTool userInfoCommssionCallback:^(NSDictionary *param) {
        /** 共省 */
        self.totalFeeLabel.text = [NSString stringWithFormat:@"共省¥%@", param[@"totalFee"]];
        /** 可提现 */
        self.withdrawLabel.text = [NSString stringWithFormat:@"¥%@", param[@"withdraw"]];
        /** 即将到账 */
        self.preFeeLabel.text = [NSString stringWithFormat:@"¥%@", param[@"preFee"]];
        /** 累计到账 */
        self.finalFeeLabel.text = [NSString stringWithFormat:@"¥%@", param[@"finalFee"]];
    }];
}
#pragma mark - 登录时候的通知
- (void)setUpUserInfo
{
    // 给用户信息赋值
    // 背景图
    if ([JPUSERINFO[@"bgImg"] length] > 10) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:JPUSERINFO[@"bgImg"]]];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"矩形备份 + 矩形蒙版"];
    }

    // 头像
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:JPUSERINFO[@"avatar"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    
    // 用户名字
    [self.loginBtn setTitle:JPUSERINFO[@"nickname"] forState:UIControlStateNormal];
    self.loginBtn.enabled = YES;
    [self.loginBtn setImage:nil forState:UIControlStateNormal];
    
    // 邀请码
    self.invitationCodeLabel.text = [NSString stringWithFormat:@"邀请码：%@", JPUSERINFO[@"invitationCode"]];
    
    // 津贴余额
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"allowance"]];
    
    // 极币数
    self.attentionLabel.text = [NSString stringWithFormat:@"%@",  JPUSERINFO[@"point"]];
    
    // 收藏数
    self.fansLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"collectCount"]];
    
    // 团队人数
    self.voteLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"teamCount"]];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        CZMeCell *cell = [CZMeCell cellWithTabelView:tableView];
        return cell;
    } else {
        CZMeArrowCell *cell =[CZMeArrowCell cellWithTabelView:tableView indexPath:indexPath];
        cell.dataSource = dic;
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 82;
    } else {
        return 205;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 15 : 0;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSDictionary *dic = self.dataSource[1][indexPath.row];
        NSString *text = [NSString stringWithFormat:@"我的--%@",  dic[@"title"]];
        NSDictionary *context = @{@"mine" : text};
        [MobClick event:@"ID5" attributes:context];

        if ([dic[@"destinationVC"] isEqualToString:@"CZCollectController"]) {
            WMPageController *hotVc = (WMPageController *)[[NSClassFromString(dic[@"destinationVC"]) alloc] init];
            [self.navigationController pushViewController:hotVc animated:YES];
            return;
        }
        UIViewController *vc = [[NSClassFromString(dic[@"destinationVC"]) alloc] init];
        [self.navigationController pushViewController:vc animated:YES]; 
    };
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getMessageCount
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/message/count"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            self.messageCount = [NSString stringWithFormat:@"%@", [result[@"data"] integerValue] < 99 ? result[@"data"] : @"99+"];
            [self.tableView reloadData];
        } else {

        }
    } failure:^(NSError *error) {}];
}

@end
