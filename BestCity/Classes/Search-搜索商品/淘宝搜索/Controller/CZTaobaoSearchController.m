//
//  CZHotsaleSearchController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTaobaoSearchController.h"
#import "CZTaobaoSearchView.h"
#import "CZHotTagsView.h"
#import "GXNetTool.h"
#import "CZGuessWhatYouLikeView.h"
#import "CZTabbaoSearchDetailController.h"
// subviews
#import "CZTBSubOneView.h" // 收极品城

// 工具
#import "CZArrowButton.h"

@interface CZTaobaoSearchController ()<CZHotSearchViewDelegate, CZHotTagsViewDelegate, CZGuessWhatYouLikeViewDelegate, CZTabbaoSearchDetailControllerDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 搜索框 */
@property (nonatomic, strong) CZTaobaoSearchView *searchView;
/** 大家都在搜 */
@property (nonatomic, strong) CZHotTagsView *hotView;
/** 历史搜索视图 */
@property (nonatomic, strong) CZHotTagsView *historyView;
/** 显示更多 */
@property (nonatomic, strong) UIView *showAllView;

/** <#注释#> */
@property (nonatomic, strong) CZGuessWhatYouLikeView *guess;


/** 删除Btn */
@property (nonatomic, strong) CZHotTagsView *hisView1;
@property (nonatomic, strong) UIButton *btnClose;
/** 记录要删除的tag */
@property (nonatomic, assign) NSInteger recordTag;
/** search记录 */
@property (nonatomic, strong) NSMutableArray *searchArr;
/** 历史搜索记录 */
@property (nonatomic, strong) NSMutableArray *hisArr;
/** 分割线 */
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) NSString *type; // 分类（1搜索极品城，2搜索淘宝）


/** <#注释#> */
@property (nonatomic, strong) UIView *lineView;
/** 返现三部曲 */
@property (nonatomic, strong) UIView *adImageView;
@end

@implementation CZTaobaoSearchController
#pragma mark - 一些参数
// 搜索框Y值
- (CGFloat)searchViewY
{
    return (IsiPhoneX ? 54 : 30);
}

// 搜索框H值
- (CGFloat)searchHeight
{
    return 38;
}

#pragma mark - 系统的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = @"1";
    // 创建搜索栏
    [self.view addSubview:[self setupSearchView]];

    // 创建滚动视图
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取数据
     WS(weakself)
    [self getSourceData:^{
         [weakself createSubViews];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }

    self.historyView = nil;
    self.showAllView = nil;

    [self.view endEditing:YES];
}
#pragma mark - 视图
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollView.y = CZGetY([self.view.subviews lastObject]);
        _scrollView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT - _scrollView.y);
        _scrollView.contentSize = CGSizeMake(0, SCR_HEIGHT);
    }
    return _scrollView;
}

// 创建上面的搜索框
- (UIView *)setupSearchView
{
    UIView *containsView = [[UIView alloc] init];
    containsView.y = self.searchViewY;
    containsView.size = CGSizeMake(SCR_WIDTH, 100);
    __weak typeof(self) weakSelf = self;
    self.searchView = [[CZTaobaoSearchView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, self.searchHeight) msgAction:^(NSString *rightBtnText){
        [weakSelf pushSearchDetail];
    }];
    self.searchView.textFieldBorderColor = CZGlobalGray;
    self.searchView.textFieldActive = YES;
    self.searchView.delegate = self;
    self.searchView.backgroundColor = [UIColor whiteColor];
    if (self.searchText.length > 0) {
        self.searchView.searchText = self.searchText;
    }
    [containsView addSubview:self.searchView];

    // 搜淘宝按钮
    CZTBSubOneView *subOne = [[CZTBSubOneView alloc] initWithFrame:CGRectMake(0, CZGetY(self.searchView) + 22, SCR_WIDTH, 34)];
    subOne.selectIndex = 0;
    [subOne setBtnBlock:^(NSInteger index) {
        // （1搜索极品城，2搜索淘宝）
        self.type = [NSString stringWithFormat:@"%d", (index + 1)];
    }];
    [containsView addSubview:subOne];

    containsView.height = CZGetY(subOne);
    return containsView;
}

