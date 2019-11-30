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

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import "CZOpenAlibcTrade.h"

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
@end

/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;
@implementation CZTaobaoDetailController
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
        _collectButton.type = @"1";
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"otherGoodsId"] = self.otherGoodsId;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/goodsDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.detailModel = [result[@"data"] deleteAllNullValue];

            // 初始化顶部视图
            [self imageGoodsView];

            // 最下面购买视图
            [self setupBottomView];

            self.scrollerView.contentSize = CGSizeMake(0, self.recordHeight);
        }
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

    // 功能评分
    if(![self.detailModel[@"scoreOptionsList"] isKindOfClass:[NSNull class]] && [self.detailModel[@"scoreOptionsList"] count] > 0) {
        [self functionScoresViewImage:@"quality" title:@"功能评分" contextList:self.detailModel[@"scoreOptionsList"]];
    }

    // 产品参数
    [self functionScoresViewImage:@"parameter" title:@"产品参数" contextList:self.detailModel[@"parametersList"]];

    // 淘宝商家
    CZTaoBaoShopNameView *shopNameView = [CZTaoBaoShopNameView taoBaoShopNameView];
    [self.scrollerView addSubview:shopNameView];
    shopNameView.paramDic = self.detailModel;
    shopNameView.y = self.recordHeight;
    self.recordHeight += shopNameView.height; // 高度

    // 推荐理由
    if(![self.detailModel[@"recommendReason"] isKindOfClass:[NSNull class]] && [self.detailModel[@"recommendReason"] length] > 0) {
        [self recommendReason:self.detailModel[@"recommendReason"]];
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    lineView.y = self.recordHeight;
    lineView.height = 10;
    lineView.width = SCR_WIDTH;
    [self.scrollerView addSubview:lineView];
    self.recordHeight += 10;


    // 商品详情
    [self goodsDetail];


    // 猜你喜欢
    [self guessView];

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
    shareBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"Forward-2"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:shareBtn];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);

    UIButton *shareBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn1.frame = CGRectMake(CZGetX(shareBtn) + 45, 0, 25, bottomView.height);
    [shareBtn1 setTitle:@"首页" forState:UIControlStateNormal];
    shareBtn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    [shareBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn1 setImage:[UIImage imageNamed:@"taobaoDetai_upstage-sel"] forState:UIControlStateNormal];
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


