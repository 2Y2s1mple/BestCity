//
//  CZTabbaoSearchMainDetailController.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZTabbaoSearchMainDetailController.h"
#import "CZTabbaoSearchDetailController.h"
#import "CZTaobaoSearchView.h"


@interface CZTabbaoSearchMainDetailController ()
/** <#注释#> */
@property (nonatomic, strong) NSArray *mainTitles;
/** 搜索框 */
@property (nonatomic, strong) CZTaobaoSearchView *searchView;
@end

@implementation CZTabbaoSearchMainDetailController
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
    if ([self.type  isEqual:@"2"]) { // 商品来源(1京东,2淘宝，4拼多多)
        self.selectIndex = 0;
    } else if ([self.type  isEqual:@"1"]) {
        self.selectIndex = 1;
    } else if ([self.type  isEqual:@"4"]) {
        self.selectIndex = 2;
    }

    
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

// 创建上面的搜索框
- (CZTaobaoSearchView *)searchView
{
    if (_searchView == nil) {
        __weak typeof(self) weakSelf = self;
        self.searchView = [[CZTaobaoSearchView alloc] initWithFrame:CGRectMake(0, self.searchViewY, SCR_WIDTH, self.searchHeight) msgAction:^(NSString *rightBtnText){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        self.searchView.disable = YES;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    
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
            CZTabbaoSearchDetailController *vc = [[CZTabbaoSearchDetailController alloc] init];
            vc.type = @"2"; // 淘宝
            vc.searchText = self.searchText;
            
            return vc;
        }
        case 1:
        {
            CZTabbaoSearchDetailController *vc = [[CZTabbaoSearchDetailController alloc] init];
            vc.type = @"1"; // 京东
            vc.searchText = self.searchText;
            
            return vc;
        }
        case 2:
        {
            CZTabbaoSearchDetailController *vc = [[CZTabbaoSearchDetailController alloc] init];
            vc.type = @"4"; // 多多
            vc.searchText = self.searchText;
            
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
