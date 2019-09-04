//
//  CZTestSubController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTestSubController.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "CZAttentionBtn.h"
#import "CZGiveLikeView.h"
#import "TSLWebViewController.h"

@interface CZTestSubController () <UIWebViewDelegate>
/** webView */
@property (nonatomic, strong) UIWebView *webView;
/** 分隔线 */
@property (nonatomic, strong) UIView *lineView;
/** 关注按钮 */
@property (nonatomic, strong) CZAttentionBtn *attentionBtn;
/** 监听WebView的定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 点赞 */
@property (nonatomic, strong) CZGiveLikeView *likeView;
@end

@implementation CZTestSubController

- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = CZGlobalWhiteBg;
    //设置scrollerView
    [self.view addSubview:self.scrollerView];
}

- (void)setModel:(CZTestDetailModel *)model
{
    _model = model;
    if (model != nil) {    
        [self setup];
    } else {
        [self createNodataView];
    }
}

- (void)createNodataView
{
    
    if ([self.detailTtype isEqualToString:@"1"]) {
    }
    //设置scrollerView
    CGFloat space = 14.0f;
    /**加载开箱测评*/
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 20, 150, 20)];
    titleLabel.text = @"评测报告";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [self.scrollerView addSubview:titleLabel];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.x = 0;
    contentView.y = CZGetY(titleLabel);
    contentView.width = SCR_WIDTH;
    contentView.height = 170;
    [self.scrollerView addSubview:contentView];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"评测进行中......";
    title.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    title.textColor = CZGlobalGray;
    [title sizeToFit];
    title.center = CGPointMake(contentView.width / 2.0, contentView.height / 2.0);
    [contentView addSubview:title];
    
    //加个分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(contentView), SCR_WIDTH, 7)];
    self.lineView = lineView;
    lineView.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView];
    
    self.scrollerView.height = CGRectGetMaxY(lineView.frame);
}


