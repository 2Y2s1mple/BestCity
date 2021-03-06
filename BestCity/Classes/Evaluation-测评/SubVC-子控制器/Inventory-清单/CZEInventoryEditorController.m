//
//  CZEInventoryEditorController.m
//  BestCity
//
//  Created by JasonBourne on 2019/5/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEInventoryEditorController.h"
#import "CZNavigationView.h"
#import "CZEditorTextView.h"
#import "GXNetTool.h"
#import "CZEInventoryCoverController.h"
#import "CZEditorImageView.h"
#import "UIImageView+WebCache.h"

@interface CZEInventoryEditorController () <UITextViewDelegate>
/** 顶部按钮 */
@property (nonatomic, strong) UIButton *topBtn;
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *tool;
/** 记录标题 */
@property (nonatomic, strong) NSString *recordText;
/** 标题文本框 */
@property (nonatomic, strong) CZEditorTextView *textView;
/** 控件数组 */
@property (nonatomic, strong) NSMutableArray *moduleArray;
/** 记录第二个文本控件的Y值 */
@property (nonatomic, assign) CGFloat recordY;
/** 封面Url */
@property (nonatomic, strong) NSString *coverUrl;
/** 记录参数 */
@property (nonatomic, strong) NSMutableDictionary *param;

/** 多次点击 */
@property (nonatomic, assign) BOOL isManyTimesClick;
@end

@implementation CZEInventoryEditorController
- (NSMutableArray *)moduleArray
{
    if (_moduleArray == nil) {
        _moduleArray = [NSMutableArray array];
    }
    return _moduleArray;
}

- (NSMutableDictionary *)param
{
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (UIButton *)topBtn
{
    if (_topBtn == nil) {
        CGFloat space = 14.0f;
        _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 40)];
        _topBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        CGRect rect = [self.remarkStr boundingRectWithSize:CGSizeMake(SCR_WIDTH - 2 * space, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : _topBtn.titleLabel.font} context:nil];
        CGFloat _hei = MAX(40, rect.size.height + 20);
        _topBtn.height = _hei;
        [_topBtn setTitle:self.remarkStr forState:UIControlStateNormal];
        _topBtn.backgroundColor = UIColorFromRGB(0xE25838);
        [_topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _topBtn;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.width = SCR_WIDTH;
        _scrollView.height = SCR_HEIGHT;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    // 从草稿箱获取数据
    [self getDataSource];

    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"清单编辑" rightBtnTitle:@"下一步" rightBtnAction:^{
        if (!self.isManyTimesClick) {
            // 跳转报告封面
            [self isCompliance];
        }
    } ];
    navigationView.rightBtnTextColor = UIColorFromRGB(0xE25838);
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    if (self.remarkStr.length > 3) {
        [self.view addSubview:self.topBtn];
        self.topBtn.y = CZGetY(navigationView);
        self.scrollView.y = CZGetY(self.topBtn);
    } else {
        self.scrollView.y = CZGetY(navigationView);
    }

    self.scrollView.height = SCR_HEIGHT - CZGetY(navigationView);
    [self.view addSubview:self.scrollView];

    // 顶部标题
    [self setupTitle:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    // 工具栏
    [self.view addSubview:[self setupTool]];
}

#pragma mark - 视图
// 最上面的标题文本框
- (void)setupTitle:(CGFloat)Y
{
    CZEditorTextView *textView = [[CZEditorTextView alloc] init];
    self.textView = textView;
    [textView setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 17]];
    textView.placeHolder = @"输入标题，20字左右阅读体验最佳";
    textView.x = 15;
    textView.y = Y + 10;
    textView.width = SCR_WIDTH - 30;
    textView.height = 70;
    [self.scrollView addSubview:textView];


    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CZGetY(textView) + 10, SCR_WIDTH - 30, 0.7)];
    line.backgroundColor = UIColorFromRGB(0x979797);
    [self.scrollView addSubview:line];

    UILabel *label = [[UILabel alloc] init];
    label.x = SCR_WIDTH - 20 - 35;
    label.y = CZGetY(line) - 25;
    [self.scrollView addSubview:label];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    label.textColor = CZGlobalGray;
    label.text = @"0/36";
    label.numberOfLines = 1;
    [label sizeToFit];
    __block CZEditorTextView *blockTextView = textView;
    textView.titleTextBlock = ^(NSString *text) {
        if (blockTextView.text.length <= 36) {
            label.text = [NSString stringWithFormat:@"%ld/36", text.length];
            [label sizeToFit];
            self.recordText = text;
        } else {
            blockTextView.text = self.recordText;
        }
    };

    // 创建第二行文字输入
    self.recordY = CZGetY(line);
    UIView *modulView = [self setupContentText:self.recordY];
    [self.moduleArray addObject:modulView];
    [self.scrollView addSubview:modulView];

    self.scrollView.contentSize = CGSizeMake(0, SCR_HEIGHT + 10);
}

