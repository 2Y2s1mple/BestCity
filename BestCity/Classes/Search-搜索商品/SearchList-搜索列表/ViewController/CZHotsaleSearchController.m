//
//  CZHotsaleSearchController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotsaleSearchController.h"
#import "CZHotsaleSearchDetailController.h"
#import "CZHotSearchView.h"
#import "CZHotTagsView.h"
#import "GXNetTool.h"
#import "CZGuessWhatYouLikeView.h"

@interface CZHotsaleSearchController ()<hotsaleSearchDetailControllerDelegate, CZHotSearchViewDelegate, CZHotTagsViewDelegate, CZGuessWhatYouLikeViewDelegate>

/** 历史搜索视图 */
@property (nonatomic, strong) CZHotTagsView *hisView;
/** 历史搜索视图 */
@property (nonatomic, strong) CZHotTagsView *hisView1;
/** 删除Btn */
@property (nonatomic, strong) UIButton *btnClose;
/** 记录要删除的tag */
@property (nonatomic, assign) NSInteger recordTag;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *searchView;
/** search记录 */
@property (nonatomic, strong) NSMutableArray *searchArr;
/** 历史搜索记录 */
@property (nonatomic, strong) NSMutableArray *hisArr;
/** 分割线 */
@property (nonatomic, strong) UIView *line;
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CZHotsaleSearchController
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

#pragma mark - 数据
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
#pragma mark -- end

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建搜索栏
    [self setupSearchView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取数据
    [self getSourceData];
}

- (void)getSourceData
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
                [self.searchArr addObject:dic[@"word"]];
            }
            // 历史
            self.hisArr = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"][@"logList"]) {
                [self.hisArr addObject:dic[@"word"]];
            }
            // 创建大家都在搜
            [self createHistorySearchModule];
            // 创建历史搜索
            [self createHotSearchModule];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 创建搜索及代理方法
- (void)setupSearchView
{
    __weak typeof(self) weakSelf = self;
    self.searchView = [[CZHotSearchView alloc] initWithFrame:CGRectMake(0, self.searchViewY, SCR_WIDTH, self.searchHeight) msgAction:^(NSString *rightBtnText){
        [weakSelf pushSearchDetail];
    }];
    self.searchView.textFieldBorderColor = CZGlobalGray;
    self.searchView.textFieldActive = YES;
    self.searchView.delegate = self;
    self.searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];


    for (int i = 0; i < 2; i++) {
        UIButton *btn1 = [[UIButton alloc] init];
        btn1.y = CZGetY(self.searchView) + 22;

        [btn1 setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateSelected];
        [btn1 setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        btn1.width = SCR_WIDTH / 2.0;
        btn1.height = 25;
        btn1.x = i * btn1.width;
        [self.view addSubview:btn1];

        UIView *btnLine = [[UIView alloc] init];
        btnLine.tag = 100;
        btnLine.y = btn1.height + 5;
        btnLine.width = 65;
        btnLine.height = 3;
        btnLine.centerX = btn1.width / 2.0;
        btnLine.backgroundColor = UIColorFromRGB(0xE25838);
        [btn1 addSubview:btnLine];
        if (i == 1) {
            [btn1 setTitle:@"搜淘宝" forState:UIControlStateNormal];
            btnLine.hidden = YES;
            btn1.selected = NO;
        } else {
            [btn1 setTitle:@"搜极品城" forState:UIControlStateNormal];
            btn1.selected = YES;
        }
    }
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(self.searchView) + 25 + 5 + 3 + 22, SCR_WIDTH, 1)];
    self.line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:self.line];

    [self.view addSubview:self.scrollView];
    self.scrollView.y = CZGetY(self.line);
    self.scrollView.width = SCR_WIDTH;
    self.scrollView.height = SCR_HEIGHT - self.scrollView.y;

    UIView *imageBackView = [[UIView alloc] init];
    imageBackView.backgroundColor = UIColorFromRGB(0xFFEFEB);
    [self.scrollView addSubview:imageBackView];

    UIImageView *imageS = [[UIImageView alloc] init];
    imageS.image = [UIImage imageNamed:@"Main-编组 3"];
    [self.scrollView addSubview:imageS];
    [imageS sizeToFit];
    imageS.y = 20;
    imageS.centerX = SCR_WIDTH / 2.0;

    imageBackView.width = imageS.width + 30;
    imageBackView.height = imageS.height + 20;
    imageBackView.y = imageS.y - 10;
    imageBackView.centerX = imageS.centerX;
}

// <CZHotSearchViewDelegate>
- (void)hotView:(CZHotSearchView *)hotView didTextFieldChange:(CZTextField *)textField
{
//    if (textField.text.length == 0) {
//        hotView.msgTitle = @"取消";
//    } else {
//        hotView.msgTitle = @"搜索";
//    }
}