- (void)setup
{
    CGFloat space = 14.0f;
    if ([self.detailTtype isEqualToString:@"1"]) {
        /**加载开箱测评*/
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 20, 150, 20)];
        titleLabel.text = @"评测报告";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        [self.scrollerView addSubview:titleLabel];
        //头像
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.layer.cornerRadius = 25;
        iconImage.layer.masksToBounds = YES;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
        iconImage.frame = CGRectMake(space, CZGetY(titleLabel) + (2 * space), 50, 50);
        [self.scrollerView addSubview:iconImage];
        //名字
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(iconImage) + space, iconImage.y + 5, 100, 20)];
        nameLabel.text = self.model.user[@"nickname"];
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        [nameLabel sizeToFit];
        nameLabel.textColor = CZRGBColor(21, 21, 21);
        [self.scrollerView addSubview:nameLabel];
        //粉丝数
        if (nameLabel.width > 150) {
            nameLabel.width = 150;
        }
        UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(nameLabel) + 10, nameLabel.y, 100, 20)];
        fansLabel.text = [NSString stringWithFormat:@"粉丝数:%@", self.model.user[@"fansCount"]];
        fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        fansLabel.textColor = CZGlobalGray;
        [self.scrollerView addSubview:fansLabel];
        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, CZGetY(nameLabel), 100, 20)];
        timeLabel.text = self.model.createTime;
        timeLabel.textColor = CZGlobalGray;
        timeLabel.font = fansLabel.font;
        [self.scrollerView addSubview:timeLabel];
        
        // 关注按钮
        CZAttentionBtnType type;
        if ([self.model.user[@"follow"] integerValue] == 0) {
            type = CZAttentionBtnTypeAttention;
        } else {
            type = CZAttentionBtnTypeFollowed;
        }
        self.attentionBtn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(self.view.width - space - 60, iconImage.center.y - 12, 60, 24) CommentType:type didClickedAction:^(BOOL isSelected){
            if (isSelected) {
                [self addAttention];
            } else {
                [self deleteAttention];
            }
        }];
        [self.scrollerView addSubview:self.attentionBtn];
        
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CZGetY(iconImage) + 2 * space, SCR_WIDTH, 100)];
        self.webView.backgroundColor = [UIColor whiteColor];
        [self.scrollerView addSubview:self.webView];
        self.webView.delegate = self;
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.webView.scrollView.scrollEnabled = NO;
        [self.webView loadHTMLString:self.model.content baseURL:nil];
    } else if ([self.detailTtype isEqualToString:@"4"]) {

    } else {
        /**加载开箱测评*/
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 2 * space, SCR_WIDTH - 2 * space, 20)];
        titleLabel.numberOfLines = 0;
        titleLabel.text = self.model.title;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        [self.scrollerView addSubview:titleLabel];
        CGRect rect = [self.model.title boundingRectWithSize:CGSizeMake(SCR_WIDTH - 2 * space, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titleLabel.font} context:nil];
        CGFloat _hei = MAX(20, rect.size.height);
        titleLabel.height = _hei;

        //头像
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.layer.cornerRadius = 25;
        iconImage.layer.masksToBounds = YES;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
        iconImage.frame = CGRectMake(space, CZGetY(titleLabel) + (2 * space), 50, 50);
        [self.scrollerView addSubview:iconImage];

        //名字
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(iconImage) + space, iconImage.y + 8, 100, 20)];
        nameLabel.text = self.model.user[@"nickname"];
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        [nameLabel sizeToFit];
        nameLabel.textColor = CZRGBColor(21, 21, 21);
        [self.scrollerView addSubview:nameLabel];

        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, CZGetY(nameLabel), 160, 20)];
        timeLabel.text = self.model.createTimeStr;
        timeLabel.textColor = CZGlobalGray;
        timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        [self.scrollerView addSubview:timeLabel];
        
        // 关注按钮
        CZAttentionBtnType type;
        if ([self.model.user[@"follow"] integerValue] == 0) {
            type = CZAttentionBtnTypeAttention;
        } else {
            type = CZAttentionBtnTypeFollowed;
        }
        self.attentionBtn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(self.view.width - space - 60, iconImage.center.y - 12, 60, 24) CommentType:type didClickedAction:^(BOOL isSelected){
            if (isSelected) {
                [self addAttention];
            } else {
                [self deleteAttention];
            }
        }];
        [self.scrollerView addSubview:self.attentionBtn];

        NSLog(@"-----%ld", self.model.contentType);
        if (self.model.contentType == 3) {
            NSData *jsonData = [self.model.content dataUsingEncoding:NSUTF8StringEncoding];

            NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            CGFloat recordY = CZGetY(iconImage);
            for (NSDictionary *dic in dataArr) {
                if ([dic[@"type"]  isEqual: @"1"]) { // 文字
                    UILabel *label = [self setupTitleView];
                    label.text = dic[@"value"];
                    [label sizeToFit];
                    label.y = recordY + 20;
                    recordY += label.height + 20;
                    [self.scrollerView addSubview:label];
                } else {
                    UIImageView *bigImage = [self setupImageView];
                    CGFloat imageHeight = bigImage.width * [dic[@"height"] floatValue] / [dic[@"width"] floatValue];
                    bigImage.height = imageHeight;
                    bigImage.y = recordY + 20;
                    recordY += bigImage.height + 20;
                    [self.scrollerView addSubview:bigImage];
                    [bigImage sd_setImageWithURL:[NSURL URLWithString:dic[@"value"]] completed:nil];
                }
            }
            /** 点赞 */
            //加载点赞小手
            CZGiveLikeView *likeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, recordY + 49, 115, 36)];
            likeView.centerX = self.view.centerX;
            likeView.type = self.detailTtype;
            likeView.currentID = self.model.articleId;
            [self.scrollerView addSubview:likeView];
            self.likeView = likeView;

            //加个分隔线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.likeView.frame) + 49, SCR_WIDTH, 7)];
            self.lineView = lineView;
            lineView.backgroundColor = CZGlobalLightGray;
            [self.scrollerView addSubview:lineView];

            self.scrollerView.height = CGRectGetMaxY(lineView.frame);
            self.view.height = self.scrollerView.height;
            return;

        } else {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(4, CZGetY(iconImage) + space, SCR_WIDTH - 8, 100)];
            self.webView.backgroundColor = [UIColor whiteColor];
            [self.scrollerView addSubview:self.webView];
            self.webView.delegate = self;
            [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            self.webView.scrollView.scrollEnabled = NO;
            [self.webView loadHTMLString:self.model.content baseURL:nil];
        }
    }
    
    /** 点赞 */
    //加载点赞小手
    CZGiveLikeView *likeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, 1000, 115, 36)];
    likeView.centerX = self.view.centerX;
    likeView.type = self.detailTtype;
    likeView.currentID = self.model.articleId;
    [self.scrollerView addSubview:likeView];
    self.likeView = likeView;

    //加个分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), SCR_WIDTH, 7)];
    self.lineView = lineView;
    lineView.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView];
    
    self.scrollerView.height = CGRectGetMaxY(lineView.frame);
}