// 工具栏
- (UIView *)setupTool
{
    UIView *tool = [[UIView alloc] init];
    self.tool = tool;
    tool.width = SCR_HEIGHT;
    tool.height = 49;
    tool.y = SCR_HEIGHT - 49;
    tool.backgroundColor = CZGlobalLightGray;
    UIButton *imageView1 = [[UIButton alloc] init];
    [imageView1 setBackgroundImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
    imageView1.size = CGSizeMake(25, 25);
    imageView1.x = 20;
    imageView1.centerY = tool.height / 2.0;
    [imageView1 addTarget:self action:@selector(addTextView:) forControlEvents:UIControlEventTouchUpInside];

    [tool addSubview:imageView1];

    UIButton *imageView2 = [[UIButton alloc] init];
    [imageView2 setBackgroundImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    imageView2.size = CGSizeMake(25, 25);
    imageView2.x = CZGetX(imageView1) + 40;
    imageView2.centerY = tool.height / 2.0;
    [tool addSubview:imageView2];
    [imageView2 addTarget:self action:@selector(addImageView:) forControlEvents:UIControlEventTouchUpInside];

    return tool;
}

#pragma mark - 添加的文本控件
- (UIView *)setupContentText:(CGFloat)Y
{
    UIView *view = [[UIView alloc] init];
    view.y = Y;
    view.width = SCR_WIDTH;
    view.height = 67;

    CZEditorTextView *textView = [[CZEditorTextView alloc] init];
    textView.placeHolder = @"添加正文，使用工具栏A可以给文章设置段落标题，给文章分段，使文章表达更清晰";
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    textView.x = 15;
    textView.y = 15;
    textView.width = SCR_WIDTH - 30;
    textView.height = 57;
    [view addSubview:textView];
    __block UIView *blockView = view;
    __block CZEditorTextView *blockTextView = textView;
    textView.textBlock = ^(NSString *text, CGFloat height) {
        NSLog(@"%f", height);
        blockTextView.height = MAX(height + 10, 57);
        blockView.height = CZGetY(blockTextView);
        [self relaodView];
    };
    return view;
}

#pragma mark - 创建图片控件
- (void)creatImageView:(CZEditorImageView *)imageView
{
    UIView *lastView = [self.moduleArray lastObject];
    CGFloat originY;
    CZEditorTextView *textView = [lastView.subviews lastObject];
    if (self.moduleArray.count == 1 && [textView isKindOfClass:[UITextView class]] && textView.text.length == 0) {
        originY = CGRectGetMinY(lastView.frame);
        [textView removeFromSuperview];
        [self.moduleArray removeObject:lastView];
    } else if (self.moduleArray.count == 0) {
        originY = self.recordY;
    } else {
        originY = CZGetY(lastView);
    };
    NSLog(@"-------%f", originY);
    imageView.y = originY + 15;
    imageView.x = 15;
    imageView.width = SCR_WIDTH - 30;
    if (imageView.image ) {
        imageView.height = imageView.image.size.height * imageView.width / imageView.image.size.width;
    }
    NSLog(@"%@", NSStringFromCGSize(imageView.size));
    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;


    UIButton *delete = [[UIButton alloc] init];
    [delete setImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
    delete.size = CGSizeMake(30, 30);
    delete.center = CGPointMake(imageView.width - 3, 3);
    [imageView addSubview:delete];

    [delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];

    self.scrollView.contentSize = CGSizeMake(0, MAX(CZGetY(imageView) + 360, SCR_HEIGHT + 10));
    [self.moduleArray addObject:imageView];
    [self.scrollView addSubview:imageView];
}


#pragma mark - 事件

// 监听键盘
- (void)keyboardShow:(NSNotification *)sender
{
    CGRect rect = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.tool.transform = CGAffineTransformMakeTranslation(0,  rect.origin.y - SCR_HEIGHT);
    }];
}

- (void)keyboardHide:(NSNotification *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.tool.transform = CGAffineTransformMakeTranslation(0,  0);
    }];
    UIView *lastView = [self.moduleArray lastObject];
    CGFloat originY = CZGetY(lastView);;
    self.scrollView.contentSize = CGSizeMake(0, MAX(originY + 360, SCR_HEIGHT + 10));
}

