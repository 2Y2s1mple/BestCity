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
#import "CZMyPointsController.h"
#import "WMPageController.h"
#import "CZLoginController.h"
#import "GXLuckyDrawController.h"
#import "CZMutContentButton.h"
#import "UIImageView+WebCache.h"

@interface CZMeController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/** 顶部的隐藏的导航栏 */
@property (nonatomic, strong) UIImageView *navImage;
/** 登录按钮加用户名 */
@property (weak, nonatomic) IBOutlet CZMutContentButton *loginBtn;
/** 积分 */
@property (weak, nonatomic) IBOutlet CZMutContentButton *pointBtn;
/** 账户信息 */
@property (nonatomic, strong) NSDictionary *account;
/** 会员级别 */
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;

@end

@implementation CZMeController
#pragma mark - 跳转到的我的积分
- (IBAction)pushMyPointsController:(id)sender {
    CZMyPointsController *vc = [[CZMyPointsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转到我的资料
- (void)pushMyProfileVc
{
    CZMyProfileController *vc = [[CZMyProfileController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
   
}

#pragma mark - 跳转到登陆
- (IBAction)loginAction:(UIButton *)sender {
    CZLoginController *vc = [CZLoginController shareLoginController];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 跳转到抽奖
- (IBAction)pushLuckyDraw:(id)sender {
    GXLuckyDrawController *vc = [[GXLuckyDrawController alloc] init];
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
    self.view.backgroundColor = CZGlobalLightGray;
    // 头像的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMyProfileVc)];
    [self.headImage addGestureRecognizer:tap];
    
    // 设置最上面的导航栏, 实现滑动改变透明效果
    self.navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    _navImage.frame = CGRectMake(0, 0, SCR_WIDTH, 64);
    [self.view addSubview:_navImage];
    self.navImage.alpha = 0;
    
    // 接收登录时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpUserInfo) name:loginChangeUserInfo object:nil];
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
    if (indexPath.section == 0) {
        CZMeCell *cell = [CZMeCell cellWithTabelView:tableView];
        cell.data = _account ? _account : @{};
        return cell;
    } else {
       NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
        CZMeArrowCell *cell =[CZMeArrowCell cellWithTabelView:tableView indexPath:indexPath];
        cell.dataSource = dic;
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 140 : 60;
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
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    if ([dic[@"destinationVC"] isEqualToString:@"CZBalanceController"]) {
        [CZProgressHUD showProgressHUDWithText:@"正在开发中..."];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    UIViewController *vc = [[NSClassFromString(dic[@"destinationVC"]) alloc] init];
  
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= -20 && offsetY <= 0) {
        self.navImage.alpha = (20 - (-offsetY)) / 20.0;
    }
    if (offsetY > 0) {
        self.navImage.alpha = 1;
    }
    if (offsetY < -20) {
        self.navImage.alpha = 0;
    }
}

#pragma mark - 登录通知响应方法
- (void)setUpUserInfo
{
    // 给用户信息赋值
    [self userInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 给用户信息赋值
    [self userInfo];
}

- (void)userInfo
{
    // 账户信息
    _account = [[NSUserDefaults standardUserDefaults] objectForKey:@"Account"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Account"] : @{};
    [self.tableView reloadData];
    
    // 头像
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:USERINFO[@"userNickImg"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    
    // 会员等级
    self.levelLabel.text = [@"V" stringByAppendingFormat:@"%@", USERINFO[@"userMemberGrade"] ? USERINFO[@"userMemberGrade"] : @"0"];
    
    // 用户名字
    if ([USERINFO[@"userNickName"] length] != 0) {
        [self.loginBtn setTitle:USERINFO[@"userNickName"] forState:UIControlStateNormal];
        self.loginBtn.enabled = NO;
        [self.loginBtn setImage:nil forState:UIControlStateNormal];
    } else {
        [self.loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        self.loginBtn.enabled = YES;
        [self.loginBtn setImage:[UIImage imageNamed:@"right-white"] forState:UIControlStateNormal];
        // 调用一下layout方法, 要不尖号位置不对
        [self.loginBtn layoutIfNeeded];
    }
    // 积分
    NSString *point = [[NSUserDefaults standardUserDefaults] objectForKey:@"point"];
    if (point) {
        [self.pointBtn setTitle:[NSString stringWithFormat:@"积分 %@", point] forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
