//
//  CZDChoiceDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDChoiceDetailController.h"
#import "PlanADScrollView.h"
#import "UIButton+CZExtension.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "CZGiveLikeView.h"
#import "CZCollectButton.h"
#import "CZCommentBtn.h"
#import "CZShareView.h"
#import "CZOpenAlibcTrade.h"

@interface CZDChoiceDetailController () <UIWebViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 记录高度 */
@property (nonatomic, assign) CGFloat recordY;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dicData;
/** webView */
@property (nonatomic, strong) UIWebView *webView;
/** 点赞 */
@property (nonatomic, strong) UIView *likeView;
/** 分享 */
@property (nonatomic, strong) UIView *shareView;
/** pop按钮 */
@property (nonatomic, strong) UIButton *popButton;
/** 分享参数 */
@property (nonatomic, strong) NSDictionary *shareParam;
@end

@implementation CZDChoiceDetailController
#pragma mark - 懒加载
#pragma mark  分享购买视图
- (UIView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[UIView alloc] init];
        _shareView.backgroundColor = CZGlobalWhiteBg;
        _shareView.y = SCR_HEIGHT - (IsiPhoneX ? 83 : 44);
        _shareView.height = 44;
        _shareView.width = SCR_WIDTH;
        
        
        CGFloat btnWidth = SCR_WIDTH / 3.0;
        //加个分隔线
        UIView *lineView = [[UIView alloc] init];;
        lineView.y = 0;
        lineView.height = 0.5;
        lineView.width = _shareView.width;
        lineView.backgroundColor = CZGlobalLightGray;
        [_shareView addSubview:lineView];
        
        // 分享
        UIButton *shareBtn = [[UIButton alloc] init];
        [_shareView addSubview:shareBtn];
        shareBtn.y = lineView.y;
        shareBtn.width = btnWidth;
        shareBtn.height = _shareView.height - lineView.y;
        [shareBtn setImage:IMAGE_NAMED(@"tab-bar") forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(sharedApplication) forControlEvents:UIControlEventTouchUpInside];
        // 收藏
        CZCollectButton *collectBtn = [CZCollectButton collectButton];
        [_shareView addSubview:collectBtn];
        collectBtn.x = CZGetX(shareBtn);
        collectBtn.y = shareBtn.y;
        collectBtn.width = shareBtn.width;
        collectBtn.height = shareBtn.height;
        collectBtn.findGoodsId = self.findgoodsId;
        // 评论
        CZCommentBtn *commentBtn = [CZCommentBtn commentButton];
        [_shareView addSubview:commentBtn];
        commentBtn.x = CZGetX(collectBtn);
        commentBtn.y = collectBtn.y;
        commentBtn.width = collectBtn.width;
        commentBtn.height = collectBtn.height;
        commentBtn.goodsId = self.findgoodsId;
        commentBtn.totalCommentCount = self.dicData[@"commentNum"];
    }
    return _shareView;
}

- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, - (IsiPhoneX ? 44 : 20), SCR_WIDTH,  SCR_HEIGHT)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(10, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

#pragma mark - 事件
- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 加载scrollerView
    [self.view addSubview:self.scrollerView];
    // 加载pop按钮
    [self.view addSubview:self.popButton];
    // 获取数据
    [self obtainDetailData];
}

#pragma mark - 获取数据
- (void)obtainDetailData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"findgoodsId"] = self.findgoodsId;
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/findGoods/selectById"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dicData = result[@"GoodsFindGoods"];
            // 创建内容视图
            [self setupTopView];
            // 添加分享按钮
            self.shareParam = result[@"ShareUrl"];
            [self.view addSubview:self.shareView];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 创建内容视图
- (void)setupTopView
{
    
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (NSDictionary *imageDic in self.dicData[@"imgList"]) {
        [imagePaths addObject:imageDic[@"imgPath"]];
    }
    // 轮播图
    if (imagePaths.count > 0) {
        if (imagePaths.count == 1) {
            //初始化控件
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imagePaths firstObject]] placeholderImage:IMAGE_NAMED(@"headDefault")];
            imageView.frame = CGRectMake(0, 0, SCR_WIDTH, 260);
            [self.scrollerView addSubview:imageView];
            
        } else {
            //初始化控件
            PlanADScrollView *ad =[[PlanADScrollView alloc]initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 260) imageUrls:imagePaths placeholderimage:IMAGE_NAMED(@"headDefault")];
            [self.scrollerView addSubview:ad];
        }
        
    } else {
        //初始化控件
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headDefault"]];
        imageView.frame = CGRectMake(0, 0, SCR_WIDTH, 260);
        [self.scrollerView addSubview:imageView];
    }

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, SCR_WIDTH - 20, 20)];
    titleLabel.text = self.dicData[@"title"];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [self.scrollerView addSubview:titleLabel];
    
    UILabel *subtitlte = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.x, CZGetY(titleLabel) + 10, titleLabel.width, 20)];
    subtitlte.text = self.dicData[@"smallTitle"];
    subtitlte.textColor = CZGlobalGray;
    subtitlte.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    subtitlte.numberOfLines = 0;
    [self.scrollerView addSubview:subtitlte];
    
    // 创建webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CZGetY(subtitlte), SCR_WIDTH, 100)];
    self.webView.delegate = self;
    [self.scrollerView addSubview:self.webView];
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadHTMLString:self.dicData[@"content"] baseURL:nil];
    
    // 创建点赞
    [self createLikeView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size =  [change[@"new"] CGSizeValue];
    self.webView.height = size.height;
    
    self.likeView.y = CZGetY(self.webView);
    self.scrollerView.contentSize = CGSizeMake(0, CZGetY(self.likeView));
}

#pragma mark - 创建点赞视图
- (void)createLikeView
{
    UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(self.webView), SCR_WIDTH, 207 + 44.5)];
    [self.scrollerView addSubview:likeView];
    self.likeView = likeView;
    
    /**点赞*/
    //加个分隔线
    UIView *lineView = [[UIView alloc] init];;
    lineView.y = 0;
    lineView.height = 7;
    lineView.width = likeView.width;
    lineView.backgroundColor = CZGlobalLightGray;
    [likeView addSubview:lineView];
    
    //加载点赞小手
    CZGiveLikeView *giveLikeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, lineView.height, SCR_WIDTH, 200)];
    giveLikeView.findGoodsId = self.findgoodsId;
    [likeView addSubview:giveLikeView];

    self.scrollerView.contentSize = CGSizeMake(0, CGRectGetMaxY(giveLikeView.frame));
}

- (void)sharedApplication
{
    CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
    share.param = self.shareParam;
    [self.view addSubview:share];
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL absoluteString];
    NSString *myProtocolUrl = @"http://qualityshop/?buyId=";
    if ([url hasPrefix:myProtocolUrl]) {
        NSString *alibcTradeUrlPath = [url substringFromIndex:[myProtocolUrl length]];
        // 打开淘宝
        [CZOpenAlibcTrade openAlibcTradeWithUrlString:alibcTradeUrlPath parentController:self];
        return NO;
    } else {
        return  YES;
    }
}
@end
