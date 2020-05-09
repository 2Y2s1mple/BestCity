//
//  CZIssueCreateMoments.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/19.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueCreate1Moments.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIButton+WebCache.h"


#import "Masonry.h"
#import "CZUMConfigure.h"
#import "CZShareItemButton.h"
#import "UIImageView+WebCache.h"
#import "CZIssueMomentsAlertView.h"

#import "GXZoomImageView.h"


@interface CZIssueCreate1Moments ()
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataSource;
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
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
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *recordImageArr;
/** <#注释#> */
@property (nonatomic, assign) NSInteger recordIndex;
/** <#注释#> */
@property (nonatomic, strong) NSString *tklStr;
@property (nonatomic, strong) NSString *downloadUrlStr;
@property (nonatomic, strong) NSString *invitationCodeStr;
@end

@implementation CZIssueCreate1Moments

// 记录每张图片对应的二维码图
- (NSMutableArray *)recordImageArr
{
    if (_recordImageArr == nil) {
        _recordImageArr = [NSMutableArray array];
    }
    return _recordImageArr;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化图片的位置
    self.recordIndex = 1;

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
            [btn sd_setImageWithURL:[NSURL URLWithString:images[i]] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

            }];

            btn.height = 100;
            btn.width = 100;
            btn.centerY = backView.height / 2.0;
            btn.x = 15 + i * (space + btn.width);
            [backView addSubview:btn];
            [btn addTarget:weakself action:@selector(viewTypeFourAction:) forControlEvents:UIControlEventTouchUpInside];
            backView.contentSize = CGSizeMake(CZGetX(btn) + 15, 0);

            UIButton *bigBtn = [[UIButton alloc] init];
            bigBtn.y = 50;
            bigBtn.width = 100;
            bigBtn.height = 50;
            [btn addSubview:bigBtn];
            [bigBtn addTarget:weakself action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];

            UIButton *icon = [[UIButton alloc] init];
            [icon setImage:[UIImage imageNamed:@"moments-9"] forState:UIControlStateNormal];
            [icon setImage:[UIImage imageNamed:@"moments-8"] forState:UIControlStateSelected];
            icon.userInteractionEnabled = NO;
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
//            [self getShareDataWithIndex:[NSString stringWithFormat:@"%ld", ((long)btn.tag + 1)]];
            // 记录谁是第一个
            self.recordIndex = btn.tag + 1;
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
    };

    self.block1 = ^(NSInteger index, BOOL isSelected) {
        // 抢购地址
        if (index == 0) {
            if (isSelected) {
                weakself.tklStr = [NSString stringWithFormat:@"%@\n", weakself.dataSource[@"tkl"]];
            } else {
                weakself.tklStr = @"";
            }
            
        }

        // 邀请码
        if (index == 1) {
            if (isSelected) {
                weakself.invitationCodeStr = [NSString stringWithFormat:@"%@\n", weakself.dataSource[@"invitationCode"]];
            } else {
                weakself.invitationCodeStr = @"";
            }
            if (isSelected) {
                weakself.downloadUrlStr = [NSString stringWithFormat:@"%@\n", weakself.dataSource[@"downloadUrl"]];
            } else {
                weakself.downloadUrlStr = @"";
            }
        }
        
        NSString *mainTitle = [NSString stringWithFormat:@"%@\n", weakself.dataSource[@"baseComment"]];
        
        // 标题 -> 抢购地址 -> 邀请码
        NSString *finallyStr = [NSString stringWithFormat:@"%@%@%@%@", mainTitle, weakself.downloadUrlStr, weakself.tklStr, weakself.invitationCodeStr];
        
        code.text = finallyStr;
        

        if (index == 4) {
            UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
            posteboard.string = code.text;
            [recordSearchTextArray addObject:posteboard.string];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"链接复制成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"暂不粘贴" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去微信粘贴" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL * url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                } else {
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
    backView.tag = 100;
    backView.y = Y ;
    backView.height = 50;;
    backView.width = SCR_WIDTH;
//    backView.backgroundColor =RANDOMCOLOR;
    [self.scrollerView addSubview:backView];

    CGFloat width = (SCR_WIDTH - 120) / 2;
    NSArray *titles = @[@"抢购地址", @"邀请码"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] init];
//        btn.backgroundColor = RANDOMCOLOR;
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
    loginOut.frame = CGRectMake(0, CZGetY(backView), 150, 28);
    loginOut.centerX = SCR_WIDTH / 2.0;
    [self.scrollerView addSubview:loginOut];
    [loginOut setTitle:@"复制评论【链接】" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZREDCOLOR;
    loginOut.layer.cornerRadius = 14;
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

    UIButton *btn1 = sender.superview.subviews[0];
    UIButton *btn2 = sender.superview.subviews[1];
    if (!btn1.isSelected) {
        sender.selected = !sender.selected;
        [CZProgressHUD showProgressHUDWithText:@"必须选择抢购地址"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
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
    param[@"source"] = self.source;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/getGoodsShareInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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


- (void)getShareDataWithIndex:(NSString *)index action:(void (^)(UIImage *))block
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"otherGoodsId"] = self.otherGoodsId;
    param[@"shareImgLocation"] = index;
    param[@"source"] = self.source;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/getGoodsShareInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            // 保存图片
            WS(weakself)
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.dataSource[@"shareImg"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                weakself.shareImg = image;
                block(image);
            }];
        }
    } failure:^(NSError *error) {}];
}


