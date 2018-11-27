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
@end

@implementation CZDChoiceDetailController


- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCR_WIDTH,  SCR_HEIGHT + 20)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //设置scrollerView
    [self.view addSubview:self.scrollerView];
    
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
    
    
    
    UIButton *leftBtn = [UIButton buttonWithFrame:CGRectMake(10, 30, 50, 50) backImage:@"nav-back" target:self action:@selector(popAction)];
    [self.scrollerView addSubview:leftBtn];
    
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

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    //加个分隔线
    UIView *lineView1 = [[UIView alloc] init];;
    lineView1.y = 207;
    lineView1.height = 1;
    lineView1.width = likeView.width;
    lineView1.backgroundColor = CZGlobalLightGray;
    [likeView addSubview:lineView1];
    
    // 分享的界面
    UIView *shareView = [[UIView alloc] init];
    [likeView addSubview:shareView];
    shareView.y = 207.5;
    shareView.height = 44;
    shareView.width = likeView.width;
    
    CGFloat btnWidth = SCR_WIDTH / 3.0;
    
    // 分享
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareView addSubview:shareBtn];
    shareBtn.y = 0;
    shareBtn.width = btnWidth;
    shareBtn.height = shareView.height;
    [shareBtn setImage:IMAGE_NAMED(@"tab-bar") forState:UIControlStateNormal];
    
    // 收藏
    CZCollectButton *collectBtn = [CZCollectButton collectButton];
    [shareView addSubview:collectBtn];
    collectBtn.x = CZGetX(shareBtn);
    collectBtn.y = 0;
    collectBtn.width = btnWidth;
    collectBtn.height = shareView.height;
    collectBtn.findGoodsId = self.findgoodsId;
    
    // 评论
    CZCommentBtn *commentBtn = [CZCommentBtn commentButton];
    [shareView addSubview:commentBtn];
    commentBtn.x = CZGetX(collectBtn);
    commentBtn.y = 0;
    commentBtn.width = btnWidth;
    commentBtn.height = shareView.height;
    commentBtn.goodsId = self.findgoodsId;
    commentBtn.totalCommentCount = self.dicData[@"commentNum"];
    

    
    
    self.scrollerView.contentSize = CGSizeMake(0, CGRectGetMaxY(likeView.frame));
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", [request.URL absoluteString]);
    return  YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}





@end
