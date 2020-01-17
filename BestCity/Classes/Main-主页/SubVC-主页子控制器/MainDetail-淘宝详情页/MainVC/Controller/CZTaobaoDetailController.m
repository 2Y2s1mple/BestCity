//
//  CZTaobaoDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTaobaoDetailController.h"
#import "CZScollerImageTool.h"
#import "GXNetTool.h"
#import "UIButton+CZExtension.h" // 按钮扩展
#import "CZCollectButton.h"
// 工具
#import "UIImageView+WebCache.h"
#import "CZUserInfoTool.h"
#import "CZUMConfigure.h"
// 视图
#import "CZTaobaoGoodsView.h"
#import "CZTaoBaoShopNameView.h" // 淘宝商家标题
#import "CZGuessWhatYouLikeView.h"
#import "CZGoodsParameterView.h" // 产品参数

#import "CZParameterScoreView.h" // 功能评分和产品视图"

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import "CZOpenAlibcTrade.h"

// universal links
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>

@interface CZTaobaoDetailController ()<UIScrollViewDelegate, CZGuessWhatYouLikeViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *detailModel;
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
/** 收藏 */
@property (nonatomic, strong) CZCollectButton *collectButton;
/** <#注释#> */
@property (nonatomic, assign) CGFloat recordHeight;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *topImage;

/** 详情图片 */
@property (nonatomic, strong) NSArray *descImgList;
@end

/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;
@implementation CZTaobaoDetailController

//实现带有场景参数的初始化方法，并根据场景参数还原该控制器：
-(instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    if (self = [super init]) {
        self.otherGoodsId = scene.params[@"id"];
    }
    return self;
}

- (UIImageView *)topImage
{
    if (_topImage == nil) {
        self.topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"“备份"]];
    }
    return _topImage;
}


#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
//        _scrollerView.backgroundColor = [UIColor redColor];
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollerView;
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CZCollectButton *)collectButton
{
    if (_collectButton == nil) {
        _collectButton = [CZCollectButton collectButton];
        _collectButton.frame = CGRectMake(SCR_WIDTH - 14 - 30, (IsiPhoneX ? 54 : 30), 30, 30);
        [_collectButton setImage:[UIImage imageNamed:@"hot-list-favor"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"nav-favor-sel"] forState:UIControlStateSelected];
        _collectButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _collectButton.layer.cornerRadius = 15;
        _collectButton.layer.masksToBounds = YES;
        _collectButton.type = @"8";
        _collectButton.commodityID = self.otherGoodsId;
    }
    return _collectButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self getSourceData];

    [self.view addSubview:self.scrollerView];

    // 加载pop按钮
    [self.view addSubview:self.popButton];

    // 加载收藏按钮
    [self.view addSubview:self.collectButton];
}

- (void)getSourceData
{
    // goodsType 1: 极品城 2: 淘宝
    // 如果极品城以前的样式, 淘宝的是现在样式


    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"otherGoodsId"] = self.otherGoodsId;
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/tbk/goodsDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.detailModel = result[@"data"];

            // 初始化顶部视图
            [self imageGoodsView];

            // 最下面购买视图
            [self setupBottomView];

        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {}];


    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    param1[@"otherGoodsId"] = self.otherGoodsId;
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/tbk/getGoodsDescImgs"] body:param1 header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.descImgList = result[@"data"];

        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {}];
}

