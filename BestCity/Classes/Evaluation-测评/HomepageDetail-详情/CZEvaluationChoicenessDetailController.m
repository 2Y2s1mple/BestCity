//
//  CZEvaluationChoicenessDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/16.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZEvaluationChoicenessDetailController.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "CZGiveLikeView.h"
#import "CZCollectButton.h"
#import "CZCommentBtn.h"
#import "CZOpenAlibcTrade.h" // 跳转淘宝
#import "CZShareView.h"

@interface CZEvaluationChoicenessDetailController ()
/** webView */
@property (nonatomic, strong) UIWebView *webView;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dicData;
/** 点赞 */
@property (nonatomic, strong) UIView *likeView;
/** popa按钮 */
@property (nonatomic, strong) UIButton *popButton;
/** 分享的参数 */
@property (nonatomic, strong) NSDictionary *shareParam;
@end

@implementation CZEvaluationChoicenessDetailController
#pragma mark - 懒加载
#pragma mark 点赞
- (UIView *)likeView
{
    if (_likeView == nil) {
        _likeView = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(self.webView), SCR_WIDTH, 207 + 44.5)];
        /**点赞*/
        //加个分隔线
        UIView *lineView = [[UIView alloc] init];;
        lineView.y = 0;
        lineView.height = 7;
        lineView.width = _likeView.width;
        lineView.backgroundColor = CZGlobalLightGray;
        [_likeView addSubview:lineView];
        
        //加载点赞小手
        CZGiveLikeView *giveLikeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, lineView.height, SCR_WIDTH, 200)];
        giveLikeView.evalId = self.detailID;
        [_likeView addSubview:giveLikeView];
        
        self.scrollerView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.likeView.frame));
    }
    return _likeView;
}
#pragma mark 滚动视图
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -(IsiPhoneX ? 44 : 20), SCR_WIDTH,  SCR_HEIGHT)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}
#pragma mark 返回按钮
- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [[UIButton alloc] init];
        _popButton.x = 15;
        _popButton.y = (IsiPhoneX ? 44 : 20) + 15;
        _popButton.size = CGSizeMake(30, 30);
        [_popButton setImage:IMAGE_NAMED(@"nav-back-1") forState:UIControlStateNormal];
        [_popButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}
#pragma mark  分享购买视图
- (UIView *)shareAndBuy
{
    // 分享的界面
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = CZGlobalWhiteBg;
    shareView.y = SCR_HEIGHT - (IsiPhoneX ? 83 : 44);
    shareView.height = 44;
    shareView.width = SCR_WIDTH;
    
    //加个分隔线
    UIView *lineView = [[UIView alloc] init];;
    lineView.y = 0.5;
    lineView.height = 0.5;
    lineView.width = SCR_WIDTH;
    lineView.backgroundColor = CZGlobalLightGray;
    [shareView addSubview:lineView];
    
    CGFloat width;
    if (!appVersion) {
        width = SCR_WIDTH / 3.0;
    } else {
        width = SCR_WIDTH / 4.0;
    }
    
    // 分享
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareView addSubview:shareBtn];
    shareBtn.y = lineView.y;
    shareBtn.width = width;
    shareBtn.height = shareView.height;
    [shareBtn setImage:IMAGE_NAMED(@"tab-bar") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(sharedApplication) forControlEvents:UIControlEventTouchUpInside];
    
    // 收藏
    CZCollectButton *collectBtn = [CZCollectButton collectButton];
    [shareView addSubview:collectBtn];
    collectBtn.x = CZGetX(shareBtn);
    collectBtn.y = lineView.y;
    collectBtn.width = width;
    collectBtn.height = shareView.height;
    collectBtn.evalId = self.detailID;
    
    
    
    // 评论
    CZCommentBtn *commentBtn = [CZCommentBtn commentButton];
    [shareView addSubview:commentBtn];
    commentBtn.x = CZGetX(collectBtn);
    commentBtn.y = lineView.y;
    commentBtn.width = width;
    commentBtn.height = shareView.height;
    commentBtn.goodsId = self.detailID;
    commentBtn.totalCommentCount = self.dicData[@"commentNum"];
    
    if (!appVersion) {
        // 立即购买
        UIButton *buyBtn = [[UIButton alloc] init];
        [shareView addSubview:buyBtn];
        buyBtn.x = CZGetX(commentBtn);
        buyBtn.y = lineView.y;
        buyBtn.width = width;
        buyBtn.height = shareView.height;
        buyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(gotoAlibcTrade) forControlEvents:UIControlEventTouchUpInside];
        buyBtn.backgroundColor = CZREDCOLOR;
    }
    
    
    return shareView;
}

#pragma mark - 事件
#pragma mark 分享
- (void)sharedApplication
{
    CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
    share.param = self.shareParam;
    [self.view addSubview:share];
}
#pragma mark 去淘宝
- (void)gotoAlibcTrade
{
    if (self.dicData[@"goodsBuyLink"] != [NSNull null]) {
        [CZOpenAlibcTrade openAlibcTradeWithUrlString:self.dicData[@"goodsBuyLink"] parentController:self];
    } else {
        [CZProgressHUD showProgressHUDWithText:@"商品已下架"];
        [CZProgressHUD hideAfterDelay:1.5];
    }
}
#pragma mark pop
- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    // 创建pop按钮
    [self.view addSubview:self.popButton];
    // 获取数据
    [self obtainMainData];
}

- (void)obtainMainData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"evalWayId"] = self.detailID;
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/evalWay/selectById"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dicData = result[@"GoodsEvalWay"];
            // 创建轮播图和webview
            [self setupTopView];
            // 创建点赞
            [self.scrollerView addSubview:self.likeView];
            // 创建分享购买窗口
            self.shareParam = result[@"ShareUrl"];
            [self.view addSubview:[self shareAndBuy]];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)setupTopView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [self.scrollerView addSubview:imageView];
    imageView.y = 0;
    imageView.width = SCR_WIDTH;
    imageView.height = 314;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dicData[@"imgId"]] placeholderImage:IMAGE_NAMED(@"testImage1.png")];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    UIView *lightDarkView = [[UIView alloc] init];
    [imageView addSubview:lightDarkView];
    lightDarkView.y = imageView.height - 44;
    lightDarkView.width = imageView.width;
    lightDarkView.height = 44;
    lightDarkView.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
    
    UILabel *label = [[UILabel alloc] init];
    [lightDarkView addSubview:label];
    label.x = 10;
    label.height = lightDarkView.height;
    label.width = SCR_WIDTH - 20;
    label.text = self.dicData[@"evalWayName"];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CZGetY(imageView) + 10, SCR_WIDTH, 100)];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadHTMLString:self.dicData[@"content"] baseURL:nil];
    [self.scrollerView addSubview:self.webView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size =  [change[@"new"] CGSizeValue];
    self.webView.height = size.height;
    
    self.likeView.y = CZGetY(self.webView);
    // 更新滚动视图
    self.scrollerView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.likeView.frame));
}

@end
