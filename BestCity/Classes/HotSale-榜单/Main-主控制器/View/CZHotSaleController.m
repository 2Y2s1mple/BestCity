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

/** <#注释#> */
@property (nonatomic, assign) void (^myBlock)(NSString *);
@end

@implementation CZHotSaleController

#pragma mark - 数据
// 获取标题数据
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

// 获取未读消息
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
#pragma mark -- end

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self obtainTtitles];

    // 设置搜索栏 获取未读数 获取标题数据
    self.setupTopView().obtainReadMessage().obtainTtitles();
    
    // 接受系统消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageRead) name:systemMessageDetailControllerMessageRead object:nil];
}

// 监听系统消息
- (void)messageRead
{
    // 获取未读数
    self.obtainReadMessage();
}

#pragma mark - 初始化
- (CZHotSaleController * (^)(void))setupTopView
{
    CZHotSaleController * (^block)(void) = ^ {
        self.search = [[CZHotSearchView alloc] initWithFrame:CGRectMake(10, IsiPhoneX ? 54 : 30, SCR_WIDTH - 20, 34) msgAction:^(NSString *title) {
            if ([JPTOKEN length] <= 0)
            {
                CZLoginController *vc = [CZLoginController shareLoginController];
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                NSString *text = @"首页消息按钮";
                NSDictionary *context = @{@"message" : text};
                [MobClick event:@"ID1" attributes:context];
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
    
    return block;
}

#pragma mark - 事件
- (void)pushSearchController
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    } else {
        NSString *text = @"首页搜索框";
        NSDictionary *context = @{@"message" : text};
        [MobClick event:@"ID1" attributes:context];
        CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [GXNetTool netWorkMaker:^(GXNetTool *marker) {
        marker.url(@"");
    } success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.obtainTtitles();
}

#pragma mark -- end

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
            return vc;
        }
        default: {
            CZTwoController *vc = [[CZTwoController alloc] init];
            vc.imageUrl = [[self.mainTitles[index].adList firstObject] objectForKey:@"img"];
            vc.subTitles = self.mainTitles[index];
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
    
    return CGRectMake(0, (IsiPhoneX ? 54 : 30) + 34 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49)));
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"榜单--%@", info[@"title"]];
    NSDictionary *context = @{@"oneTab" : text};
    [MobClick event:@"ID1" attributes:context];
    NSLog(@"%@----%@", viewController, context);
}

@end
