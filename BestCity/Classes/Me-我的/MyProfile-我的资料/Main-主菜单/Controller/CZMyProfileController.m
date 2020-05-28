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
#import "UIImageView+WebCache.h"
#import "CZChangeNicknameController.h"
#import "CZDatePickView.h"
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "CZUserInfoTool.h"
#import "CZAlertViewTool.h"
#import "CZLoginController.h"
#import "CZAdministratorAccountController.h"

#import "CZChangeSignController.h" // 个性签名

@interface CZMyProfileController () <UITableViewDelegate, UITableViewDataSource, CZDatePickViewDelegate, CZChangeNicknameControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 左侧标题的数组 */
@property (nonatomic, strong) NSArray *leftTitles;
/** 右侧的副标题 */
@property (nonatomic, strong) NSMutableArray *rightTitles;
/** <#注释#> */
@property (nonatomic, strong) UIButton *popButton;
/** <#注释#> */
@property (nonatomic, assign) BOOL isChangeBackground;
/** 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 背景图 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation CZMyProfileController

- (NSArray *)leftTitles
{
    if (_leftTitles == nil) {
        _leftTitles = @[@"昵称", @"个性签名", @"性别", @"生日", @"账号管理"];
    }
    return _leftTitles;
}

- (NSMutableArray *)rightTitles
{
    if (_rightTitles == nil) {
        // 用户信息
        NSDictionary *userInfo = JPUSERINFO;
        _rightTitles = [NSMutableArray arrayWithArray:@[                                                                       userInfo[@"nickname"],
                                                        userInfo[@"detail"],
                                                        userInfo[@"gender"],
                                                        userInfo[@"birthday"], 
                                                        userInfo[@"mobile"]
                                                        ]];
    }
    return _rightTitles;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUserInfo];
}

- (UIView *)tableViewHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 228)];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.width = headerView.width;
    imageView.height = headerView.height;
    self.backgroundImageView = imageView;

    if ([JPUSERINFO[@"bgImg"] length] > 10) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:JPUSERINFO[@"bgImg"]]];
    } else {
        imageView.image = [UIImage imageNamed:@"矩形备份 + 矩形蒙版"];
    }
    [headerView addSubview:imageView];

    _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"back-white" target:self action:@selector(popAction)];
    [headerView addSubview:_popButton];


    UIImageView *iconImageView = [[UIImageView alloc] init];
    self.iconImageView = iconImageView;
    iconImageView.backgroundColor = RANDOMCOLOR;
    iconImageView.size = CGSizeMake(116, 116);
    iconImageView.center = CGPointMake(headerView.width / 2.0, headerView.height / 2.0);
    iconImageView.layer.cornerRadius = 58;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.borderWidth = 2;
    iconImageView.layer.borderColor = CZGlobalWhiteBg.CGColor;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:JPUSERINFO[@"avatar"]]];
    [headerView addSubview:iconImageView];

    // 设置头像
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    phoneBtn.size = CGSizeMake(36, 36);
    phoneBtn.x = headerView.width / 2.0 + 8;
    phoneBtn.y = headerView.height / 2.0 + 25;
    [headerView addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(iconPhone) forControlEvents:UIControlEventTouchUpInside];

    UIButton *backgroundBtn = [[UIButton alloc] init];
    [backgroundBtn setImage:[UIImage imageNamed:@"相机备份"] forState:UIControlStateNormal];
    [backgroundBtn setTitle:@"设置封面" forState:UIControlStateNormal];
    backgroundBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backgroundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backgroundBtn.layer.cornerRadius = 5;
    backgroundBtn.layer.masksToBounds = YES;
    backgroundBtn.layer.borderWidth = 1;
    backgroundBtn.layer.borderColor = [UIColor blackColor].CGColor;
    backgroundBtn.size = CGSizeMake(90, 30);
    backgroundBtn.x = 15;
    backgroundBtn.y = headerView.height - 15 - 30;
    [headerView addSubview:backgroundBtn];
    [backgroundBtn addTarget:self action:@selector(backgroundPhone) forControlEvents:UIControlEventTouchUpInside];



    return headerView;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 获取数据
    [self getUserInfo];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableViewHeaderView];
    
//    //底部退出按钮
//    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
//    loginOut.frame = CGRectMake(0, SCR_HEIGHT - 50, SCR_WIDTH, 50);
//    [self.view addSubview:loginOut];
//    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
//    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
//    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    loginOut.backgroundColor = CZREDCOLOR;
//    [loginOut addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
}

/** 退出登录 */
- (void)loginOutAction
{
    [CZAlertViewTool showAlertWithTitle:@"确认退出" action:^{
        // 参数
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/logout"];
        // 请求
        [GXNetTool PostNetWithUrl:url body:@{} bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {} failure:^(NSError *error) {}];
        // 删除用户信息
        [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"user"];
        // 删除token
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
        // 返回上一页
        CZLoginController *vc = [CZLoginController shareLoginController];
        vc.isLogin = NO;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma  mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == 4) {
        CZMyProfileCell *cell = [CZMyProfileCell cellWithTableView:tableView cellType:2];
        cell.title = self.leftTitles[indexPath.row];
        cell.subTitle = self.rightTitles[indexPath.row];
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
    } else if ([self.leftTitles[indexPath.row] isEqualToString:@"生日"]) {
        NSString *dataStr = [self.rightTitles[indexPath.row] substringToIndex:10];
        CZDatePickView *backView = [CZDatePickView datePickWithCurrentDate:dataStr type:CZDatePickViewTypeDate];
        backView.delegate = self;
        [self.view addSubview:backView];
    } else if ([self.leftTitles[indexPath.row] isEqualToString:@"性别"]) {
        CZDatePickView *backView = [CZDatePickView datePickWithCurrentDate:self.rightTitles[indexPath.row] type:CZDatePickViewTypeOther];
        backView.delegate = self;
        [self.view addSubview:backView];
    } else if ([self.leftTitles[indexPath.row] isEqualToString:@"账号管理"]) {
        CZAdministratorAccountController *vc = [[CZAdministratorAccountController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.leftTitles[indexPath.row] isEqualToString:@"个性签名"]) {
        CZChangeSignController *vc = [[CZChangeSignController alloc] init];
        CZMyProfileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        vc.name = cell.subTitle;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //
        [self openPhoto];
    }
}

#pragma mark - <CZDatePickViewDelegate>
- (void)datePickView:(CZDatePickView *)pickView selectedDate:(NSString *)dateString
{
    if (dateString.length > 0 && pickView.type == CZDatePickViewTypeDate) {
        // 修改生日
        [self changeUserInfo:@{@"birthday" : dateString}];
    } else if (dateString.length > 0) {
        // 修改性别
        [self changeUserInfo:@{@"gender" : dateString}];
        
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
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:JPUSERINFO[@"avatar"]]];

        if ([JPUSERINFO[@"bgImg"] length] > 10) {
            [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:JPUSERINFO[@"bgImg"]]];
        } else {
            self.backgroundImageView.image = [UIImage imageNamed:@"矩形备份 + 矩形蒙版"];
        }

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
- (void)backgroundPhone
{
    self.isChangeBackground = YES;
    [self openPhoto];
}

- (void)iconPhone
{
    self.isChangeBackground = NO;
    [self openPhoto];
}


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
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/uploadImage"];
        [GXNetTool uploadNetWithUrl:url fileSource:image success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                NSString *url = result[@"data"];
                if (self.isChangeBackground) {
                    [self changeUserInfo:@{@"bgImg" : url}];
                } else {
                    [self changeUserInfo:@{@"avatar" : url}];
                }
            } else {
                [CZProgressHUD showProgressHUDWithText:@"修改失败"];
                [CZProgressHUD hideAfterDelay:1];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
