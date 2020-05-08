//
//  CZTaobaoSearchMainController.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZTaobaoSearchMainController.h"
#import "CZTaobaoSearchController.h"
#import "CZTaobaoSearchView.h"
#import "CZTabbaoSearchDetailController.h"
#import "CZTabbaoSearchMainDetailController.h"

@interface CZTaobaoSearchMainController () <CZHotSearchViewDelegate, CZTabbaoSearchDetailControllerDelegate, CZTaobaoSearchControllerDelegate>

/** <#注释#> */
@property (nonatomic, strong) NSArray *mainTitles;

/** 搜索框 */
@property (nonatomic, strong) CZTaobaoSearchView *searchView;
@end

@implementation CZTaobaoSearchMainController

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


- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"淘宝", @"京东", @"拼多多"];
    }
    return _mainTitles;
}

- (void)loadView
{
    [super loadView];

    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;

    self.progressHeight = 2.5;
    self.progressColor = UIColorFromRGB(0xE25838);
    self.progressViewBottomSpace = 5;

    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = UIColorFromRGB(0x202020);
    self.titleColorSelected = UIColorFromRGB(0xE25838);
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    
}

// 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - <CZHotSearchViewDelegate>
- (void)hotView:(CZTaobaoSearchView *)hotView didTextFieldChange:(CZTextField *)textField
{
//    if (textField.text.length == 0) {
//        hotView.msgTitle = @"取消";
//    } else {
//        hotView.msgTitle = @"搜索";
//    }
}

#pragma mark - CZTabbaoSearchDetailControllerDelegate
- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear
{
    if (clear) {
        //详情页面点击了清除
        self.searchView.searchText = nil;
    } else {
        
    }
}


// 创建上面的搜索框
- (CZTaobaoSearchView *)searchView
{
    if (_searchView == nil) {
        __weak typeof(self) weakSelf = self;
        self.searchView = [[CZTaobaoSearchView alloc] initWithFrame:CGRectMake(0, self.searchViewY, SCR_WIDTH, self.searchHeight) msgAction:^(NSString *rightBtnText){
            [weakSelf pushSearchDetail];
        }];
        self.searchView.textFieldBorderColor = CZGlobalGray;
        self.searchView.textFieldActive = YES;
        self.searchView.delegate = self;
        self.searchView.backgroundColor = [UIColor whiteColor];
        if (self.searchText.length > 0) {
            self.searchView.searchText = self.searchText;
        }
    
    }
    return _searchView;
}

// CZTaobaoSearchControllerDelegate
- (void)pushSearchDetailWithText:(NSString *)str
{
    self.searchView.searchText = str;
    [self pushSearchDetail];
}

// 跳转
- (void)pushSearchDetail
{

    CZTabbaoSearchMainDetailController *vc = [[CZTabbaoSearchMainDetailController alloc] init];
    
    switch (self.selectIndex) {
        case 0:
            vc.type = @"2"; // 淘宝
            break;
        case 1:
            vc.type = @"1"; // 京东
            break;
        case 2:
            vc.type = @"4"; // 多多
            break;
    }
    NSString *text = [self.searchView.searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.searchView.searchText = text;
    if (text.length > 0) {
        vc.searchText = text;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"有空格");
    }

}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            CZTaobaoSearchController *vc = [[CZTaobaoSearchController alloc] init];
            vc.type = @"2"; // 淘宝
            vc.delegate = self;
            return vc;
        }
        case 1:
        {
            CZTaobaoSearchController *vc = [[CZTaobaoSearchController alloc] init];
            vc.type = @"1"; // 京东
            vc.delegate = self;
            return vc;
        }
        case 2:
        {
            CZTaobaoSearchController *vc = [[CZTaobaoSearchController alloc] init];
            vc.type = @"4"; // 多多
            vc.delegate = self;
            return vc;
        }
        default:
        {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    return CGRectMake(0, CZGetY(self.searchView), SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, CZGetY(self.searchView) + 51, SCR_WIDTH, SCR_HEIGHT - (CZGetY(self.searchView) + 50 + (IsiPhoneX ? 34 : 0)));
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"测评--%@", info[@"title"]];
    NSLog(@"----%@", text);
    if ([info[@"title"] isEqualToString:@"关注"] || [info[@"title"] isEqualToString:@"推荐"]) {
    }
    if (![info[@"title"] isEqualToString:@"精选"]) {

    } else {
        
    }
}




@end