// 添加文字控件
- (CZEditorTextView *)addTextView:(UIButton *)sender
{
    UIView *lastView = [self.moduleArray lastObject];
    CGFloat originY;
    CZEditorTextView *textView = [lastView.subviews lastObject];
    if ([textView isKindOfClass:[UITextView class]]) {
        [textView becomeFirstResponder];
        return textView;
    } if (self.moduleArray.count == 0) {
        originY = self.recordY;
    } else {
        originY = CZGetY(lastView);
    };
    NSLog(@"-------%f", originY);
    UIView *currentView = [self setupContentText:originY];
    self.scrollView.contentSize = CGSizeMake(0, MAX(CZGetY(currentView) + 360, SCR_HEIGHT + 10));
    [self.moduleArray addObject:currentView];
    [self.scrollView addSubview:currentView];

    if ([textView isKindOfClass:[UITextView class]]) {
        return textView;
    } else {
        return [currentView.subviews lastObject];
    }
}

// 添加图片
- (void)addImageView:(UIButton *)sender
{
    [self openPhoto];
}

// 删除图片
- (void)deleteAction:(UIButton *)sender
{
    NSLog(@"----------");
    UIImageView *lastView = (UIImageView *)sender.superview;
    [lastView removeFromSuperview];
    [self.moduleArray removeObject:lastView];
    [self relaodView];
}

