//
//  CZIssueCreateMoments.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/19.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueCreateMoments.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIButton+WebCache.h"


#import "Masonry.h"
#import "CZUMConfigure.h"
#import "CZShareItemButton.h"
#import "UIImageView+WebCache.h"
#import "CZIssueMomentsAlertView.h"

#import "CZZoomImageView.h"


@interface CZIssueCreateMoments ()
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** <#注释#> */
//@property (nonatomic, strong) UIButton *recordElement;
/** <#注释#> */
@property (nonatomic, strong) NSMutableString *mutStr;
@property (nonatomic, strong) void (^blockSourceData1)(NSDictionary *);
@property (nonatomic, strong) void (^blockSourceData2)(NSDictionary *);
@property (nonatomic, strong) void (^blockSourceData3)(NSDictionary *);
@property (nonatomic, strong) void (^block1)(NSInteger, BOOL);

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *mutImages;
@property (nonatomic, strong) NSMutableArray *mutImagescopy;

/** <#注释#> */
@property (nonatomic, strong) UIImage *shareImg;

/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation CZIssueCreateMoments
- (NSMutableArray *)mutImagescopy
{
    if (_mutImagescopy == nil) {
        _mutImagescopy = [NSMutableArray array];
    }
    return _mutImagescopy;
}

- (NSMutableArray *)mutImages
{
    if (_mutImages == nil) {
        _mutImages = [NSMutableArray array];
    }
    return _mutImages;
}

- (NSMutableString *)mutStr
{
    if (_mutStr == nil) {
        _mutStr = [NSMutableString string];
    }
    return _mutStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"创建分享" rightBtnTitle:@"帮助" rightBtnAction:^{
        CURRENTVC(currentVc);
        TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/new-free/shareHelp"]];
        webVc.titleName = @"分享帮助";
        [currentVc presentViewController:webVc animated:YES completion:nil];
    }];
    navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView = navigationView;
    [self.view addSubview:navigationView];


    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CZGetY(navigationView), SCR_WIDTH, SCR_HEIGHT - CZGetY(navigationView) - 133)];
//    scrollerView.backgroundColor = RANDOMCOLOR;
    scrollerView.pagingEnabled = YES;
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView = scrollerView;
    [self.view addSubview:scrollerView];


    [self.scrollerView addSubview:[self createView1]];

    [self createScrollerview];

    [self createView3];

    [self createView4];

    [self getShareData];

    [self setupSubView];

}

- (UIView *)createView1
{
    UIView *view1 = [[UIView alloc] init];
    view1.height = 40;
    view1.width = SCR_WIDTH;
    view1.backgroundColor = UIColorFromRGB(0xFFE4E4);

    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"分享后复制【评论区文案】，预估收益%@元！", @"0"];
    label.textColor = UIColorFromRGB(0xE25838);
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    [label sizeToFit];
    label.x = 15;
    label.y = 5;
    label.centerY = view1.height / 2.0;
    [view1 addSubview:label];
    self.blockSourceData1 = ^(NSDictionary *dic) {
        label.text = [NSString stringWithFormat:@"分享后复制【评论区文案】，预估收益%.2f元！", [dic[@"fee"] floatValue]];;
        [label sizeToFit];
    };


    return view1;
}


