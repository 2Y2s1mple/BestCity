//
//  CZMemberOfCenterThreeView.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterThreeView.h"
#import "CZShareView.h"

@implementation CZMemberOfCenterThreeView

+ (instancetype)memberOfCenterThreeView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

/** 右边 */
- (IBAction)freeMoney{
    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/newZn.html"] rightBtnTitle:[UIImage imageNamed:@"Forward"] actionblock:^{
        [self share];
    }];
    vc.titleName = @"极品城省钱攻略";
    CURRENTVC(currentVc);
    [currentVc.navigationController pushViewController:vc animated:YES];
}

/** 新人免单 */
- (IBAction)aaa
{
    [CZFreePushTool push_newPeopleFree];
}

- (void)share
{
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
    shareDic[@"shareTitle"] = @"新人惊喜二重礼，限时活动速抢！";
    shareDic[@"shareContent"] = @"新人首单0元购，更有30元大额津贴下单立减当钱花~！";
    shareDic[@"shareUrl"] = @"https://www.jipincheng.cn/newZn.html";
    shareDic[@"shareImg"] = [UIImage imageNamed:@"MemberOfCenter-16"];
    [CZJIPINSynthesisTool JIPIN_UMShareUI2_Web:shareDic];
}

@end