#pragma mark - 轮播图和详情
- (void)imageGoodsView
{
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 370)];
    [self.scrollerView addSubview:imageView];
    imageView.imgList = [self.detailModel[@"imgList"] isKindOfClass:[NSNull class]] ? @[] : self.detailModel[@"imgList"];
    self.recordHeight += imageView.height; // 高度

    CZTaobaoGoodsView *titlesView = [CZTaobaoGoodsView taobaoGoodsView];
    titlesView.y = self.recordHeight;
    titlesView.width = SCR_WIDTH;
    titlesView.model = self.detailModel;
    [self.scrollerView addSubview:titlesView];
    self.recordHeight += titlesView.commodityH; // 高度

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    lineView.y = self.recordHeight;
    lineView.height = 10;
    lineView.width = SCR_WIDTH;
    [self.scrollerView addSubview:lineView];
    self.recordHeight += 10;

    // 功能评分
    if(![self.detailModel[@"scoreOptionsList"] isKindOfClass:[NSNull class]] && [self.detailModel[@"scoreOptionsList"] count] > 0) {
        CZParameterScoreView *parameter = [CZParameterScoreView parameterScoreViewImage:@"quality" title:@"功能评分" contextList:self.detailModel[@"scoreOptionsList"] detailModel:self.detailModel];
        parameter.y = self.recordHeight;
        [self.scrollerView addSubview:parameter];
        self.recordHeight += parameter.height ;
    }


    // 产品参数
    if(![self.detailModel[@"parametersList"] isKindOfClass:[NSNull class]] && [self.detailModel[@"parametersList"] count] > 0) {
        CZParameterScoreView *scores = [CZParameterScoreView parameterScoreViewImage:@"parameter" title:@"产品参数" contextList:self.detailModel[@"parametersList"] detailModel:self.detailModel];
        scores.y = self.recordHeight;
        [self.scrollerView addSubview:scores];
        self.recordHeight += scores.height ;
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.y = self.recordHeight;
        lineView.height = 8;
        lineView.width = SCR_WIDTH;
        [self.scrollerView addSubview:lineView];
        self.recordHeight += 8;

        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = UIColorFromRGB(0xF5F5F5);
        lineView1.y = self.recordHeight;
        lineView1.height = 10;
        lineView1.width = SCR_WIDTH;
        [self.scrollerView addSubview:lineView1];
        self.recordHeight += 10;
    }


    // 淘宝商家
    CZTaoBaoShopNameView *shopNameView = [CZTaoBaoShopNameView taoBaoShopNameView];
    [self.scrollerView addSubview:shopNameView];
    shopNameView.paramDic = self.detailModel;
    shopNameView.y = self.recordHeight;
    self.recordHeight += shopNameView.height; // 高度

    // 推荐理由
    if(![self.detailModel[@"recommendReason"] isKindOfClass:[NSNull class]] && [self.detailModel[@"recommendReason"] length] > 0) {
        [self recommendReason:self.detailModel[@"recommendReason"]];
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = UIColorFromRGB(0xF5F5F5);
        lineView1.y = self.recordHeight;
        lineView1.height = 10;
        lineView1.width = SCR_WIDTH;
        [self.scrollerView addSubview:lineView1];
        self.recordHeight += 10;
    }

    // 商品详情
    if(![self.detailModel[@"descImgList"] isKindOfClass:[NSNull class]] && [self.detailModel[@"descImgList"] count] > 0) {
    }
    [self goodsDetail];
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = UIColorFromRGB(0xF5F5F5);
    lineView2.y = self.recordHeight;
    lineView2.height = 10;
    lineView2.width = SCR_WIDTH;
    [self.scrollerView addSubview:lineView2];
    self.recordHeight += 10;


    // 猜你喜欢
    [self guessView];


    [self changeSubViewFrame];

}