- (void)createScrollerview
{
    UIScrollView *backView = [[UIScrollView alloc] init];
    backView.y = 40;
    backView.showsHorizontalScrollIndicator = NO;
    backView.showsVerticalScrollIndicator = NO;
    backView.height = 120;;
    backView.width = SCR_WIDTH;
    [self.scrollerView addSubview:backView];
    WS(weakself)
    self.blockSourceData3 = ^(NSDictionary *dic) {
        // 第一次将合成图给数组
        // 保存图片// 保存图片
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:dic[@"shareImg"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            weakself.shareImg = image;
        }];

        NSArray *images = dic[@"imgs"];
        NSInteger count = [images count];
        CGFloat space = 5;
        for (int i = 0; i < count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i;
            [btn sd_setImageWithURL:[NSURL URLWithString:images[i]] forState:UIControlStateNormal];

            btn.height = 100;
            btn.width = 100;
            btn.centerY = backView.height / 2.0;
            btn.x = 15 + i * (space + btn.width);
            [backView addSubview:btn];
            [btn addTarget:weakself action:@selector(viewTypeFourAction:) forControlEvents:UIControlEventTouchUpInside];

            backView.contentSize = CGSizeMake(CZGetX(btn) + 15, 0);


            UIButton *bigBtn = [[UIButton alloc] init];
            bigBtn.y = 20;
            bigBtn.width = 100;
            bigBtn.height = 80;
            [btn addSubview:bigBtn];
            [bigBtn addTarget:weakself action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];


            UIButton *icon = [[UIButton alloc] init];
            [icon setImage:[UIImage imageNamed:@"moments-9"] forState:UIControlStateNormal];
            [icon setImage:[UIImage imageNamed:@"moments-8"] forState:UIControlStateSelected];
            icon.tag = 100;
            icon.height = 18;
            icon.width = 18;
            icon.y = 5;
            icon.x = 100 - 5 - 18;
            [btn addSubview:icon];

            if (i == 0) {
                btn.selected = YES;
                icon.selected = YES;
                [weakself.mutImages addObject:btn];

                UILabel *label = [[UILabel alloc] init];
                label.text = @"二维码推广图";
                label.tag = 200;
                label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
                label.textAlignment = NSTextAlignmentCenter;
                label.x = 0 ;
                label.y = 80;
                label.width = 100;
                label.height = 20;
                [btn addSubview:label];

            }

        }
    };
}

- (void)viewTypeFourAction:(UIButton *)sender
{
    if (self.mutImages.count == 1 && sender.selected) return;
    sender.selected = !sender.selected;

    UIButton *iconBtn = [sender viewWithTag:100];
    iconBtn.selected = sender.selected;

    for (int i = 0 ;i < self.mutImages.count; i++) {
        UIButton *btn = self.mutImages[i];
        UILabel *label = [btn viewWithTag:200];
        [label removeFromSuperview];
    }

    if (sender.isSelected) {
        [self.mutImages addObject:sender];
    } else {
        if (self.mutImages.count != 1) {
            [self.mutImages removeObject:sender];
        }
    }
//    if (![self.mutImages containsObject:sender]) {
//    }
    self.mutImagescopy = nil;
    NSArray *btns1 = sender.superview.subviews;
    for (int i = 0 ;i < btns1.count; i++) {
        UIButton *btn = btns1[i];
        if (btn.selected) {
            [self.mutImagescopy addObject:btn.currentImage];
        }
    }

    // 找到最前面的第一张
    NSArray *btns = sender.superview.subviews;
    for (int i = 0 ;i < btns.count; i++) {
        UIButton *btn = btns[i];
        if (btn.selected) {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"二维码推广图";
            label.tag = 200;
            label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            label.textAlignment = NSTextAlignmentCenter;
            label.x = 0 ;
            label.y = 80;
            label.width = 100;
            label.height = 20;
            [btn addSubview:label];
            [self getShareDataWithIndex:[NSString stringWithFormat:@"%ld", ((long)btn.tag + 1)]];
            return;
        }
    }
}