- (UIView *)adImageView
{
    if (_adImageView == nil) {
        _adImageView = [[UIView alloc] init];
        _adImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAgreement)];
        [_adImageView addGestureRecognizer:tap];
        _adImageView.width = SCR_WIDTH;
        _adImageView.height = 102;

        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = UIColorFromRGB(0xFFEFEB);
        backView.layer.cornerRadius = 8;
        backView.y = 12;
        backView.x = 15;
        backView.width = _adImageView.width - 2 * backView.x;
        backView.height = _adImageView.height - 2 * backView.y;
        [_adImageView addSubview:backView];

        UIImageView *imageS = [[UIImageView alloc] init];
        imageS.image = [UIImage imageNamed:@"Main-编组 3"];
        [imageS sizeToFit];
        imageS.centerX = backView.width / 2.0;
        imageS.centerY = backView.height / 2.0;
        [backView addSubview:imageS];
    }
    return _adImageView;
}

// 今日热搜
- (CZHotTagsView *)hotView
{
    if (_hotView == nil) {
        _hotView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, CZGetY([self.scrollView.subviews lastObject]) + 10, SCR_WIDTH, 300)];
        _hotView.type = CZHotTagLabelTypeTapGesture;
        _hotView.delegate = self;
        _hotView.title = @"今日热搜";
        _hotView.hisArray = [NSMutableArray arrayWithArray:self.searchArr];
    }
    return _hotView;
}

// 历史搜索
- (CZHotTagsView *)historyView
{
    if (_historyView == nil){
        self.historyView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, CZGetY([self.scrollView.subviews lastObject]) + 26, SCR_WIDTH, 300)];
        self.historyView.type = CZHotTagLabelTypeTapGesture;
        self.historyView.delegate = self;
        self.historyView.title = @"历史搜索";
        self.historyView.hisArray = [NSMutableArray arrayWithArray:self.hisArr];
    }
    return _historyView;
}

// 显示更多
- (UIView *)showAllView
{
    if (_showAllView == nil) {
        _showAllView = [[UIView alloc] init];
        _showAllView.y = CZGetY([self.scrollView.subviews lastObject]);
        _showAllView.width = SCR_WIDTH;
        _showAllView.height = 56;

        CZArrowButton *btn = [CZArrowButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(SCR_WIDTH, 46);
        [btn setTitle:@"更多搜索历史" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"taobaoDetail_list-right"] forState:UIControlStateNormal];
        [btn setTitle:@"收起" forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"taobaoDetail_list-right-1"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        [btn setTitleColor:UIColorFromRGB(0xCECECE) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showAllView addSubview:btn];

        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xF5F5F5);
        line.y = _showAllView.height - 10;
        line.width = SCR_WIDTH;
        line.height = 10;
        [_showAllView addSubview:line];
    }
    return _showAllView;
}

// 获取数据之后创建
- (void)createSubViews
{
    [self.scrollView addSubview:self.adImageView];

    // 创建大家都在搜
    [self.scrollView addSubview:self.hotView];

    // 创建历史搜索
    if (self.hisArr.count > 0) {
        [self.scrollView addSubview:self.historyView];
    } else {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xF5F5F5);
        line.y = CZGetY([self.scrollView.subviews lastObject]) + 14;
        line.width = SCR_WIDTH;
        line.height = 10;
        [self.scrollView addSubview:line];
    }

    // 创建显示全部
    if (self.historyView.isShow) {
        [self.scrollView addSubview:self.showAllView];
    }

    if (self.hisArr.count > 0 && !self.historyView.isShow) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xF5F5F5);
        line.y = CZGetY([self.scrollView.subviews lastObject]) + 14;
        line.width = SCR_WIDTH;
        line.height = 10;
        [self.scrollView addSubview:line];
    }

    // 猜你喜欢

    self.guess.y = CZGetY([self.scrollView.subviews lastObject]);
    [self.scrollView addSubview:self.guess];

}