#pragma mark - 创建大家都在搜, 历史搜索及代理方法
// 大家都在搜
- (void)createHistorySearchModule
{
    self.hisView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, 110, SCR_WIDTH, 300)];
    self.hisView.type = CZHotTagLabelTypeTapGesture;
    self.hisView.delegate = self;
    self.hisView.title = @"今日热搜";
    self.hisView.hisArray = [NSMutableArray arrayWithArray:self.searchArr];
    [self.scrollView addSubview:_hisView];
}

// 历史搜索
- (void)createHotSearchModule
{

    CZHotTagsView *hisView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, CZGetY(self.hisView) + 32 + 26, SCR_WIDTH, 300)];
    self.hisView1 = hisView;
    hisView.type = CZHotTagLabelTypeTapGesture;
    hisView.delegate = self;
    hisView.title = @"历史搜索";
    hisView.hisArray = [NSMutableArray arrayWithArray:self.hisArr];
    [self.scrollView addSubview:self.hisView1];

    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.frame = CGRectMake(SCR_WIDTH - 26- 17, hisView.y, 26, 25);
    [deleteBtn setImage:[UIImage imageNamed:@"delete-2"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:deleteBtn];

    NSLog(@"%ld", hisView.lineNumber);

     [self.hisArr removeObjectsInRange:NSMakeRange(hisView.lineNumber, self.hisArr.count - hisView.lineNumber)];
    hisView.hisArray = self.hisArr;

    if (hisView.lineNumber > 0) {
        UIButton *showAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [showAll setTitle:@"更多搜索历史" forState:UIControlStateNormal];
        [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right"] forState:UIControlStateNormal];
        [showAll setTitle:@"收起" forState:UIControlStateSelected];
        [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right-1"] forState:UIControlStateSelected];
        showAll.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        [showAll setTitleColor:UIColorFromRGB(0xCECECE) forState:UIControlStateNormal];
        [self.scrollView addSubview:showAll];
        showAll.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
        showAll.titleEdgeInsets = UIEdgeInsetsMake(0, -28, 0, 0);
        [showAll sizeToFit];
        showAll.y = CZGetY(hisView) + 20;
        showAll.centerX = SCR_WIDTH / 2.0;

        self.scrollView.contentSize = CGSizeMake(0, CZGetY(showAll) + 10);
    } else {
        self.scrollView.contentSize = CGSizeMake(0, CZGetY(hisView));
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    lineView.y = CZGetY([self.scrollView.subviews lastObject]) + 10;
    lineView.height = 10;
    lineView.width = SCR_WIDTH;
    [self.scrollView addSubview:lineView];

    // 猜你喜欢
    [self guessView];

}


// 猜你喜欢
- (void)guessView
{
    CZGuessWhatYouLikeView *guess = [CZGuessWhatYouLikeView guessWhatYouLikeView];
    guess.delegate = self;
    guess.y = CZGetY([self.scrollView.subviews lastObject]);
    guess.width = SCR_WIDTH;
    guess.otherGoodsId = @"";

    [self.scrollView addSubview:guess];

}


- (void)reloadGuessWhatYouLikeView
{
    self.scrollView.contentSize = CGSizeMake(0, CZGetY([self.scrollView.subviews lastObject]) + 10);
}



#pragma mark - 全部删除
- (void)deleteAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除全部历史记录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [CZProgressHUD showProgressHUDWithText:nil];
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/deleteAll"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                [self reloadData];
            }        
        } failure:^(NSError *error) {}];
    }]];
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
}

- (void)reloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/log"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 历史
            self.hisArr = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"][@"logList"]) {
                [self.hisArr addObject:dic[@"word"]];
            }
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
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

// 长按事件 <CZHotTagsViewDelegate>
- (void)hotTagsViewLongPressAccessoryEvent
{
//    // 大家都在搜
//    self.hotView.frame = CGRectMake(0, CZGetY(self.hisView) + 20, SCR_WIDTH, 300);
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - <>详情页面的代理方法
- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear
{
    if (clear) {
        //详情页面点击了清除
        self.searchView.searchText = nil;
    } else {
        
    }
//    if (self.searchView.searchText) {
//        self.searchView.msgTitle = @"搜索";
//    } else {
//        self.searchView.msgTitle = @"取消";
//    }
}
#pragma mark - 跳转
- (void)pushSearchDetail
{
    CZHotsaleSearchDetailController *vc = [[CZHotsaleSearchDetailController alloc] init];
    vc.textTitle = self.searchView.searchText;
    vc.type = @"1";
    vc.currentDelegate = self;
    WMPageController *hotVc = (WMPageController *)vc;
    hotVc.selectIndex = 0;
    hotVc.menuViewStyle = WMMenuViewStyleDefault;
    //        hotVc.progressWidth = 30;
    hotVc.itemMargin = 10;
//    hotVc.progressHeight = 3;
    hotVc.automaticallyCalculatesItemWidths = YES;
    hotVc.titleFontName = @"PingFangSC-Medium";
    hotVc.titleColorNormal = CZGlobalGray;
    hotVc.titleColorSelected = CZRGBColor(5, 5, 5);
    hotVc.titleSizeNormal = 16.0f;
    hotVc.titleSizeSelected = 16;
    hotVc.progressColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
