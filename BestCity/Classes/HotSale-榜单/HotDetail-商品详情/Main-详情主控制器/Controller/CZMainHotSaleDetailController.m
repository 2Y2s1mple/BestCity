//
//  CZMainHotSaleDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainHotSaleDetailController.h"
#import "GXNetTool.h"
#import "CZNavigationView.h"


@interface CZMainHotSaleDetailController ()

@end

@implementation CZMainHotSaleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"榨汁机榜单" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];

    [self getListData:^(NSDictionary *data) {

    }];
}

- (instancetype)getListData:(void (^)(NSDictionary *))listData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = self.ID;
    param[@"client"] = @(2);
    
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getTopCategoryDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {

        }
    } failure:^(NSError *error) {}];
    return self;
}
@end