- (CZGuessWhatYouLikeView *)guess
{
    if (_guess == nil) {
        CZGuessWhatYouLikeView *guess = [CZGuessWhatYouLikeView guessWhatYouLikeView];
        guess.delegate = self;
        guess.y = CZGetY([self.scrollView.subviews lastObject]);
        guess.width = SCR_WIDTH;
        guess.otherGoodsId = @"";
        [self.scrollView addSubview:guess];
        self.guess = guess;
    }
    return _guess;
}


#pragma mark - 数据
- (void)getSourceData:(void (^)(void))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/log"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"%@", result[@"data"]);
            // 大家都在搜
            self.searchArr = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"][@"hotWordList"]) {
                if (![dic[@"word"] isKindOfClass:[NSNull class]]) {
                    [self.searchArr addObject:dic[@"word"]];
                }
            }
            // 历史
            self.hisArr = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"][@"logList"]) {
                if (![dic[@"word"] isKindOfClass:[NSNull class]]) {
                    [self.hisArr addObject:dic[@"word"]];
                }
            }
            // 创建热搜
            callback();
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 详情页面的代理方法
- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear
{
    if (clear) {
        //详情页面点击了清除
        self.searchView.searchText = nil;
    } else {
        
    }
}

// 猜你喜欢的代理
- (void)reloadGuessWhatYouLikeView:(CGFloat)height
{
    self.scrollView.contentSize = CGSizeMake(0, CZGetY(self.guess) + 10);
}

// <CZHotSearchViewDelegate>
- (void)hotView:(CZTaobaoSearchView *)hotView didTextFieldChange:(CZTextField *)textField
{
//    if (textField.text.length == 0) {
//        hotView.msgTitle = @"取消";
//    } else {
//        hotView.msgTitle = @"搜索";
//    }
}

#pragma mark - 事件

// 跳转
- (void)userAgreement
{
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/tbk-rule.html"]];
    webVc.titleName = @"省钱攻略";
    [self presentViewController:webVc animated:YES completion:nil];
}

// 跳转
- (void)pushSearchDetail
{

    CZTabbaoSearchDetailController *vc = [[CZTabbaoSearchDetailController alloc] init];
    NSString *text = [self.searchView.searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.searchView.searchText = text;
    if (text.length > 0) {
        vc.searchText = text;
        vc.currentDelegate = self;
        vc.type = self.type;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"有空格");
    }

}

// 长按事件 <CZHotTagsViewDelegate>
- (void)hotTagsViewLongPressAccessoryEvent
{
}

- (void)deleteTags
{
    self.historyView.hidden = YES;
    self.showAllView.hidden = YES;
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xF5F5F5);
    line.y = CZGetY(self.hotView) + 14;
    line.width = SCR_WIDTH;
    line.height = 10;
    [self.scrollView addSubview:line];
    self.guess.y = CZGetY(line);
    self.scrollView.contentSize = CGSizeMake(0, CZGetY(self.guess) + 10);
}

// 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 点击事件 <CZHotTagsViewDelegate>
- (void)hotTagsView:(CZHotTagsView *)tagsView didSelectedTag:(CZHotTagLabel *)tagLabel
{
    NSInteger index = arc4random_uniform(100) % 2;
    NSString *text;
    if (index == 0) {
        text = @"首页搜索框--大家都在搜--第一位置";
    } else {
        text = @"首页搜索框--大家都在搜--第二位置";
    }
    NSLog(@"%@", text);
    NSDictionary *context = @{@"message" : text};
    [MobClick event:@"ID1" attributes:context];
    self.searchView.searchText = tagLabel.text;
    [self pushSearchDetail];
}



// 显示更多
- (void)showAllAction:(UIButton *)sender
{
    if (sender.isSelected) { // 默认是收起的
        sender.selected = NO;
        [self.historyView hide];
    } else {
        sender.selected = YES;
        [self.historyView showAll];
    }
    [self reloadSubViews];
}


- (void)reloadSubViews
{
    self.showAllView.y = CZGetY(self.historyView);
    self.guess.y = CZGetY(self.showAllView);
    self.scrollView.contentSize = CGSizeMake(0, CZGetY(self.guess) + 10);
}


@end
