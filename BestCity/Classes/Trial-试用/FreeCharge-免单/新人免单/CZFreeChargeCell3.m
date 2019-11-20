//
//  CZFreeChargeCell3.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell3.h"

@interface CZFreeChargeCell3 ()
@end

@implementation CZFreeChargeCell3
- (IBAction)freeDescAction:(id)sender {

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/new-free-desc.html"]];
    webVc.titleName = @"规则说明";
    [currentVc presentViewController:webVc animated:YES completion:nil];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeChargeCell3";
    CZFreeChargeCell3 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