// 初始化底部菜单
- (void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.size = CGSizeMake(SCR_WIDTH, 49);
    bottomView.y = SCR_HEIGHT - (IsiPhoneX ? 83 : 49);
    [self.view addSubview:bottomView];

    // 两个按钮
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.frame = CGRectMake(0, 0, 145, bottomView.height);
    [bottomView addSubview:shareView];

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(17, 0, 25, bottomView.height);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(0x565252) forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    [shareBtn setImage:[UIImage imageNamed:@"Forward-3"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:shareBtn];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -26, 0, 0);

    UIButton *shareBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn1.frame = CGRectMake(CZGetX(shareBtn) + 45, 0, 25, bottomView.height);
    [shareBtn1 setTitle:@"首页" forState:UIControlStateNormal];
    [shareBtn1 setTitleColor:UIColorFromRGB(0x565252) forState:UIControlStateNormal];
    shareBtn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    [shareBtn1 setImage:[UIImage imageNamed:@"taobaoDetai_upstage-sel"] forState:UIControlStateNormal];
    shareBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    shareBtn1.titleEdgeInsets = UIEdgeInsetsMake(30, -26, 0, 0);
    [shareBtn1 addTarget:self action:@selector(mainIndexBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:shareBtn1];


    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(shareView.width, shareView.y, SCR_WIDTH - shareView.width, shareView.height);
    NSString *buyBtnStr = @"立即购买（省¥%.2lf）";
    buyBtnStr = [NSString stringWithFormat:buyBtnStr, ([self.detailModel[@"fee"] floatValue] + [self.detailModel[@"couponPrice"] floatValue])];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:buyBtnStr];
    [attrStr addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size: 18]} range:NSMakeRange(0, 4)];

    [buyBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = CZREDCOLOR;
    [buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
}

// 推荐理由
- (void)recommendReason:(NSString *)context
{
    UIView *backView = [[UIView alloc] init];
    backView.y =self.recordHeight;
    backView.width =SCR_WIDTH;
//    backView.height = 430;
    [self.scrollerView addSubview:backView];

    UIImageView *titleBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taobaoDetail_矩形"]];
    titleBackImage.centerX = backView.width / 2.0;
    titleBackImage.y = 15;
    titleBackImage.size = CGSizeMake(132, 39);
    [backView addSubview:titleBackImage];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"推荐理由";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    titleLabel.size = titleBackImage.size;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBackImage addSubview:titleLabel];

    UIView *subView = [[UIView alloc] init];
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    subView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [backView addSubview:subView];
    subView.x = 14;
    subView.y = 75;
    subView.width = SCR_WIDTH - 28;

    UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"“"]];
    [subView addSubview:topImage];
    topImage.x = 7.5;
    topImage.y = 7.5;


    NSString *contextStr = context;

    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.tag = 101;
    contentLabel.text = contextStr;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    contentLabel.x = 25;
    contentLabel.y = CZGetY(topImage) + 3;
    contentLabel.width = subView.width - 50;

    CGFloat height = [contextStr boundingRectWithSize:CGSizeMake(contentLabel.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : contentLabel.font} context:nil].size.height;

    contentLabel.height = height;
    [subView addSubview:contentLabel];



    NSNumber *count = @((height) / contentLabel.font.lineHeight);
    // 判断
    if ([count integerValue] >= 10) {
        // 默认是收起
        contentLabel.numberOfLines = 10;
        contentLabel.height = 10 * contentLabel.font.lineHeight;

        UIButton *showAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [showAll setTitle:@"展开更多" forState:UIControlStateNormal];
        [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right"] forState:UIControlStateNormal];
        [showAll setTitle:@"点击收起" forState:UIControlStateSelected];
        [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right-1"] forState:UIControlStateSelected];
        showAll.imageEdgeInsets = UIEdgeInsetsMake(0, 44, 0, 0);
        showAll.titleEdgeInsets = UIEdgeInsetsMake(0, -28, 0, 0);
        showAll.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
        [showAll setTitleColor:UIColorFromRGB(0xCECECE) forState:UIControlStateNormal];
        [subView addSubview:showAll];
        [showAll sizeToFit];
        showAll.y = CZGetY(contentLabel) + 10;
        showAll.centerX = contentLabel.centerX;
        [showAll addTarget:self action:@selector(showAllAction:) forControlEvents:UIControlEventTouchUpInside];

        subView.height = CZGetY(showAll) + 12;
        backView.height = CZGetY(subView) + 20;
        self.recordHeight += backView.height;
    } else {
        [subView addSubview:self.topImage];
        self.topImage.x = subView.width - 7.5 - 19;
        self.topImage.y = CZGetY(contentLabel);

        subView.height = CZGetY(self.topImage) + 12;
        backView.height = CZGetY(subView) + 20;
        self.recordHeight += backView.height;
    }
}

// 商品详情
- (void)goodsDetail
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.y = self.recordHeight;
    backView.width = SCR_WIDTH;
    [self.scrollerView addSubview:backView];

    UIImageView *titleBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taobaoDetail_矩形"]];
    titleBackImage.centerX = backView.width / 2.0;
    titleBackImage.y = 15;
    titleBackImage.size = CGSizeMake(132, 39);
    [backView addSubview:titleBackImage];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"商品详情";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    titleLabel.size = titleBackImage.size;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBackImage addSubview:titleLabel];


    self.recordHeight += 75;
    UIView *subView = [[UIView alloc] init];
    subView.tag = 101;
    subView.layer.masksToBounds = YES;
    subView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [backView addSubview:subView];
    subView.y = 75;
    subView.width = SCR_WIDTH;
    subView.height = 0;

    self.recordHeight += 1;
    UIButton *showAll = [UIButton buttonWithType:UIButtonTypeCustom];
    showAll.y = CZGetY(subView) + 10;
    [showAll setTitle:@"点击查看完整详情" forState:UIControlStateNormal];
    [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right"] forState:UIControlStateNormal];
    [showAll setTitle:@"点击收起完整详情" forState:UIControlStateSelected];
    [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right-1"] forState:UIControlStateSelected];
    showAll.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    showAll.titleEdgeInsets = UIEdgeInsetsMake(0, -28, 0, 0);
    showAll.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    [showAll setTitleColor:UIColorFromRGB(0xCECECE) forState:UIControlStateNormal];
    [backView addSubview:showAll];
    [showAll sizeToFit];
    showAll.centerX = subView.width / 2.0;
    [showAll addTarget:self action:@selector(showAllDeatilImages:) forControlEvents:UIControlEventTouchUpInside];



    self.recordHeight += (22 + showAll.height);
    backView.height = CZGetY(showAll) + 12;
}

// 设置各个控件的尺寸
- (void)changeSubViewFrame
{
    for (int i = 0; i < self.scrollerView.subviews.count; i++) {
        UIView *view = self.scrollerView.subviews[i];
        if (i == 0) {
            view.y = 0;
            continue;
        }
        view.y = CZGetY(self.scrollerView.subviews[i - 1]);
        NSLog(@"%@", view);
    }
    self.scrollerView.contentSize = CGSizeMake(0, CZGetY([self.scrollerView.subviews lastObject]));
}

// 猜你喜欢
- (void)guessView
{
    CZGuessWhatYouLikeView *guess = [CZGuessWhatYouLikeView guessWhatYouLikeView];
    guess.delegate = self;
    guess.y = self.recordHeight;
    guess.width = SCR_WIDTH;
    guess.otherGoodsId = self.otherGoodsId;

    [self.scrollerView addSubview:guess];

    self.recordHeight += guess.height;
}






#pragma mark - 事件
// 显示全部推荐
- (void)showAllAction:(UIButton *)sender
{
    // 放label的view
    UIView *subView = sender.superview;
    // 最外面的View
    UIView *backView = subView.superview;
    // 文字
    UILabel *label = [subView viewWithTag:101];

    CGFloat height = [label.text boundingRectWithSize:CGSizeMake(label.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil].size.height;


    if (sender.isSelected) { // 默认是收起的
        sender.selected = NO;
        label.numberOfLines = 10;
        label.height = 10 * label.font.lineHeight;

        sender.y = CZGetY(label) + 10;
        subView.height = CZGetY(sender) + 12;
        backView.height = CZGetY(subView) + 20;
        [self.topImage removeFromSuperview];
    } else {
        sender.selected = YES;
        label.numberOfLines = 0;
        label.height = height;

        sender.y = CZGetY(label) + 10;
        subView.height = CZGetY(sender) + 12;
        backView.height = CZGetY(subView) + 20;


        [backView addSubview:self.topImage];
        self.topImage.x = subView.width - 7.5 - 19;
        self.topImage.y = CZGetY(subView) - 40;
    }

    [self changeSubViewFrame];

}

// 显示全部详情
- (void)showAllDeatilImages:(UIButton *)sender
{
    // 最外面的View
    UIView *backView = sender.superview;
    // 放图片的View
    UIView *imagesView = [backView viewWithTag:101];

    if (sender.isSelected) { // 默认是收起的
        sender.selected = NO;
        imagesView.height = 0;
        sender.y = CZGetY(imagesView) + 10;
        backView.height = CZGetY(sender) + 12;

    } else {
        sender.selected = YES;
        if (self.descImgList.count > 0) {
            NSMutableArray *imageList = [NSMutableArray arrayWithArray:self.descImgList];
            for (NSString *imageUrl in imageList) {
                UIImageView *bigImage = [[UIImageView alloc] init];
                bigImage.width = SCR_WIDTH;
                bigImage.height = 200;
                [imagesView addSubview:bigImage];
                NSString *strUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_.webp" withString:@""];
                [bigImage sd_setImageWithURL:[NSURL URLWithString:strUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image == nil) {
                        return ;
                    };
                    CGFloat imageHeight = bigImage.width * image.size.height / image.size.width;
                    bigImage.height = imageHeight;

                    for (int i = 0; i < imagesView.subviews.count; i++) {
                        UIView *view = imagesView.subviews[i];
                        if (i == 0) {
                            view.y = 0;
                            continue;
                        }
                        view.y = CZGetY(imagesView.subviews[i - 1]);
                    }
                    imagesView.height = CZGetY([imagesView.subviews lastObject]);
                    sender.y = CZGetY(imagesView) + 10;
                    backView.height = CZGetY(sender) + 12;
                    [self changeSubViewFrame];
                }];
            }

            imagesView.height = CZGetY([imagesView.subviews lastObject]);
            sender.y = CZGetY(imagesView) + 10;
            backView.height = CZGetY(sender) + 12;
        } else {
            [CZProgressHUD showProgressHUDWithText:@"暂无详情"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    }
    [self changeSubViewFrame];
}

// 购买
- (void)buyBtnAction
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }

    // 为了同步关联的淘宝账号
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *naVc = tabbar.selectedViewController;
        UIViewController *toVC = naVc.topViewController;
        NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
        if ([specialId isEqualToString:@""]) {
            [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
            [[ALBBSDK sharedInstance] auth:toVC successCallback:^(ALBBSession *session) {
                NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
                NSLog(@"%@", tip);
                TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@""] actionblock:^{
                    [CZProgressHUD showProgressHUDWithText:@"授权成功"];
                    [CZProgressHUD hideAfterDelay:1.5];
                    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];
                }];
                [tabbar presentViewController:webVc animated:YES completion:nil];

                //拉起淘宝
                AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
                showParam.openType = AlibcOpenTypeAuto;
                showParam.backUrl = @"tbopen25267281://xx.xx.xx";
                showParam.isNeedPush = YES;
                showParam.nativeFailMode = AlibcNativeFailModeJumpH5;

                [CZProgressHUD hideAfterDelay:1.5];

                [[AlibcTradeSDK sharedInstance].tradeService
                 openByUrl:[NSString stringWithFormat:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=25612235&redirect_uri=https://www.jipincheng.cn/qualityshop-api/api/taobao/returnUrl&state=%@&view=wap", JPTOKEN]
                 identity:@"trade"
                 webView:webVc.webView
                 parentController:tabbar
                 showParams:showParam
                 taoKeParams:nil
                 trackParam:nil
                 tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                     NSLog(@"-----AlibcTradeSDK------");
                     if(result.result == AlibcTradeResultTypeAddCard){
                         NSLog(@"交易成功");
                     } else if(result.result == AlibcTradeResultTypeAddCard){
                         NSLog(@"加入购物车");
                     }
                 } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                     NSLog(@"----------退出交易流程----------");
                 }];
            } failureCallback:^(ALBBSession *session, NSError *error) {
                NSString *tip = [NSString stringWithFormat:@"登录失败:%@", @""];
                NSLog(@"%@", tip);
            }];
        } else {
            // 打开淘宝
            [self getGoodsURl];
        }
    }];
}


// 获取购买的URL
- (void)getGoodsURl
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsBuyLink"] = self.detailModel[@"goodsBuyLink"];
    param[@"otherGoodsId"] = self.detailModel[@"otherGoodsId"];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsClickUrl"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 打开淘宝
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:self];
        } else {

            [CZProgressHUD showProgressHUDWithText:@"链接获取失败"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}

// 分享
- (void)shareBtnAction
{
    NSString *url = [NSString stringWithFormat:@"https://www.jipincheng.cn/share/tbGoodsDetail.html?id=%@", self.detailModel[@"otherGoodsId"]];
    NSString *title = self.detailModel[@"otherName"];
    NSString *subTitle = @"【分享来自极品城APP】看评测选好物，省心更省钱";
    NSString *thumImage = self.detailModel[@"img"];
    NSString *object = self.detailModel[@"otherGoodsId"];
    [CZJIPINSynthesisTool jumpShareViewWithUrl:url Title:title subTitle:subTitle thumImage:thumImage object:object];
}

// 跳转到首页
- (void)mainIndexBtnAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    tabbar.selectedIndex = 0;
}

- (void)reloadGuessWhatYouLikeView:(CGFloat)height
{
    [self changeSubViewFrame];
}

 

@end
