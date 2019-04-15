//
//  CZMyPointsDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyPointsDetailController.h"
#import "UIButton+CZExtension.h" // 按钮扩展
#import "GXNetTool.h"
#import "CZScollerImageTool.h"
#import "CZNavigationView.h"
#import "CZAffirmPointController.h"
#import "CZCoinCenterController.h"

@interface CZMyPointsDetailController () <UIScrollViewDelegate, UIWebViewDelegate>
/** 数据 */
@property (nonatomic, strong) NSDictionary *dataSource;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
/** webView */
@property (nonatomic, strong) UIWebView *webView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *buyBtn;
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
/** <#注释#> */
@property (nonatomic, strong) UIView *navigationView;
@end

static CGFloat const likeAndShareHeight = 49;

@implementation CZMyPointsDetailController
#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? -44 : -20), SCR_WIDTH, SCR_HEIGHT - likeAndShareHeight - (IsiPhoneX ? -44 : -20) - (IsiPhoneX ? 34 : 0))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
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

- (UIButton *)buyBtn
{
    if (_buyBtn == nil) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [_buyBtn setBackgroundColor:CZREDCOLOR];
        [_buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.x = 0;
        _buyBtn.y = SCR_HEIGHT - likeAndShareHeight - (IsiPhoneX ? 34 : 0);
        _buyBtn.width = SCR_WIDTH;
        _buyBtn.height = likeAndShareHeight;
    }
    return _buyBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取数据
    [self getDataSource];
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    // 加载pop按钮
    [self.view addSubview:self.popButton];
    
    [self.view addSubview:self.buyBtn];
    
    //导航条
    UIView *navigationBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67 + (IsiPhoneX ? 24 : 0))];
    navigationBackView.backgroundColor = [UIColor whiteColor];
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"商品详情" rightBtnTitle:nil rightBtnAction:nil navigationViewType:nil];
    navigationView.backgroundColor = [UIColor whiteColor];
    [navigationBackView addSubview:navigationView];
    [self.view addSubview:navigationBackView];
    self.navigationView = navigationBackView;
    self.navigationView.hidden = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0 && offsetY < scrollView.contentSize.height - scrollView.height) {
        if (offsetY >= 120) {
            self.navigationView.hidden = NO;
            
        } else {
            self.navigationView.hidden = YES;
        }
    }
    self.recordOffsetY = offsetY;
}

- (void)setupSubViews 
{
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_WIDTH)];
    [self.scrollerView addSubview:imageView];
    imageView.imgList = self.dataSource[@"imgList"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CZGetY(imageView) + 16, SCR_WIDTH - 28, 100)];
    titleLabel.text = self.dataSource[@"goodsName"];
    titleLabel.textColor = CZBLACKCOLOR;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    // label自动算高
    CGRect rect = [titleLabel.text boundingRectWithSize:CGSizeMake(titleLabel.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titleLabel.font} context:nil];
    titleLabel.height = rect.size.height;
    [self.scrollerView addSubview:titleLabel];
    
    // 钱数
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.x = 14;
    moneyLabel.y = CZGetY(titleLabel) + 16;
    moneyLabel.width = titleLabel.width;
    moneyLabel.height = 20;
    moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    moneyLabel.text = [NSString stringWithFormat:@"%@极币", self.dataSource[@"exchangePoint"]];
    moneyLabel.textColor = CZREDCOLOR;
    [self.scrollerView addSubview:moneyLabel];
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.x = 14;
    timeLabel.y = CZGetY(moneyLabel) + 16;
    timeLabel.width = moneyLabel.width;
    timeLabel.height = 20;
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    timeLabel.text = [NSString stringWithFormat:@"有效期%@至%@", [self.dataSource[@"startTime"] substringToIndex:10], [self.dataSource[@"endTime"]substringToIndex:10]];
    timeLabel.textColor = CZGlobalGray;
    [self.scrollerView addSubview:timeLabel];
    
    // 创建分隔线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(timeLabel) + 16, SCR_WIDTH, 7)];
    lineView2.backgroundColor = CZGlobalLightGray;
    [self.scrollerView addSubview:lineView2];
    
    //标题
    UILabel *webTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CZGetY(lineView2) + 38, 150, 20)];
    webTitleLabel.text = @"商品详情";
    webTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [self.scrollerView addSubview:webTitleLabel];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CZGetY(webTitleLabel) + 20, SCR_WIDTH, 100)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:self.webView];
    self.webView.delegate = self;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.opaque = NO;
    [self.webView loadHTMLString:self.dataSource[@"content"] baseURL:nil];
    
    if ([JPUSERINFO[@"point"] integerValue] < [self.dataSource[@"exchangePoint"] integerValue]) {
        [self.buyBtn setBackgroundColor:CZREDCOLOR];
        [_buyBtn setTitle:@"极币不足 去赚取" forState:UIControlStateNormal];
    } else if ([self.dataSource[@"total"] isEqual: @(0)]) {
        [self.buyBtn setBackgroundColor:CZGlobalGray];
        self.buyBtn.enabled = NO;
        [_buyBtn setTitle:@"已售空" forState:UIControlStateNormal];
    }  else if ([self.dataSource[@"hasBuy"] isEqual: @(1)]) { // 0未购买，1已购买
        [self.buyBtn setBackgroundColor:CZGlobalGray];
        self.buyBtn.enabled = NO;
        [_buyBtn setTitle:@"已兑换（新人仅享兑换一次)" forState:UIControlStateNormal];
    }
    
    
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size =  [change[@"new"] CGSizeValue];
    self.webView.height = size.height;
    // 更新滚动视图
    self.scrollerView.contentSize = CGSizeMake(0, CZGetY(self.webView));
}


#pragma mark - 获取数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"pointGoodsId"] = self.pointId;
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/point/getGoodsInfo"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];
            
            [self setupSubViews]; 
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 时间
// 购买按钮事件
- (void)buyBtnAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"极币不足 去赚取"]) {
        CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CZAffirmPointController *vc = [[CZAffirmPointController alloc] init];
        vc.dataSource = self.dataSource;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
