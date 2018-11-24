//
//  CZMyProfileController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMyProfileController.h"
#import "CZNavigationView.h"
#import "CZMyProfileCell.h"
#import "UIButton+CZExtension.h"
#import "CZChangeNicknameController.h"
#import "CZMembershipController.h"
#import "CZDatePickView.h"
#import "CZBindingMobileController.h"
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "CZUserInfoTool.h"
#import "CZAlertViewTool.h"
#import "CZLoginController.h"

@interface CZMyProfileController () <UITableViewDelegate, UITableViewDataSource, CZDatePickViewDelegate, CZChangeNicknameControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 左侧标题的数组 */
@property (nonatomic, strong) NSArray *leftTitles;
/** 右侧的副标题 */
@property (nonatomic, strong) NSMutableArray *rightTitles;

@end

@implementation CZMyProfileController

- (NSArray *)leftTitles
{
    if (_leftTitles == nil) {
        _leftTitles = @[@"头像", @"昵称", @"会员等级", @"性别", @"生日", @"绑定手机"];
    }
    return _leftTitles;
}

- (NSMutableArray *)rightTitles
{
    if (_rightTitles == nil) {
        // 用户信息
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        if ([userInfo[@"userBirthday"] length] >= 10) {
            NSString *dataStr = [userInfo[@"userBirthday"] substringToIndex:10];
            _rightTitles = [NSMutableArray arrayWithArray:@[userInfo[@"userNickImg"], userInfo[@"userNickName"], userInfo[@"userMemberGrade"], userInfo[@"userGender"], dataStr, userInfo[@"userPhone"]]];
        }
    }
    return _rightTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"我的资料" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, SCR_HEIGHT - 68) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //底部退出按钮
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(0, SCR_HEIGHT - 50, SCR_WIDTH, 50);
    [self.view addSubview:loginOut];
    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZREDCOLOR;
    [loginOut addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
}

/** 退出登录 */
- (void)loginOutAction
{
    [CZAlertViewTool showAlertWithTitle:@"确认退出" action:^{
        // 删除用户信息
        [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"user"];
        // 删除积分
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"point"];
        // 删除账户余额信息
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Account"];
        // 返回上一页
        CZLoginController *vc = [[CZLoginController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma  mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 头像
        CZMyProfileCell *cell = [CZMyProfileCell cellWithTableView:tableView cellType:CZMyProfileCellTypeDefault];
        cell.headerImage = self.rightTitles[indexPath.row];;
        return cell;
    } else {
        CZMyProfileCell *cell = [CZMyProfileCell cellWithTableView:tableView cellType:CZMyProfileCellTypeSubTitle];
        cell.title = self.leftTitles[indexPath.row];
        cell.subTitle = self.rightTitles[indexPath.row];
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.leftTitles[indexPath.row] isEqualToString:@"昵称"]) {
        //跳转到修改昵称
        CZChangeNicknameController *vc = [[CZChangeNicknameController alloc] init];
        CZMyProfileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        vc.name = cell.subTitle;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES]; 
    } else if ([self.leftTitles[indexPath.row] isEqualToString:@"会员等级"]) {
        //跳转到会员等级
        CZMembershipController *vc = [[CZMembershipController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.leftTitles[indexPath.row] isEqualToString:@"生日"]) {
        NSString *dataStr = [self.rightTitles[indexPath.row] substringToIndex:10];
        CZDatePickView *backView = [CZDatePickView datePickWithCurrentDate:dataStr type:CZDatePickViewTypeDate];
        backView.delegate = self;
        [self.view addSubview:backView];
    } else if ([self.leftTitles[indexPath.row] isEqualToString:@"性别"]) {
        CZDatePickView *backView = [CZDatePickView datePickWithCurrentDate:self.rightTitles[indexPath.row] type:CZDatePickViewTypeOther];
        backView.delegate = self;
        [self.view addSubview:backView];
    } else if ([self.leftTitles[indexPath.row] isEqualToString:@"绑定手机"]) {
        CZBindingMobileController *vc = [[CZBindingMobileController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        //
        [self openPhoto];
    }
}

#pragma mark - <CZDatePickViewDelegate>
- (void)datePickView:(CZDatePickView *)pickView selectedDate:(NSString *)dateString
{
    if (dateString.length > 0 && pickView.type == CZDatePickViewTypeDate) {
        // 修改生日
        [self changeUserInfo:@{@"userBirthday" : dateString}];
    } else if (dateString.length > 0) {
        // 修改性别
        [self changeUserInfo:@{@"userGender" : dateString}];
        
    }
}

#pragma mark - <CZChangeNicknameControllerDelegate>
- (void)updateUserInfo
{
    [self getUserInfo];
}

#pragma mark - 获取用户信息
- (void)getUserInfo
{
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {
        self.rightTitles = nil;
        [self.tableView reloadData];
    }];
}

#pragma mark - 修改用户信息
- (void)changeUserInfo:(NSDictionary *)info
{
    [CZUserInfoTool changeUserInfo:info callbackAction:^(NSDictionary *param) {
        // 获取用户信息
        [self getUserInfo];
    }];
}

#pragma mark - 调用相机
- (void)openPhoto
{
    // 创建弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        //判断是否可以打开照相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 创建相机类
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES; //可编辑
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            NSLog(@"没有摄像头");
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // 创建相机类
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
             NSLog(@"打开相册");
            [self presentViewController:picker animated:YES
                             completion:nil];
        } else {
            NSLog(@"不能打开相册");
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -<UIImagePickerControllerDelegate> 拍照完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera || picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        //上传图片
        NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/importCustomer"];
        [GXNetTool uploadNetWithUrl:url fileSource:image success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
               [self changeUserInfo:@{@"userNickImg" : result[@"userNickImg"]}];
                [[NSUserDefaults standardUserDefaults] setObject:result[@"userNickImg"] forKey:@"userNickImg"];
            } else {
                [CZProgressHUD showProgressHUDWithText:@"修改失败"];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
