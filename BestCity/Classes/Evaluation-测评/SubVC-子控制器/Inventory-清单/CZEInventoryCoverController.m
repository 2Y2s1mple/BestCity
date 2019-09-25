//
//  CZEInventoryCoverController.m
//  BestCity
//
//  Created by JasonBourne on 2019/5/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEInventoryCoverController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"

// 视图
#import "CZEInventoryAddGoodsCell.h"
#import "CZEInventoryAddGoodsCellViewMdoel.h"

// 跳转
#import "CZEInventoryAddGoodsController.h"

@interface CZEInventoryCoverController () <UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) UIButton *imageViewBtn;
/** <#注释#> */
@property (nonatomic, strong) UIView *addGoodsView;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 记录选中几件商品 */
@property (nonatomic, strong) UILabel *recordSelecedGoodsLabel;
@end

@implementation CZEInventoryCoverController
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  CZGetY(self.imageViewBtn) + 55, SCR_WIDTH, (SCR_HEIGHT - (IsiPhoneX ? 84 : 50) - (CZGetY(self.imageViewBtn) + 55))) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];

    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"清单编辑" rightBtnTitle:@"发布" rightBtnAction:^{
        [self publishAction];
    }];
    navigationView.rightBtnTextColor = UIColorFromRGB(0xE25838);
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];

    // 添加封面按钮
    UIButton *imageBtn = [[UIButton alloc] init];
    [imageBtn setTitle:@"添加封面" forState:UIControlStateNormal];
    imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageBtn.backgroundColor = UIColorFromRGB(0xD8D8D8);
    [imageBtn setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
    imageBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
    imageBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    imageBtn.x = 0;
    imageBtn.y = CZGetY(navigationView);
    imageBtn.size = CGSizeMake(SCR_WIDTH, 221);
    [self.view addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(addCoverImage:) forControlEvents:UIControlEventTouchUpInside];
    self.imageViewBtn = imageBtn;

    // 添加商品
    self.addGoodsView = [self createAddGoodsView:CZGetY(imageBtn)];
    [self.view addSubview:self.addGoodsView];

    // 添加商品TableView
    [self.view addSubview:self.tableView];
    // 获取关联商品的数据
    [self getGoodsDataSorce];

    //保存草稿箱按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, SCR_HEIGHT - (IsiPhoneX ? 34 : 0) - 50, SCR_WIDTH, 50);
    [self.view addSubview:publishBtn];
    [publishBtn setTitle:@"保存草稿箱" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.backgroundColor = UIColorFromRGB(0xE25838);
    [publishBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];

    if ([self.param[@"img"] length] > 0) {
        // 显示控件
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.param[@"img"]]];
        [self creatImageView:imageView.image];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取关联的数据
    [self getGoodsDataSorce];
    self.recordSelecedGoodsLabel.text = [NSString stringWithFormat:@"已选%d件商品（上限5件）", addGoodsNumber];
    [self.recordSelecedGoodsLabel sizeToFit];
}

- (UIView *)createAddGoodsView:(CGFloat)Y
{
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.y = Y;
    view.width  = SCR_WIDTH;
    view.height = 55;

    UILabel *label= [[UILabel alloc] init];
    label.text = @"添加商品：";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16.5];
    [label sizeToFit];
    label.x = 15;
    label.centerY = view.height / 2.0;
    [view addSubview:label];

    UILabel *subLabel = [[UILabel alloc] init];
    self.recordSelecedGoodsLabel = subLabel;
    subLabel.text = [NSString stringWithFormat:@"已选%d件商品（上限5件）", addGoodsNumber] ;
    subLabel.textColor = UIColorFromRGB(0xD8D8D8);
    subLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16.5];
    [subLabel sizeToFit];
    subLabel.x = CGRectGetMaxX(label.frame) + 10;
    subLabel.centerY = view.height / 2.0;
    [view addSubview:subLabel];

    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"list-right-1"];
    [img sizeToFit];
    img.x = SCR_WIDTH - 15 - 8;
    img.centerY = view.height / 2.0;
    [view addSubview:img];

    UIView *line = [[UIView alloc] init];
    line.y = view.height - 1;
    line.x = 15;
    line.width = SCR_WIDTH - 30;
    line.height = 1;
    line.backgroundColor = UIColorFromRGB(0x979797);
    [view addSubview:line];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGoodsController)];
    [view addGestureRecognizer:tap];

    return view;
}

// 添加商品
- (void)addGoodsController
{
    CZEInventoryAddGoodsController *vc = [[CZEInventoryAddGoodsController alloc] init];
    vc.articleId = self.param[@"articleId"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 视图
// 创建图片控件
- (void)creatImageView:(UIImage *)image
{
    [self.imageViewBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.imageViewBtn setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - 事件
// 保存草稿箱
- (void)save
{
    if (addGoodsNumber == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请添加关联商品"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    if ([self.param[@"img"] length] < 1) {
        [CZProgressHUD showProgressHUDWithText:@"封面图片不得为空"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/saveListing"] body:self.param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"保存成功"];
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:1.5];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"保存失败"];
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:1.5];
        }

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 发布
- (void)publishAction
{
//     if (addGoodsNumber == 0) {
//         [CZProgressHUD showProgressHUDWithText:@"请添加关联商品"];
//         [CZProgressHUD hideAfterDelay:1.5];
//         return;
//     }

    if ([self.param[@"img"] length] < 1) {
        [CZProgressHUD showProgressHUDWithText:@"封面图片不得为空"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/publishListing"] body:self.param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
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

            self.param[@"img"] = result[@"data"];
            [self creatImageView:image];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"上传失败"];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {

    }];
}


#pragma mark - 代理
// 获取关联的数据
- (void)getGoodsDataSorce
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.param[@"articleId"];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/relatedGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = result[@"data"];
            [self.dataSource removeAllObjects];
            for (NSDictionary *dic in list) {
                CZEInventoryAddGoodsCellViewMdoel *viewModel = [[CZEInventoryAddGoodsCellViewMdoel alloc] initWithviewModel:dic];
                viewModel.isSelected = YES;
                viewModel.articleId = self.param[@"articleId"];
                [self.dataSource addObject:viewModel];
            }
            addGoodsNumber = (int)list.count;
            self.recordSelecedGoodsLabel.text = [NSString stringWithFormat:@"已选%d件商品（上限5件）", addGoodsNumber];
            [self.recordSelecedGoodsLabel sizeToFit];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZEInventoryAddGoodsCellViewMdoel *viewModel = self.dataSource[indexPath.row];
    CZEInventoryAddGoodsCell *cell = [CZEInventoryAddGoodsCell cellwithTableView:tableView];
    [cell setBlock:^{
        self.recordSelecedGoodsLabel.text = [NSString stringWithFormat:@"已选%d件商品（上限5件）", addGoodsNumber];
        [self.recordSelecedGoodsLabel sizeToFit];
    }];
    cell.viewModel = viewModel;
    return cell;
}

@end
