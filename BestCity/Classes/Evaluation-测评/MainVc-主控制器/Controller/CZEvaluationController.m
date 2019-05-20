//
//  CZEvaluationController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationController.h"
#import "GXNetTool.h"
#import "CZDChoicenessController.h"
#import "CZDiscoverTitleModel.h"

@interface CZEvaluationController ()

@property (nonatomic, strong) NSArray <CZDiscoverTitleModel *> *mainTitles;
@end

@implementation CZEvaluationController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self obtainTtitles];
}

- (void)obtainTtitles
{
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/evaluation/categoryList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 获取数据
    [self obtainTtitles];
    
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
    vc.type = CZJIPINModuleEvaluation;
    vc.titleID = model.categoryId;
    vc.imageUrlList = imageList;
    return vc;        
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    CZDiscoverTitleModel *model = self.mainTitles[index];
    return model.categoryName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, HOTTitleH);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, (IsiPhoneX ? 44 : 20) + HOTTitleH, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + HOTTitleH) - (IsiPhoneX ? 83 : 49));
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"测评--%@", info[@"title"]];
    NSDictionary *context = @{@"oneTab" : text};
    [MobClick event:@"ID3" attributes:context];
    NSLog(@"----%@", text);
}

@end
