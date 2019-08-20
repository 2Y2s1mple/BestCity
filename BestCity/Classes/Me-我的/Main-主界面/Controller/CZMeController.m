//
//  CZMeController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeController.h"

#import "CZMeCell.h"
#import "CZMeArrowCell.h"
#import "CZMyProfileController.h"

#import "WMPageController.h"
#import "CZMutContentButton.h"

#import "CZLoginController.h"
#import "CZVoteShowView.h"
#import "UIImageView+WebCache.h"
#import "CZMainAttentionController.h"
#import "CZCoinCenterController.h"
#import "CZUserInfoTool.h"
#import "CZMeIntelligentController.h"// 达人主页


@interface CZMeController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 顶部的隐藏的导航栏 */
@property (nonatomic, strong) UIImageView *navImage;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/** 登录按钮加用户名 */
@property (weak, nonatomic) IBOutlet CZMutContentButton *loginBtn;
/** 邀请码 */
@property (nonatomic, weak) IBOutlet UILabel *invitationCodeLabel;
/** 极币数 */
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
/** 关注 : follow */
@property (nonatomic, weak) IBOutlet UILabel *attentionLabel;
/** 粉丝 */
@property (nonatomic, weak) IBOutlet UILabel *fansLabel;
/** 点赞: vote */
@property (nonatomic, weak) IBOutlet UILabel *voteLabel;
/** 弹出点赞数 */
@property (nonatomic, strong) UIView *backView;
/** 背景图 */
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
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

#pragma mark - 弹出点赞数
- (IBAction)voteBtnAction:(UIButton *)sender {
    NSString *text = @"我的--点赞";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];

    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewHidden)];
    [backView addGestureRecognizer:tap];
    self.backView = backView;

    CZVoteShowView *vc = [CZVoteShowView voteShowView];
    vc.nameLabel.text = JPUSERINFO[@"nickname"];
    
    NSString *number = [NSString stringWithFormat:@"%@", JPUSERINFO[@"voteCount"]];
    NSString *therPrice = [NSString stringWithFormat:@"共获得%@个赞", number];
    vc.numberLabel.attributedText = [therPrice addAttributeColor:[UIColor colorWithRed:246/255.0 green:92/255.0 blue:56/255.0 alpha:1.0] Range:[therPrice rangeOfString:[NSString stringWithFormat:@"%@", number]]];
    
    vc.center = backView.center;
    [backView addSubview:vc];
    
    [self.view addSubview:backView];
}

- (void)backViewHidden
{
    [self.backView removeFromSuperview];
}

#pragma mark - 跳关注
- (IBAction)AttentionAction:(UIButton *)sender {
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

#pragma mark - 跳粉丝
- (IBAction)fansAction:(UIButton *)sender {
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

#pragma mark - 跳转到极币中心
- (IBAction)coinAction:(UIButton *)sender {
    NSString *text = @"我的--极币数";
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
    // 头像的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction:)];
    [self.headImage addGestureRecognizer:tap];
    self.headImage.layer.borderWidth = 2;
    self.headImage.layer.borderColor = CZGlobalWhiteBg.CGColor;
    
    // 设置最上面的导航栏, 实现滑动改变透明效果
//    self.navImage = [[UIImageView alloc] init];
    self.navImage.image = [UIImage imageNamed:@"矩形备份 + 矩形蒙版"];
    _navImage.frame = CGRectMake(0, 0, SCR_WIDTH, 64);
    [self.view addSubview:_navImage];
    self.navImage.alpha = 0;
//    UILabel *mytitle = [[UILabel alloc] init];
//    mytitle.text = @"我的";
//    mytitle.textColor = [UIColor whiteColor];
//    mytitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
//    [self.navImage addSubview:mytitle];
//    [mytitle sizeToFit];
//    mytitle.center = CGPointMake(SCR_WIDTH / 2, 44);

    // 接收登录时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpUserInfo) name:loginChangeUserInfo object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNetworkUserInfo];
    [MobClick beginLogPageView:@"我的我的"]; //("Pagename"为页面名称，可自定义)
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
    
    // 极币数
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"point"]];
    
    // 关注
    self.attentionLabel.text = [NSString stringWithFormat:@"%@",  JPUSERINFO[@"followCount"]];
    
    // 粉丝
    self.fansLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"fansCount"]];
    
    // 点赞
    self.voteLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"voteCount"]];
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
    return indexPath.section == 0 ? 82 : 60;
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
            hotVc.selectIndex = 0;
            hotVc.menuViewStyle = WMMenuViewStyleLine;
            //        hotVc.progressWidth = 30;
            hotVc.itemMargin = 10;
            hotVc.progressHeight = 3;
            hotVc.automaticallyCalculatesItemWidths = YES;
            hotVc.titleFontName = @"PingFangSC-Medium";
            hotVc.titleColorNormal = CZGlobalGray;
            hotVc.titleColorSelected = CZRGBColor(5, 5, 5);
            hotVc.titleSizeNormal = 15.0f;
            hotVc.titleSizeSelected = 15;
            hotVc.progressColor = CZREDCOLOR;
            [self.navigationController pushViewController:hotVc animated:YES];
            return;
        }
        UIViewController *vc = [[NSClassFromString(dic[@"destinationVC"]) alloc] init];
        [self.navigationController pushViewController:vc animated:YES]; 
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY >= 10 && offsetY <= 0) {
//        self.navImage.alpha = (20 - (-offsetY)) / 20.0;
//    }
    if (offsetY > 10) {
        self.navImage.alpha = 1;
    }
    if (offsetY <= 0) {
        self.navImage.alpha = 0;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