- (void)createView3
{
    CGFloat Y = CZGetY([self.scrollerView.subviews lastObject]);
    UIView *backView = [[UIView alloc] init];
    backView.y = Y;
    backView.height = 40;
    backView.width = SCR_WIDTH;
//    backView.backgroundColor = UIColorFromRGB(0xFFE4E4);
    [self.scrollerView addSubview:backView];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"分享文案";
    label.textColor = UIColorFromRGB(0x202020);
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    [label sizeToFit];
    label.y = 5;
    label.x = 15;
    [backView addSubview:label];

    UITextView *textView = [[UITextView alloc] init];
    textView.x = 15;
    textView.y = CZGetY(label) + 10;
    textView.textColor = UIColorFromRGB(0x565252);
    textView.backgroundColor =  UIColorFromRGB(0xF5F5F5);
    textView.width = SCR_WIDTH - 30;
    textView.height = 100;
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    [backView addSubview:textView];
    textView.editable = NO;

    UIView *codeView = [[UIView alloc] init];
    codeView.frame = CGRectMake(15, CZGetY(textView) + 10, SCR_WIDTH - 30, 60);
    codeView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [backView addSubview:codeView];

    UITextView *code = [[UITextView alloc] init];
    code.x = 5;
    code.height = codeView.height;
    code.width = codeView.width - 10;
    code.textColor = UIColorFromRGB(0x565252);
    code.backgroundColor = UIColorFromRGB(0xF5F5F5);
    code.text = @"";
    code.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    code.editable = NO;
    [codeView addSubview:code];


    WS(weakself)
    self.blockSourceData2 = ^(NSDictionary *dic) {
        textView.text = dic[@"content"];
//        code.text = [NSString stringWithFormat:@"%@\n", dic[@"tkl"]];
//        [weakself.mutStr setString:code.text];
    };

    self.block1 = ^(NSInteger index, BOOL isSelected) {
        NSString *appendStr;
        if (index == 0) {
            appendStr = [NSString stringWithFormat:@"%@\n", weakself.dataSource[@"tkl"]];
            if (isSelected) {
                [weakself.mutStr appendString:appendStr];
            } else {
                [weakself.mutStr deleteCharactersInRange:[weakself.mutStr rangeOfString:appendStr]];
            }
            code.text = weakself.mutStr;
        }

        if (index == 1) {
            appendStr = [NSString stringWithFormat:@"%@\n", weakself.dataSource[@"downloadUrl"]];
            if (isSelected) {
                [weakself.mutStr appendString:appendStr];
            } else {
                [weakself.mutStr deleteCharactersInRange:[weakself.mutStr rangeOfString:appendStr]];
            }
            code.text = weakself.mutStr;
        }

        if (index == 2) {
            appendStr = [NSString stringWithFormat:@"%@\n", weakself.dataSource[@"invitationCode"]];
            if (isSelected) {
                [weakself.mutStr appendString:appendStr];
            } else {
                [weakself.mutStr deleteCharactersInRange:[weakself.mutStr rangeOfString:appendStr]];
            }
            code.text = weakself.mutStr;
        }

        if (index == 4) {
            UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
            posteboard.string =code.text;
            [recordSearchTextArray addObject:posteboard.string];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"淘口令复制成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去微信粘贴" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL * url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [CZProgressHUD showProgressHUDWithText:@"您的设备未安装微信APP"];
                    [CZProgressHUD hideAfterDelay:1.5];
                }
            }]];
            [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
        }

    };

    backView.height = CZGetY(codeView);
}

- (void)createView4
{
    CGFloat Y = CZGetY([self.scrollerView.subviews lastObject]);
    UIView *backView = [[UIView alloc] init];
    backView.y = Y ;
    backView.height = 50;;
    backView.width = SCR_WIDTH;
//    backView.backgroundColor =RANDOMCOLOR;
    [self.scrollerView addSubview:backView];

    CGFloat width = (SCR_WIDTH - 120) / 3;
    NSArray *titles = @[@"淘口令", @"下载链接", @"邀请码"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:@"moments-9"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"moments-8"] forState:UIControlStateSelected];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        [btn setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];

        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        btn.height = 30;
        btn.width = width;
        btn.centerY = backView.height / 2.0;
        btn.x = 60 + i * width;
        [backView addSubview:btn];
        [btn addTarget:self action:@selector(createView4BtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        btn.selected = YES;
    }

    //底部退出按钮
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(0, CZGetY(backView) + 10, 150, 36);
    loginOut.centerX = SCR_WIDTH / 2.0;
    [self.scrollerView addSubview:loginOut];
    [loginOut setTitle:@"复制评论淘口令" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZREDCOLOR;
    loginOut.layer.cornerRadius = 5;
    [loginOut addTarget:self action:@selector(generalPaste) forControlEvents:UIControlEventTouchUpInside];

    self.scrollerView.contentSize = CGSizeMake(0, CZGetY(loginOut) + 50);

}

- (void)generalPaste
{
    self.block1(4, YES);
}

- (void)createView4BtnClicked:(UIButton *)sender
{
    // 设置选中
    sender.selected = !sender.selected;

    self.block1(sender.tag, sender.selected);
}


#pragma mark - 数据
// 获取标题数据
- (void)getShareData
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"otherGoodsId"] = self.otherGoodsId;
    param[@"shareImgLocation"] = @"1";
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsShareInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            self.blockSourceData1(result[@"data"]);
            self.blockSourceData2(result[@"data"]);
            self.blockSourceData3(result[@"data"]);
            self.block1(0, YES);
            self.block1(1, YES);
            self.block1(2, YES);

        }
    } failure:^(NSError *error) {}];
}


