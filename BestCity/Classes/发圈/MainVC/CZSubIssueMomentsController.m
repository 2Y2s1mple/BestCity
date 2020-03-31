//
//  CZSubIssueMomentsController.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSubIssueMomentsController.h"
#import "GXNetTool.h"
#import "CZSubSubIssueMomentsListController.h"

@interface CZSubIssueMomentsController ()
/** <#注释#> */
@property (nonatomic, strong) NSArray *mainDataSource;
@end

@implementation CZSubIssueMomentsController
- (void)loadView
{
    [super loadView];
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;

//    self.progressHeight = 2.5;
//    self.progressColor = UIColorFromRGB(0xFFD224);
//    self.progressViewBottomSpace = 5;
    self.itemMargin = 20;
    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = UIColorFromRGB(0x565252);
    self.titleColorSelected = UIColorFromRGB(0xE25838);
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.mainDataSource.count <= 0) {
        [self getTitles];
    }
}

#pragma mark - 获取数据
// 获取标题数据
- (void)getTitles
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.paramType;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/moment/categoryList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.mainDataSource = result[@"data"];
            [self reloadData];
        }
    } failure:^(NSError *error) {

    }];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.self.mainDataSource.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainDataSource[index][@"title"];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            CZSubSubIssueMomentsListController *vc = [[CZSubSubIssueMomentsListController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            vc.paramType = self.paramType;
            vc.paramCategoryId1 = self.mainDataSource[index][@"id"];
            vc.categoryView2Data = self.mainDataSource[index][@"children"];
            return vc;
        }
        default:
        {
            CZSubSubIssueMomentsListController *vc = [[CZSubSubIssueMomentsListController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            vc.paramType = self.paramType;
            vc.paramCategoryId1 = self.mainDataSource[index][@"id"];
            vc.categoryView2Data = self.mainDataSource[index][@"children"];
//            UIViewController *vc = [[UIViewController alloc] init];
//            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
    }
}



- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
//    menuView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    return CGRectMake(0, 0, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 50, SCR_WIDTH, self.view.height - 50);
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"测评--%@", info[@"title"]];
    NSLog(@"----%@", text);
    if ([info[@"title"] isEqualToString:@"关注"] || [info[@"title"] isEqualToString:@"推荐"]) {
    }
    if (![info[@"title"] isEqualToString:@"精选"]) {

    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"starScrollAd" object:nil];
    }
}


@end