#pragma mark - 业务功能
// 判断报告是否符合要求
- (void)isCompliance
{
    NSMutableArray *textArray = [NSMutableArray array];
    NSMutableArray *imagesArray = [NSMutableArray array];

    NSMutableArray *contentArr = [NSMutableArray array];
    for (UIView *subView in self.moduleArray) {
        CZEditorTextView *textView = [subView.subviews lastObject];
        if ([textView isKindOfClass:[UITextView class]]) {
            if (textView.text.length == 0) continue;
            [textArray addObject:textView];
            NSDictionary *dic = @{
                                  @"type" : @"1",
                                  @"height" : @(0),
                                  @"width" : @(0),
                                  @"value" : textView.text
                                  };
            [contentArr addObject:dic];
        }
        if ([subView isKindOfClass:[CZEditorImageView class]]) {
            [imagesArray addObject:subView];
            CZEditorImageView *imageView = (CZEditorImageView *)subView;
            NSDictionary *dic = @{
                                  @"type" : @"2",
                                  @"height" : @(imageView.height),
                                  @"width" : @(imageView.width),
                                  @"value" : imageView.urlPath
                                  };
            [contentArr addObject:dic];
        }   
    }

    NSMutableString *string = [[NSMutableString alloc] init];
    for (CZEditorTextView *textView in textArray) {
        [string appendString:textView.text];
    }
    if (string.length < 100) {
        [CZProgressHUD showProgressHUDWithText:@"正文文字不得小于100字"];
        [CZProgressHUD hideAfterDelay:1.5];
    } else if (imagesArray.count < 1) {
        [CZProgressHUD showProgressHUDWithText:@"内容图片数量应大于一张"];
        [CZProgressHUD hideAfterDelay:1.5];
    } else if (self.recordText.length < 1) {
        [CZProgressHUD showProgressHUDWithText:@"请输入标题"];
        [CZProgressHUD hideAfterDelay:1.5];
    } else {
        NSData *data = [NSJSONSerialization dataWithJSONObject:contentArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.isManyTimesClick = YES;
        self.param[@"title"] = self.recordText;
        self.param[@"content"] = string;
        self.param[@"img"] = self.coverUrl;
        if ([self.param[@"articleId"] length] < 1) {
            [self save:self.param];
        } else {
            CZEInventoryCoverController *vc = [[CZEInventoryCoverController alloc] init];
            vc.param = self.param;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)save:(NSMutableDictionary *)param
{
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/saveListing"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.isManyTimesClick = NO;
            // 跳转下一步
//            为了获取articleId
            if ([param[@"articleId"] length] < 1) {
                param[@"articleId"] = result[@"data"][@"articleId"];
            }
            CZEInventoryCoverController *vc = [[CZEInventoryCoverController alloc] init];
            vc.param = param;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            self.isManyTimesClick = NO;
            // 跳转报告封面
            [CZProgressHUD showProgressHUDWithText:@"获取信息失败"];
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:1.5];
        }

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        self.isManyTimesClick = NO;
    }];
}

// 更新视图
- (void)relaodView
{
    for (int i = 0; i < self.moduleArray.count; i++) {
        UIView *subView = self.moduleArray[i];
        if (i > 0) {
            UIView *lastView = self.moduleArray[i - 1];
            subView.y = CZGetY(lastView) + 15;
        } else {
            subView.y = self.recordY;
        }
    }
}

#pragma mark - 获取数据

// 获取数据
- (void)getDataSource
{
    [CZProgressHUD showProgressHUDWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.trialId;
    param[@"type"] = @"7";
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/article/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"------%@ -----%@", [result[@"data"] class], [@"33" class]);
            if (![result[@"data"] isKindOfClass:[NSString class]]) {
                [self relaodAllView:result[@"data"]];
                self.coverUrl = result[@"data"][@"img"];
                self.param[@"articleId"] = result[@"data"][@"articleId"];
            }
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 如果有数据赋值
- (void)relaodAllView:(NSDictionary *)context
{
        NSData *jsonData = [context[@"content"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    self.textView.defaultText = context[@"title"];
    self.recordText = self.textView.defaultText;

    for (NSDictionary *dic in dataArr) {
        if ([dic[@"type"]  isEqual: @"1"] || [dic[@"type"]  isEqual: @(1)]) {
            CZEditorTextView *textView = [self addTextView:nil];
            textView.defaultText = dic[@"value"];
        } else {
            CZEditorImageView *imageView = [[CZEditorImageView alloc] init];
            imageView.width = SCR_WIDTH - 20;
            imageView.height = [dic[@"height"] integerValue];
            imageView.urlPath = dic[@"value"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageView.urlPath]];
            [self creatImageView:imageView];
        }
    }
}

// 上传图片
- (void)updataImage:(CZEditorImageView *)imageView
{
    //上传图片
    [CZProgressHUD showProgressHUDWithText:nil];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/uploadImage"];
    [GXNetTool uploadNetWithUrl:url fileSource:imageView.image success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSString *url = result[@"data"];
            imageView.urlPath = url;
            // 显示控件
            [self creatImageView:imageView];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"上传失败"];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {

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

        // 添加控件
        CZEditorImageView *imageView = [[CZEditorImageView alloc] initWithImage:image];
        // 上传图片
        [self updataImage:imageView];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