- (void)getShareDataWithIndex:(NSString *)index
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"otherGoodsId"] = self.otherGoodsId;
    param[@"shareImgLocation"] = index;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsShareInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            // 保存图片
            WS(weakself)
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.dataSource[@"shareImg"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                weakself.shareImg = image;
            }];
        }
    } failure:^(NSError *error) {}];
}


- (void)setupSubView
{

    UIView *shareView = [[UIView alloc] init];
    shareView.y = SCR_HEIGHT - 133;
    shareView.height = 133;
    shareView.width = SCR_WIDTH;
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    shareView.layer.shadowColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:0.5].CGColor;
    shareView.layer.shadowOffset = CGSizeMake(0,-2.5);
    shareView.layer.shadowOpacity = 1;
    shareView.layer.shadowRadius = 6.5;
    [self.view addSubview:shareView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"图文分享到";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    [titleLabel sizeToFit];
    titleLabel.y = 5;
    titleLabel.centerX = SCR_WIDTH / 2.0;
    [shareView addSubview:titleLabel];

    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.text = @"每日可赚50积币";
    titleLabel1.textColor = UIColorFromRGB(0x9D9D9D);
    titleLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    [titleLabel1 sizeToFit];
    titleLabel1.y = CZGetY(titleLabel);
    titleLabel1.centerX = SCR_WIDTH / 2.0;
    [shareView addSubview:titleLabel1];




    CGFloat space = (SCR_WIDTH - 50 * 5) / 6.0;
    NSArray *imageArr = @[
        @{@"icon" : @"share-1", @"name" : @"微信"},
        @{@"icon" : @"share-3", @"name" : @"朋友圈"},
        @{@"icon" : @"share-4", @"name" : @"QQ"},
        @{@"icon" : @"moments-6", @"name" : @"微博"},
        @{@"icon" : @"share-5", @"name" : @"批量存图"},
                        ];
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CZShareItemButton *imageView = [CZShareItemButton buttonWithType:UIButtonTypeCustom];
        imageView.adjustsImageWhenHighlighted = NO;
        [imageView setImage:[UIImage imageNamed:obj[@"icon"]] forState:UIControlStateNormal];
        [imageView setTitle:obj[@"name"] forState:UIControlStateNormal];
        imageView.frame = CGRectMake((space + 50) * idx + 25, 60, 50, 60);
        imageView.tag = idx + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [imageView addGestureRecognizer:tap];
        [shareView addSubview:imageView];

    }];

}

