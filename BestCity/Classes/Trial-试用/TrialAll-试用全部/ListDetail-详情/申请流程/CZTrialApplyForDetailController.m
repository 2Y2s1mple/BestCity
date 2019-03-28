//
//  CZTrialApplyForDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialApplyForDetailController.h"

@interface CZTrialApplyForDetailController ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;
@property (nonatomic, weak) IBOutlet UILabel *label4;
@property (nonatomic, weak) IBOutlet UILabel *label5;

/** <#注释#> */
@property (nonatomic, strong) UIView *lineView;
@end

@implementation CZTrialApplyForDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label1.text = self.dataSource[@"checkRule"];
    self.label2.text = self.dataSource[@"voteGuide"];
    self.label3.text = self.dataSource[@"activitiesNote"];
    self.label4.text = self.dataSource[@"agreement"];
    self.label5.text = self.dataSource[@"activitiesProcess"];
    
    [self.view layoutIfNeeded];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.y = CZGetY([self.view.subviews lastObject]) + 20;
    lineView.height = 6;
    lineView.width = SCR_WIDTH;
    [self.view addSubview:lineView];
    lineView.backgroundColor = CZGlobalLightGray;
    self.lineView = lineView;
    
    
    self.view.x = 0;
    self.view.width = SCR_WIDTH;
    self.view.height = CZGetY(self.label5);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.lineView.y = CZGetY(self.label5) + 20;
    self.view.height = CZGetY(self.lineView);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CZTrialCommodityDetailControllerNoti" object:nil userInfo:@{@"height" : @(self.view.height)}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
