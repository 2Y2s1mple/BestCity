//
//  CZSub2FreeChargeDetailController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/25.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub2FreeChargeDetailController.h"
#import "CZScollerImageTool.h"
#import "GXNetTool.h"
#import "UIButton+CZExtension.h" // 按钮扩展

// 工具
#import "UIImageView+WebCache.h"
#import "CZUserInfoTool.h"
#import "CZUMConfigure.h"
#import"CZJIPINSynthesisTool.h"
// 视图
#import "CZSub2FreeChargeSubDetailView.h"
#import "CZTaoBaoShopNameView.h" // 淘宝商家标题
#import "CZGuessWhatYouLikeView.h"
#import "CZGoodsParameterView.h" // 产品参数

#import "CZParameterScoreView.h" // 功能评分和产品视图"

// universal links
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>
#import "CZTaobaoDetailNewAlertView.h"

@interface CZSub2FreeChargeDetailController ()<UIScrollViewDelegate, CZGuessWhatYouLikeViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *detailModel;
/** 总数据 */
@property (nonatomic, strong) NSDictionary *allDetailModel;
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
/** <#注释#> */
@property (nonatomic, assign) CGFloat recordHeight;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *topImage;

/** 详情图片 */
@property (nonatomic, strong) NSArray *descImgList;

@end

/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;

@implementation CZSub2FreeChargeDetailController
//实现带有场景参数的初始化方法，并根据场景参数还原该控制器：
- (instancetype)initWithMobLinkScene:(MLSDKScene *)scene
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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self getSourceData];

    [self.view addSubview:self.scrollerView];

    // 加载pop按钮
    [self.view addSubview:self.popButton];
   
}

- (void)getSourceData
{
    // goodsType 1: 极品城 2: 淘宝
    // 如果极品城以前的样式, 淘宝的是现在样式
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"freeId"] = self.allowanceGoodsId;
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/free/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.detailModel = result[@"data"];
            self.allDetailModel = result;
            self.descImgList = result[@"data"][@"descImgList"];

            // 初始化顶部视图
            [self imageGoodsView];

            // 最下面购买视图
            [self setupBottomView];

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

    CZSub2FreeChargeSubDetailView *titlesView = [CZSub2FreeChargeSubDetailView sub2FreeChargeSubDetailView];
    titlesView.y = self.recordHeight;
    titlesView.width = SCR_WIDTH;
    titlesView.param = self.detailModel;
    [self.scrollerView addSubview:titlesView];
    self.recordHeight += titlesView.height; // 高度

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

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(0, 0, SCR_WIDTH, bottomView.height);
    NSString *buyBtnStr = @"立即购买%@";
    buyBtnStr = [NSString stringWithFormat:buyBtnStr, @"（新人0元）"];

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
        [self changeSubViewFrame];
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
        }
    }
}

// 购买
- (void)buyBtnAction
{
    NSString *ID = self.allDetailModel[@"data"][@"otherGoodsId"];
    
    // 淘宝授权
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
        if (isAuthTaobao) {
           NSMutableDictionary *param = [NSMutableDictionary dictionary];
           param[@"otherGoodsId"] = ID;
           [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/free/apply?"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
               if ([result[@"msg"] isEqualToString:@"success"]) {
                   [CZJIPINSynthesisTool jipin_jumpTaobaoWithUrlString:result[@"data"]];
               } else {
                   [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
                   [CZProgressHUD hideAfterDelay:1.5];
               }
           } failure:^(NSError *error) {

           }];
        }
    }];
}

// 获取购买的URL
- (void)getGoodsURl
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"source"] = self.source;
    param[@"otherGoodsId"] = self.detailModel[@"otherGoodsId"];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/getGoodsClickUrl"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 打开淘宝
            [CZJIPINSynthesisTool jipin_jumpTaobaoWithUrlString:result[@"data"]];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"链接获取失败"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)reloadGuessWhatYouLikeView:(CGFloat)height
{
    [self changeSubViewFrame];
}


@end
