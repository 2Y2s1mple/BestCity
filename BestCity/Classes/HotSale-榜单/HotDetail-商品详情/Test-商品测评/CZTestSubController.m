//
//  CZTestSubController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTestSubController.h"

@interface CZTestSubController ()
/** webView */
@property (nonatomic, strong) UIWebView *webView;
/** 分隔线 */
@property (nonatomic, strong) UIView *lineView;
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

- (void)setModel:(CZRecommendDetailModel *)model
{
    _model = model;
    [self setup];
}

- (void)setup
{
    /**加载开箱测评*/
    CGFloat space = 10.0f;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 2 * space, 100, 20)];
    titleLabel.text = @"开箱测评";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [self.scrollerView addSubview:titleLabel];
    //头像
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head3"]];
    iconImage.frame = CGRectMake(space, CZGetY(titleLabel) + (2 * space), 50, 50);
    [self.scrollerView addSubview:iconImage];
    //名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(iconImage) + space, iconImage.y, 70, 20)];
    nameLabel.text = @"资深编辑";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = CZRGBColor(21, 21, 21);
    [self.scrollerView addSubview:nameLabel];
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, CZGetY(nameLabel) + space, 100, 20)];
    timeLabel.text = @"2018.09.21";
    timeLabel.textColor = CZGlobalGray;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollerView addSubview:timeLabel];
    //粉丝数
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(nameLabel) + space, nameLabel.y, 100, 20)];
    fansLabel.text = @"粉丝数:376";
    fansLabel.font = [UIFont systemFontOfSize:14];
    fansLabel.textColor = CZGlobalGray;
    [self.scrollerView addSubview:fansLabel];
    //关注按钮
    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [attentionBtn setTitle:@"已关注" forState:UIControlStateHighlighted];
    attentionBtn.frame = CGRectMake(self.view.width - (space * 2) - 60, iconImage.center.y - 12, 60, 24);
    [attentionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [attentionBtn setTitleColor:CZGlobalGray forState:UIControlStateHighlighted];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    attentionBtn.layer.borderWidth = 0.5;
    attentionBtn.layer.cornerRadius = 13;
    attentionBtn.layer.borderColor = [UIColor redColor].CGColor;
    [self.scrollerView addSubview:attentionBtn];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CZGetY(iconImage) + 2 * space, SCR_WIDTH, 100)];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.backgroundColor = [UIColor greenColor];
    [self.webView loadHTMLString:self.model.goodsEvalWayEntity[@"content"] baseURL:nil];
    [self.scrollerView addSubview:self.webView];
    
    /**点赞*/
    //加个分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), SCR_WIDTH, 7)];
    self.lineView = lineView;
    lineView.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView];
    
    
    self.scrollerView.height = CGRectGetMaxY(lineView.frame);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size =  [change[@"new"] CGSizeValue];
    self.webView.height = size.height;
    // 更新滚动视图
    self.lineView.y = CGRectGetMaxY(self.webView.frame);
    self.scrollerView.height = CGRectGetMaxY(self.lineView.frame);
    self.view.height = self.scrollerView.height;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenBoxInspectWebHeightKey object:nil userInfo:@{@"height" : @(self.scrollerView.height)}];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

@end
