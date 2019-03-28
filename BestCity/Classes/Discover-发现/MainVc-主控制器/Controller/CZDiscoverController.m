//
//  CZDiscoverController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDiscoverController.h"
#import "CZDChoicenessController.h"
#import "GXNetTool.h"
#import "CZDiscoverTitleModel.h"

#import "CZHotSearchView.h"
#import "CZBaseRecommendController.h"
#import "CZHotsaleSearchController.h"


@interface CZDiscoverController ()
@property (nonatomic, strong) NSArray *mainTitles;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *search;
/** 当前的偏移量 */
@property (nonatomic, assign) CGFloat currentOffsetY;
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
/** statusView */
@property (nonatomic, strong) UIView *statusView;
@end

@implementation CZDiscoverController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self obtainTtitles];
}

- (void)obtainTtitles
{
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/found/categoryList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            //标题的数据
            self.mainTitles = [CZDiscoverTitleModel objectArrayWithKeyValuesArray:result[@"data"]];
            
            //刷新WMPage控件
            [self reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    self.view.backgroundColor = CZGlobalWhiteBg;
    
    // 获取标题
    [self obtainTtitles];
    
    // 设置搜索栏
    [self setupTopView];
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, (IsiPhoneX ? 44 : 20))];
    statusView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:statusView];
    self.statusView = statusView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneControllerScrollViewDidScroll:) name:@"CZOneControllerScrollViewDidScroll" object:nil];
    
    self.scrollView.scrollEnabled = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, self.currentOffsetY, SCR_WIDTH, SCR_HEIGHT + 50);
    self.statusView.hidden = NO;
}


//- (void)viewWillLayoutSubviews
//{
//    self.view.frame = CGRectMake(0, self.currentOffsetY, SCR_WIDTH, SCR_HEIGHT + 50);
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.search.hidden = NO;
    self.statusView.hidden = YES;
}

#pragma mark - 初始化
- (void)setupTopView
{
    CZTextField *textF = [[CZTextField alloc] initWithFrame:CGRectMake(10, IsiPhoneX ? 54 : 30, SCR_WIDTH - 20, 34)];
    [self.view addSubview:textF];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchController)];
    [textF addGestureRecognizer:tap];
}

#pragma mark - 响应事件
- (void)pushSearchController
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    CZDiscoverTitleModel *model = self.mainTitles[index];
    NSMutableArray *imageList = [NSMutableArray array];
    for (NSDictionary *dic in model.adList) {
        [imageList addObject:dic[@"img"]];
    }
    CZDChoicenessController *vc = [[CZDChoicenessController alloc] init];
    vc.type = CZJIPINModuleDiscover;
    vc.titleID = model.categoryId;
    vc.imageUrlList = imageList;
    return vc;      
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    CZDiscoverTitleModel *model = self.mainTitles[index];
    return model.categoryName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 54 : 30) + 34, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, (IsiPhoneX ? 54 : 30) + 34 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49)) + 50);
}

//- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
//{
//    CZBaseRecommendController *vc = viewController;
//    self.recordOffsetY = vc.tableView.contentOffset.y;
//}

#pragma mark - 通知: 监听scrollerView的滚动
- (void)oneControllerScrollViewDidScroll:(NSNotification *)notifx
{
    UIScrollView *scrollView = notifx.userInfo[@"scrollView"];
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0 && offsetY < scrollView.contentSize.height - scrollView.height) {
        if (offsetY - self.recordOffsetY >= 0) {
            NSLog(@"向上滑动");
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, -50, SCR_WIDTH, SCR_HEIGHT + 50);
                self.currentOffsetY = -50;
            }];
        } else {
            NSLog(@"向下滑动");

            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT);
                self.currentOffsetY = 0;
            }];
        } 
    }
    self.recordOffsetY = offsetY;
}

@end