- (void)action:(UITapGestureRecognizer *)tap
{
    [CZProgressHUD showProgressHUDWithText:nil];
    [CZProgressHUD hideAfterDelay:2];

    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.dataSource[@"content"];
    [recordSearchTextArray addObject:posteboard.string];

    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (tap.view.tag - 100) {
        case 0:
        {
            [self shareToSocial];
            break;
        }
        case 1: // 朋友圈
            if (self.mutImagescopy.count == 0) {
                [self.mutImagescopy addObject:self.shareImg];
            } else {
                [self.mutImagescopy replaceObjectAtIndex:0 withObject:self.shareImg];
            }
            [self saveImageWithImage];
            break;
        case 2:
        {
            [CZProgressHUD showProgressHUDWithText:@"文案已复制到粘贴板, 分享后长按粘贴"];
            [CZProgressHUD hideAfterDelay:1.5];
            [self shareToSocial];
            break;
        }
        case 3:
        {
            [CZProgressHUD showProgressHUDWithText:@"文案已复制到粘贴板, 分享后长按粘贴"];
            [CZProgressHUD hideAfterDelay:1.5];
            type = UMSocialPlatformType_Sina;//微博
            [self shareToSocial];
            break;
        }
        case 4:
        {
            if (self.mutImagescopy.count == 0) {
                [self.mutImagescopy addObject:self.shareImg];
            } else {
                [self.mutImagescopy replaceObjectAtIndex:0 withObject:self.shareImg];
            }
            [self saveImageWithImage];
            break;
        }
        default:
            break;
    }
}


// 保存图片
- (void)saveImageWithImage
{
    //参数1:图片对象
    //参数2:成功方法绑定的target
    //参数3:成功后调用方法
    //参数4:需要传递信息(成功后调用方法的参数)

    if (self.mutImagescopy.count > 0) {
        UIImage *image = self.mutImagescopy[0];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        CZIssueMomentsAlertView *vc = [[CZIssueMomentsAlertView alloc] init];
        CURRENTVC(currentVc);
        [currentVc presentViewController:vc animated:NO completion:nil];
    }

}

#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [CZProgressHUD showProgressHUDWithText:msg];
        [CZProgressHUD hideAfterDelay:1.5];
    }else{
        msg = @"保存图片成功" ;
        [self.mutImagescopy removeObjectAtIndex:0];
        [self saveImageWithImage];
    }
}


-(void)shareToSocial
{

    if (self.mutImagescopy.count == 0) {
        [self.mutImagescopy addObject:self.shareImg];
    } else {
        [self.mutImagescopy replaceObjectAtIndex:0 withObject:self.shareImg];
    }
//    NSString *shareTitle = @"分享的标题";
//    UIImage *shareImage1 = [UIImage imageNamed:@"moments-6"];
//    UIImage *shareImage2 = [UIImage imageNamed:@"moments-6"];
//    UIImage *shareImage3 = [UIImage imageNamed:@"moments-6"];
//    UIImage *shareImage4 = [UIImage imageNamed:@"moments-6"];
//    NSArray *activityItems = @[
//        shareImage1,
//        shareImage2,
//        shareImage3,
//        shareImage4,
//    ]; // 必须要提供url 才会显示分享标签否则只显示图片

    NSArray *activityItems = self.mutImagescopy;

    UIActivityViewController * activityViewController = [[UIActivityViewController alloc]
                               initWithActivityItems:activityItems applicationActivities:nil];

//    设定不想显示的平台和功能
    NSMutableArray *excludeArray = [@[UIActivityTypeAirDrop,
                                      UIActivityTypePrint,
                                      UIActivityTypePostToVimeo] mutableCopy];
//不需要分享的图标
    activityViewController.excludedActivityTypes = excludeArray;


    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable   activityType,
                                            BOOL completed,
                                            NSArray * _Nullable returnedItems,
                                            NSError * _Nullable activityError) {

        NSLog(@"activityType: %@,\n completed: %d,\n returnedItems:%@,\n activityError:%@",activityType,completed,returnedItems,activityError);
    };


    CURRENTVC(currentVc)
    [currentVc presentViewController: activityViewController animated: YES completion: nil];

}

- (void)showImage:(UIButton *)tap
{
    UIButton *btn = tap.superview;
    UIImageView *imageView = btn.imageView;
    [CZZoomImageView showImage:imageView];
}


@end
