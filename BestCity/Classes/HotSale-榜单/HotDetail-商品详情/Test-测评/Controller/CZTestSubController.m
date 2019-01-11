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
        scrollerView.backgroundColor = CZGlobalWhiteBg;
        self.scrollerView = scrollerView;
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //设置scrollerView
    [self.view addSubview:self.scrollerView];
}

- (void)setModel:(CZTestDetailModel *)model
{
    _model = model;
    [self setup];
}

- (void)setup
{
    /**加载开箱测评*/
    CGFloat space = 10.0f;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 2 * space, 150, 20)];
    titleLabel.text = @"开箱测评";
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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(iconImage) + space, iconImage.y, 100, 20)];
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
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, CZGetY(nameLabel) + space, 100, 20)];
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
    self.attentionBtn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(self.view.width - (space * 2) - 60, iconImage.center.y - 12, 60, 24) CommentType:type didClickedAction:^(BOOL isSelected){
        if (isSelected) {
            [self addAttention];
        } else {
            [self deleteAttention];
        }
    }];
    [self.scrollerView addSubview:self.attentionBtn];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CZGetY(iconImage) + 2 * space, SCR_WIDTH, 100)];
    [self.scrollerView addSubview:self.webView];
    self.webView.delegate = self;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView loadHTMLString:self.model.content baseURL:nil];

    /** 点赞 */
    //加载点赞小手
    CZGiveLikeView *likeView = [[CZGiveLikeView alloc] initWithFrame:CGRectMake(0, 200, 115, 36)];
    likeView.centerX = self.view.centerX;
    likeView.type = self.type;
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [CZProgressHUD showProgressHUDWithText:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [CZProgressHUD hideAfterDelay:0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [CZProgressHUD hideAfterDelay:0];
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/delete"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            // 关注
            self.attentionBtn.type = CZAttentionBtnTypeAttention;
            [CZProgressHUD showProgressHUDWithText:@"取关成功"];
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"关注成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"关注成功"];
            self.attentionBtn.type = CZAttentionBtnTypeFollowed;
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

@end
