//
//  CZReportCoverController.m
//  BestCity
//
//  Created by JasonBourne on 2019/5/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZReportCoverController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"

@interface CZReportCoverController ()
/** <#注释#> */
@property (nonatomic, strong) UIImageView *imageView;
/** 封面Url */
//@property (nonatomic, strong) NSString *coverUrl;
@end

@implementation CZReportCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];

    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"试用报告" rightBtnTitle:@"保存" rightBtnAction:^{
        [self save];
    } ];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];

    // 添加封面按钮
    UIButton *imageBtn = [[UIButton alloc] init];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    imageBtn.adjustsImageWhenHighlighted = NO;
    imageBtn.x = 10;
    imageBtn.y = 10 + CZGetY(navigationView);
    imageBtn.size = CGSizeMake(135, 135);
    [self.view addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(addCoverImage:) forControlEvents:UIControlEventTouchUpInside];

    //底部发布按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(40, SCR_HEIGHT - 86, SCR_WIDTH - 80, 36);
    publishBtn.layer.cornerRadius = 5;
    publishBtn.layer.masksToBounds = YES;
    [self.view addSubview:publishBtn];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.backgroundColor = CZREDCOLOR;
    [publishBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];

    if ([self.param[@"img"] length] > 0) {
        // 显示控件
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.param[@"img"]]];
        [self creatImageView:imageView];
//        self.coverUrl = self.param[@"img"];
    }
}


#pragma mark - 视图
// 创建图片控件
- (void)creatImageView:(UIImageView *)imageView
{
//    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    imageView.backgroundColor = [UIColor greenColor];
    imageView.y = (IsiPhoneX ? 24 : 0) + 67 + 10;
    imageView.x = 10;
    imageView.width = SCR_WIDTH - 20;
    imageView.height = 200;
//    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];

    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitle:@"更换封面" forState:UIControlStateNormal];
    delete.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    delete.x = imageView.width - 80;
    delete.y = 5;
    delete.size = CGSizeMake(70, 25);
    delete.layer.cornerRadius = 25 / 2.0;
    delete.layer.masksToBounds = YES;
    delete.backgroundColor = CZGlobalGray;
    delete.titleLabel.textColor = CZGlobalWhiteBg;
    [imageView addSubview:delete];

    [delete addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 事件
// 保存
- (void)save
{
    if ([self.param[@"img"] length] < 1) {
        [CZProgressHUD showProgressHUDWithText:@"封面图片不得为空"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/editReport"] body:self.param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {

        }
        [CZProgressHUD showProgressHUDWithText:@"保存草稿箱成功"];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 发布
- (void)publishAction
{
    if ([self.param[@"img"] length] < 1) {
        [CZProgressHUD showProgressHUDWithText:@"封面图片不得为空"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/addReport"] body:self.param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [CZProgressHUD showProgressHUDWithText:@"提交成功"];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }

        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 添加封面
- (void)addCoverImage:(UIButton *)sender
{
    [self openPhoto];
}

// 改变封面图片
- (void)changeAction:(UIButton *)sender
{
    [self openPhoto];
}

// 调用相机
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


        // 上传图片
        [self updataImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updataImage:(UIImage *)image
{
    //上传图片
    [CZProgressHUD showProgressHUDWithText:nil];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/uploadImage"];
    [GXNetTool uploadNetWithUrl:url fileSource:image success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [self.imageView removeFromSuperview];
            self.param[@"img"] = result[@"data"];
            // 显示控件
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self creatImageView:imageView];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"上传失败"];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {

    }];
}


@end
