//
//  CZvoteUserController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZvoteUserController.h"
#import "CZNavigationView.h"
#import "UIButton+WebCache.h"
#import "CZSubButton.h"
// 工具
#import "GXNetTool.h"


@interface CZvoteUserController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topY;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLbel;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *topView;
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollerView;

/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation CZvoteUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"申请成功名单" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
    
    self.topY.constant = CZGetY(navigationView);
    
    
    NSString *text = [NSString stringWithFormat:@"请以下用户于 %@ 前完成众测报告", self.dataSource[@"reportEndTime"]];
    self.titleLbel.textColor = UIColorFromRGB(0x151515);
    self.titleLbel.attributedText = [text addAttributeColor:CZREDCOLOR Range:[text rangeOfString:self.dataSource[@"reportEndTime"]]];
    
   
    [self reloadNewTrailDataSorce];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollerView.x = 0;
    self.scrollerView.y = CZGetY(self.topView);
    self.scrollerView.width = SCR_WIDTH;
    self.scrollerView.height = SCR_HEIGHT - self.topView.y;
}

#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"trialId"] = self.dataSource[@"id"]; 
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/passedUserList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataArr = result[@"data"];
            [self setupTopView];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)setupTopView
{
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    self.scrollerView = scrollerView;
    scrollerView.x = 0;
    scrollerView.y = CZGetY(self.topView);
    scrollerView.width = SCR_WIDTH;
    scrollerView.height = SCR_HEIGHT - self.topView.y;
    [self.view addSubview:scrollerView];
    
    NSArray *list = self.dataArr;
    
    for (int i = 0; i < list.count; i++) {
        UIView *backView = [[UIView alloc] init];
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        [btn sd_setImageWithURL:[NSURL URLWithString:list[i][@"userAvatar"]] forState:UIControlStateNormal];
        [btn setTitle:list[i][@"userNickname"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backView addSubview:btn];
        
        backView.height = 90;
        backView.width = SCR_WIDTH / 3.0;
        backView.x = (i % 3) * (SCR_WIDTH / 3.0);
        backView.y = (i / 3) * backView.height;
        
        btn.size = CGSizeMake(40, 40);
        btn.center = CGPointMake(backView.width / 2.0, backView.height / 2.0);
        btn.imageView.layer.cornerRadius = btn.width / 2.0;
        btn.imageView.layer.masksToBounds = YES;
        
        [scrollerView addSubview:backView];
        
        scrollerView.contentSize = CGSizeMake(0, CZGetY(backView));
    }
}
@end