#pragma mark - 创建
- (void)setupSubView
{
    UIView *shareView = [[UIView alloc] init];
    shareView.y = SCR_HEIGHT - 140;
    shareView.height = 140;
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
    titleLabel1.text = @"每日可赚50极币";
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
    // 获取当前第一个图片
    NSLog(@"%ld", (long)self.recordIndex);

    if ((tap.view.tag - 100) != 4) {
        [CZProgressHUD showProgressHUDWithText:@"文案已复制到粘贴板, 分享后长按粘贴"];
    }
    if (self.recordIndex == 1) {
        [self shareWithIndex:tap.view.tag - 100];
    } else {
        [CZProgressHUD showProgressHUDWithText:nil];
        [self getShareDataWithIndex:[NSString stringWithFormat:@"%li", (long)self.recordIndex] action:^(UIImage *image) {
            [CZProgressHUD hideAfterDelay:0];
            [self shareWithIndex:tap.view.tag - 100];
        }];
    }
}


- (void)shareWithIndex:(NSInteger)index
{
    // 文案已复制到粘贴板
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.dataSource[@"content"];
    [recordSearchTextArray addObject:posteboard.string];

    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (index) {
        case 0:
        {
            [self shareToSocial];
            break;
        }
        case 1: // 朋友圈
        {
            if (self.mutImagescopy.count == 0) {
                [self.mutImagescopy addObject:self.shareImg];
            } else {
                if (![[self.mutImagescopy firstObject] isEqual:self.shareImg]) {
                    [self.mutImagescopy replaceObjectAtIndex:0 withObject:self.shareImg];
                }
            }
            [CZJIPINSynthesisTool jipin_saveImage:self.mutImagescopy];

            CZIssueMomentsAlertView *vc = [[CZIssueMomentsAlertView alloc] init];
            [self presentViewController:vc animated:NO completion:nil];
            break;
        }
        case 2:
        {
            [self shareToSocial];
            break;
        }
        case 3:
        {
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
            [CZJIPINSynthesisTool jipin_saveImage:self.mutImagescopy];
            break;
        }
        default:
            break;
    }
}


-(void)shareToSocial
{
    if (self.mutImagescopy.count == 0) {
        [self.mutImagescopy addObject:self.shareImg];
    } else {
        if (![[self.mutImagescopy firstObject] isEqual:self.shareImg]) {
            [self.mutImagescopy replaceObjectAtIndex:0 withObject:self.shareImg];
        }
    }
    [CZJIPINSynthesisTool JINPIN_systemShareImages:self.mutImagescopy success:nil];
}

- (void)showImage:(UIButton *)tap
{
    UIButton *btn = (UIButton *)tap.superview;
    [CZJIPINSynthesisTool jipin_showZoomImage:btn];
}


@end

