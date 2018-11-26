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

@interface CZEvaluationChoicenessDetailController ()
/** webView */
@property (nonatomic, strong) UIWebView *webView;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dicData;
/** 点赞 */
@property (nonatomic, strong) UIView *likeView;
@end

@implementation CZEvaluationChoicenessDetailController
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCR_WIDTH,  SCR_HEIGHT + 20)];
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollerView];
    [self obtainMainData];
    
    self.scrollerView.contentSize = CGSizeMake(SCR_WIDTH, SCR_HEIGHT);
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
            [self createLikeView];
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
    
    UIButton *btn = [[UIButton alloc] init];
    [imageView addSubview:btn];
    btn.y = 35;
    btn.size = CGSizeMake(50, 50);
    [btn setImage:IMAGE_NAMED(@"nav-back") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lightDarkView = [[UIView alloc] init];
    [imageView addSubview:lightDarkView];
    lightDarkView.y = imageView.height - 44;
    lightDarkView.width = imageView.width;
    lightDarkView.height = 44;
    lightDarkView.backgroundColor = [UIColor blackColor];
    lightDarkView.alpha = 0.3;
    
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

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建点赞
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
    giveLikeView.evalId = self.detailID;
    [likeView addSubview:giveLikeView];
    
    
    //加个分隔线
    UIView *lineView1 = [[UIView alloc] init];;
    lineView1.y = 207;
    lineView1.height = 0.5;
    lineView1.width = likeView.width;
    lineView1.backgroundColor = CZGlobalLightGray;
    [likeView addSubview:lineView1];
    
    // 分享的界面
    UIView *shareView = [[UIView alloc] init];
    [likeView addSubview:shareView];
    shareView.y = 207.5;
    shareView.height = 44;
    shareView.width = likeView.width;
    
    // 分享
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareView addSubview:shareBtn];
    shareBtn.y = 0;
    shareBtn.width = SCR_WIDTH / 4.0;
    shareBtn.height = shareView.height;
    [shareBtn setImage:IMAGE_NAMED(@"tab-bar") forState:UIControlStateNormal];
    
    // 收藏
    CZCollectButton *collectBtn = [CZCollectButton collectButton];
    [shareView addSubview:collectBtn];
    collectBtn.x = CZGetX(shareBtn);
    collectBtn.y = 0;
    collectBtn.width = SCR_WIDTH / 4.0;
    collectBtn.height = shareView.height;
    collectBtn.evalId = self.detailID;
    
    

    // 评论
    CZCommentBtn *commentBtn = [CZCommentBtn commentButton];
    [shareView addSubview:commentBtn];
    commentBtn.x = CZGetX(collectBtn);
    commentBtn.y = 0;
    commentBtn.width = SCR_WIDTH / 4.0;
    commentBtn.height = shareView.height;
    commentBtn.goodsId = self.detailID;
    commentBtn.totalCommentCount = self.dicData[@"commentNum"];

    // 立即购买
    UIButton *buyBtn = [[UIButton alloc] init];
    [shareView addSubview:buyBtn];
    buyBtn.x = CZGetX(commentBtn);
    buyBtn.y = 0;
    buyBtn.width = SCR_WIDTH / 4.0;
    buyBtn.height = shareView.height;
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    buyBtn.backgroundColor = CZREDCOLOR;

    
    self.scrollerView.contentSize = CGSizeMake(0, CGRectGetMaxY(likeView.frame));
}
@end
