//
//  CZOrderListHeaderView.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/10.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZOrderListHeaderView.h"
#import "CZCoinCenterController.h"

@interface CZOrderListHeaderView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *pointLabel;

@end

@implementation CZOrderListHeaderView

+ (instancetype)orderListHeaderView
{
    CZOrderListHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.pointLabel.text = [NSString stringWithFormat:@"%@", JPUSERINFO[@"point"]];

}

// 购买按钮事件
- (IBAction)buyBtnAction:(UIButton *)sender
{
    CURRENTVC(currentVc);
    CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}
@end