- (UILabel *)setupTitleView
{
    UILabel *label = [[UILabel alloc] init];
    label.x = 14;
    label.width = SCR_WIDTH - 24;
    label.textColor = CZBLACKCOLOR;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    return label;
}

- (UIImageView *)setupImageView
{
    UIImageView *bigImage = [[UIImageView alloc] init];
    bigImage.x = 14;
    bigImage.width = SCR_WIDTH - 24;
    bigImage.height = 200;
    return bigImage;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [CZProgressHUD showProgressHUDWithText:nil];
    [CZProgressHUD hideAfterDelay:2];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [CZProgressHUD hideAfterDelay:0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [CZProgressHUD hideAfterDelay:0];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //截取URL，这里可以和JS进行交互，但这里没有写，因为会涉及到JS的一些知识，增加复杂性
    NSString *urlString = [request.URL absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    NSLog(@"urlString=%@---urlComps=%@",urlString,urlComps);
    if ([[urlComps firstObject] isEqualToString:@"https"] || [[urlComps firstObject] isEqualToString:@"http"]) {
        TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
        [self presentViewController:webVc animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size =  [change[@"new"] CGSizeValue];
    self.webView.height = size.height;
    // 更新滚动视图
    self.likeView.y = CGRectGetMaxY(self.webView.frame) + 49;
    
    self.lineView.y = CGRectGetMaxY(self.likeView.frame) + 49;
    self.scrollerView.height = CGRectGetMaxY(self.lineView.frame);
    self.view.height = self.scrollerView.height;
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenBoxInspectWebHeightKey object:nil userInfo:@{@"height" : @(self.scrollerView.height)}];
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

#pragma mark - 取消关注
- (void)deleteAttention
{
    if ([JPTOKEN length] <= 0) {
    CZLoginController *vc = [CZLoginController shareLoginController];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    [tabbar presentViewController:vc animated:NO completion:^{
        UINavigationController *nav = tabbar.selectedViewController;
        UIViewController *currentVc = nav.topViewController;
        [currentVc.navigationController popViewControllerAnimated:nil];
    }];
    return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/delete"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            // 关注
            self.attentionBtn.type = CZAttentionBtnTypeAttention;
            [CZProgressHUD showProgressHUDWithText:@"取关成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"discoverAttentionChangeNOtification" object:nil userInfo:@{@"value" : @(0)}];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 新增关注
- (void)addAttention
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:^{
            UINavigationController *nav = tabbar.selectedViewController;
            UIViewController *currentVc = nav.topViewController;
            [currentVc.navigationController popViewControllerAnimated:nil];
        }];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"关注成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"关注成功"];
            self.attentionBtn.type = CZAttentionBtnTypeFollowed;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"discoverAttentionChangeNOtification" object:nil userInfo:@{@"value" : @(1)}];
            
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)setIsAttentionUser:(BOOL)isAttentionUser
{
    _isAttentionUser = isAttentionUser;
    if (isAttentionUser) {
        self.attentionBtn.type = CZAttentionBtnTypeFollowed; // 关注
    } else {
        self.attentionBtn.type = CZAttentionBtnTypeAttention; // 未关注
    }
}

@end