// 创建产品参数
- (void)functionScoresViewImage:(NSString *)iconName title:(NSString *)titleName contextList:(NSArray *)list
{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.y = self.recordHeight;
    containerView.width = SCR_WIDTH;
    [self.scrollerView addSubview:containerView];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quality"]];
    iconImageView.x = 14;
    iconImageView.y = 14;
    iconImageView.size = CGSizeMake(19, 19);
    [containerView addSubview:iconImageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleName;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [titleLabel sizeToFit];
    titleLabel.centerY = iconImageView.centerY;
    titleLabel.x = CZGetX(iconImageView) + 3;
    [containerView addSubview:titleLabel];


    UIScrollView *scoresView = [[UIScrollView alloc] init];
    [containerView addSubview:scoresView];
    scoresView.y = CZGetY(iconImageView) + 15;
    scoresView.width = SCR_WIDTH;
    scoresView.height = 85;
    scoresView.backgroundColor = [UIColor whiteColor];

    NSInteger count;
    if ([titleName isEqualToString:@"功能评分"]) {
        count = list.count + 1;
//        UITapGestureRecognizer *tap = [UITapGestureRecognizer alloc] initWithTarget:<#(nullable id)#> action:<#(nullable SEL)#>
    } else {
        count = list.count;
    }
    for (int i = 0; i < count; i++) {
        CGFloat width = 75;
        CGFloat height  = 85;
        UIView *view = [[UIView alloc] init];
        view.x = 14 + i * width;
        view.height = height;
        view.width = width;
        view.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [scoresView addSubview:view];
        scoresView.contentSize = CGSizeMake(CZGetX(view) + 14, 0);

        UILabel *label = [[UILabel alloc] init];
        UILabel *label1 = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label1.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label1.textAlignment = NSTextAlignmentCenter;
        label.height = view.height / 2.0 - 0.75;
        label1.height = label.height;

        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        if (i == (count - 1)) {
            label.x = 0.5;
            label.y = 0.5;
            label.width = view.width - 1;

            label1.x = label.x;
            label1.y = CZGetY(label) + 0.5;
            label1.width = view.width - 1;
        } else {
            label.x = 0.5;
            label.y = 0.5;
            label.width = view.width - 0.5;

            label1.x = label.x;
            label1.y = CZGetY(label) + 0.5;
            label1.width = view.width - 0.5;
        }


        [view addSubview:label];
        [view addSubview:label1];

        if ([titleName isEqualToString:@"功能评分"]) {
            if (i == 0) {
                label.textColor = UIColorFromRGB(0x565252);
                label.text = @"综合评分";

                label1.textColor = UIColorFromRGB(0xE25838);
                label1.text = [NSString stringWithFormat:@"%.1lf分", [self.detailModel[@"score"] floatValue]];
            } else {
                NSDictionary *dic = list[i - 1];
                label.textColor = UIColorFromRGB(0x9D9D9D);
                label.text = dic[@"name"];

                label1.textColor = UIColorFromRGB(0x565252);
                label1.text = [dic[@"score"] stringByAppendingString:@"分"];
            }
        } else {
            NSDictionary *dic = list[i];
            label.textColor = UIColorFromRGB(0x9D9D9D);
            label.text = dic[@"name"];

            label1.textColor = UIColorFromRGB(0x565252);
            label1.text = [dic[@"value"] stringByAppendingString:@"分"];
        }
    }
    containerView.height = CZGetY(scoresView) + 14;
    self.recordHeight += containerView.height ;
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
        UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"“备份"]];
        [subView addSubview:topImage];
        topImage.x = subView.width - 7.5 - 19;
        topImage.y = CZGetY(contentLabel);

        subView.height = CZGetY(topImage) + 12;
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

    UIView *subView = [[UIView alloc] init];
    subView.tag = 101;
    subView.layer.masksToBounds = YES;
    subView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [backView addSubview:subView];
    subView.y = 75;
    subView.width = SCR_WIDTH;
    self.recordHeight += 75;



    UIButton *showAll = [UIButton buttonWithType:UIButtonTypeCustom];
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

    self.recordHeight += (22 + showAll.height);
    [showAll addTarget:self action:@selector(showAllDeatilImages:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *imageList = [NSMutableArray arrayWithArray:self.detailModel[@"descImgList"]];

    if (imageList.count > 0) { // 默认图片300
        self.recordHeight += 300;
    }

    for (NSString *imageUrl in imageList) {

        UIImageView *bigImage = [[UIImageView alloc] init];
        bigImage.width = SCR_WIDTH;
        bigImage.height = 200;


        [subView addSubview:bigImage];
        [bigImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image == nil) {
                return ;
            };
            CGFloat imageHeight = bigImage.width * image.size.height / image.size.width;
            bigImage.height = imageHeight;

            for (int i = 0; i < subView.subviews.count; i++) {
                UIView *view = subView.subviews[i];
                if (i == 0) {
                    view.y = 0;
                    continue;
                }
                view.y = CZGetY(subView.subviews[i - 1]);
            }
            subView.height = CZGetY([subView.subviews lastObject]);


            if (subView.height > 300) { // 默认300
                subView.height = 300;
                showAll.y = CZGetY(subView) + 10;
                backView.height = CZGetY(showAll) + 12;
            } else {
                showAll.y = CZGetY(subView) + 10;
                backView.height = CZGetY(showAll) + 12;
                self.recordHeight += imageHeight;
            }
            self.scrollerView.contentSize = CGSizeMake(0, self.recordHeight);
        }];
    }
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

    } else {
        sender.selected = YES;
        label.numberOfLines = 0;
        label.height = height;

        sender.y = CZGetY(label) + 10;
        subView.height = CZGetY(sender) + 12;
        backView.height = CZGetY(subView) + 20;
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
        imagesView.height = 300;
        sender.y = CZGetY(imagesView) + 10;
        backView.height = CZGetY(sender) + 12;

    } else {
        sender.selected = YES;
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
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *naVc = tabbar.selectedViewController;
    UIViewController *toVC = naVc.topViewController;
    NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
    if (specialId.length == 0) {
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
    CURRENTVC(currentVc);
    [[CZUMConfigure shareConfigure] sharePlatform:UMSocialPlatformType_WechatSession controller:currentVc url:@"https://www.jipincheng.cn" Title:self.detailModel[@"otherName"] subTitle:@"分享来自极品城APP】看评测选好物，省心更省钱" thumImage:self.detailModel[@"shareImg"] shareType:1125 object:self.detailModel[@"descImgs"]];
}

- (void)reloadGuessWhatYouLikeView
{
    [self changeSubViewFrame];
}



@end
