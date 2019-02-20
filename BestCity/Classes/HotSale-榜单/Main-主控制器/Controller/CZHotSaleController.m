//
//  CZHotSaleController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotSaleController.h"
#import "CZHotSearchView.h"
#import "CZOneController.h"
#import "CZTwoController.h"
#import "CZHotsaleSearchController.h"
#import "MJExtension.h"
#import "CZHotTitleModel.h"
#import "GXNetTool.h"
// 我的界面系统消息
#import "CZSystemMessageController.h"
#import "CZBaseRecommendController.h"

@interface CZHotSaleController ()
/** 主标题数组 */
@property (nonatomic, strong) NSArray<CZHotTitleModel *> *mainTitles;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *search;
/** 当前的偏移量 */
@property (nonatomic, assign) CGFloat currentOffsetY;
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
/** statusView */
@property (nonatomic, strong) UIView *statusView;

/** <#注释#> */
@property (nonatomic, assign) void (^myBlock)(void);
@end

@implementation CZHotSaleController

#pragma mark - 懒加载
- (UIView *)statusView
{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, (IsiPhoneX ? 44 : 20))];
        _statusView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_statusView];
    }
    return _statusView;
}

#pragma mark - 获取标题数据
- (CZHotSaleController *(^)(void))obtainTtitles
{
    return ^ {
        [CZHotTitleModel setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"children" : @"CZHotSubTilteModel"
                     };
        }];
        //获取数据
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsCategoryList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                NSArray *list = result[@"data"];
                NSMutableArray *newList = [NSMutableArray array];
                for (NSDictionary *dic in list) {
                    [newList addObject:@{@"categoryName" : dic[@"categoryName"]}];   
                }
                [[NSUserDefaults standardUserDefaults] setObject:newList forKey:@"MainTitle"];
                
                //标题的数据
                self.mainTitles = [CZHotTitleModel objectArrayWithKeyValuesArray:list];
                
                //刷新WMPage控件
                [self reloadData];
            }
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
        } failure:^(NSError *error) {
            //标题的数据
            self.mainTitles = [CZHotTitleModel objectArrayWithKeyValuesArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainTitle"]];
            //刷新WMPage控件
            [self reloadData];
            ;
        }];
        return self;
    };
}

#pragma mark - 获取未读消息
- (CZHotSaleController *(^)(void))obtainReadMessage
{
    return ^ {
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/message/count"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                // 未读消息
                self.search.unreaderCount = [result[@"data"] integerValue] > 99 ? 99 : [result[@"data"] integerValue];
            }
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
        } failure:^(NSError *error) {
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
        }];
        return self;
    };
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置搜索栏 获取未读数 获取标题数据
    self.setupTopView().obtainReadMessage().obtainTtitles();
    
    // 接受系统消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageRead) name:systemMessageDetailControllerMessageRead object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneControllerScrollViewDidScroll:) name:@"CZOneControllerScrollViewDidScroll" object:nil];
}

// 监听系统消息
- (void)messageRead
{
    // 获取未读数
    self.obtainReadMessage();
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     self.view.frame = CGRectMake(0, self.currentOffsetY, SCR_WIDTH, SCR_HEIGHT + 50);
    self.search.hidden = NO;
    self.statusView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.search.hidden = NO;
    self.statusView.hidden = YES;
}

#pragma mark - 通知: 监听scrollerView的滚动
- (void)oneControllerScrollViewDidScroll:(NSNotification *)notifx
{
    UIScrollView *scrollView = notifx.userInfo[@"scrollView"];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0 && offsetY < scrollView.contentSize.height - scrollView.height) { if (offsetY - self.recordOffsetY >= 0) {
//        NSLog(@"向上滑动");
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, -50, SCR_WIDTH, SCR_HEIGHT + 50);
                self.currentOffsetY = -50;
            }];
        } else {
//            NSLog(@"向下滑动");
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT);
                self.currentOffsetY = 0;
            }];
        }
    }
    self.recordOffsetY = offsetY;
}

#pragma mark - 初始化
- (CZHotSaleController * (^)(void))setupTopView
{
    return ^ {
        self.search = [[CZHotSearchView alloc] initWithFrame:CGRectMake(10, IsiPhoneX ? 54 : 30, SCR_WIDTH - 20, 34) msgAction:^(NSString *title){
            if ([JPTOKEN length] <= 0)
            {
                CZLoginController *vc = [CZLoginController shareLoginController];
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                CZSystemMessageController *vc = [[CZSystemMessageController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        self.search.textFieldActive = NO;
        [self.view addSubview:self.search];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchController)];
        [self.search addGestureRecognizer:tap];
        return self;
    };
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
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            CZOneController *vc = [[CZOneController alloc] init];
            vc.imageUrl = [[self.mainTitles[index].adList firstObject] objectForKey:@"img"];
            vc.titlesArray = self.mainTitles;
            self.recordOffsetY = vc.tableView.contentOffset.y;
            return vc;
        }
        default: {
            CZTwoController *vc = [[CZTwoController alloc] init];
            vc.imageUrl = [[self.mainTitles[index].adList firstObject] objectForKey:@"img"];
            vc.subTitles = self.mainTitles[index];
            self.recordOffsetY = vc.tableView.contentOffset.y;
            return vc;
        }
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    CZHotTitleModel *model = self.mainTitles[index];
    return model.categoryName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 54 : 30) + 34, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, (IsiPhoneX ? 54 : 30) + 34 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49)) + 50);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    CZBaseRecommendController *vc = viewController;
    self.recordOffsetY = vc.tableView.contentOffset.y;
}

@end
