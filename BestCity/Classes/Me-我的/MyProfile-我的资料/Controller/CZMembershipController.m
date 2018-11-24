//
//  CZMembershipController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/2.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMembershipController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"

@interface CZMembershipController ()
/** 头像 */
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
/** 会员等级 */
@property (nonatomic, weak) IBOutlet UILabel *shipLabel;
/** 下面文字 */
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
/** 一共的积分 */
@property (nonatomic, strong) NSString *totalPoint;
@end

@implementation CZMembershipController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"会员中心" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    // 设置头像
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.masksToBounds = YES;
    
    // 获取历史一共的积分数据
    [self getDataSource];
}

#pragma mark - 获取历史一共的积分数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/totalAddPoint"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.totalPoint = result[@"totalAddPoint"];
            [self getupUserInfo];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)getupUserInfo
{
    // 头像
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:USERINFO[@"userNickImg"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    
    // 会员等级
    self.shipLabel.text = [@"V" stringByAppendingFormat:@"%@", USERINFO[@"userMemberGrade"] ? USERINFO[@"userMemberGrade"] : @"0"];
    
    // 确定下一级
    NSUInteger nextsShipNum = [USERINFO[@"userMemberGrade"] integerValue] + 1;
    // 剩余积分
    NSInteger residuePoint = 0;
    switch (nextsShipNum) {
        case 1:
            residuePoint = 1000 - [self.totalPoint integerValue];
            break;
        case 2:
            residuePoint = 3000 - [self.totalPoint integerValue];
            break;
        case 3:
            residuePoint = 5000 - [self.totalPoint integerValue];
            break;
        case 4:
            residuePoint = 7000 - [self.totalPoint integerValue];
            break;
        case 5:
            residuePoint = 10000 - [self.totalPoint integerValue];
            break;
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"还需要%ld积分可升级到v%ld", residuePoint, nextsShipNum];
    
}


@end
