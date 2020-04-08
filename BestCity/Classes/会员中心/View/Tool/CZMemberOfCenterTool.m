//
//  CZMemberOfCenterTool.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/3.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterTool.h"

@implementation CZMemberOfCenterTool
+ (NSArray *)toolUserStatus:(NSDictionary *)param
{
    // evel(会员等级 0普通 1vip 2合伙人)
    // levelStatus（会员升级状态：0审核中，1正常）
    if ([param[@"level"] integerValue] == 0) {
        UIImage *avatar = [UIImage imageNamed:@"MemberOfCenter-10"];
        UIImage *card = [UIImage imageNamed:@"MemberOfCenter-0"];
        NSString *applyTitle;
        if ([param[@"levelStatus"] integerValue] == 0) {
            applyTitle = @"正在审核中...";
        } else {
            applyTitle = @"申请升级VIP";
        }
        UIImage *vipImage = [UIImage imageNamed:@"MemberOfCenter-5"];
        UIImage *icon = [UIImage imageNamed:@"vip1"];

        NSArray *list = @[avatar, card, applyTitle, vipImage, icon];
        return list;
    } else if ([param[@"level"] integerValue] == 1) {
        UIImage *avatar = [UIImage imageNamed:@"MemberOfCenter-11"];
        UIImage *card = [UIImage imageNamed:@"MemberOfCenter-0-1"];
        NSString *applyTitle;
        if ([param[@"levelStatus"] integerValue] == 0) {
            applyTitle = @"正在审核中...";
        } else {
            applyTitle = @"申请升级合伙人";
        }
        UIImage *vipImage = [UIImage imageNamed:@"MemberOfCenter-15"];
        UIImage *icon = [UIImage imageNamed:@"vip2"];
        NSArray *list = @[avatar, card, applyTitle, vipImage, icon];
        return list;
    } else if ([param[@"level"] integerValue] == 2) {
        UIImage *avatar = [UIImage imageNamed:@"MemberOfCenter-12"];
        UIImage *card = [UIImage imageNamed:@"MemberOfCenter-0-2"];
        NSString *applyTitle;
        if ([param[@"levelStatus"] integerValue] == 0) {
            applyTitle = @"正在审核中...";
        } else {
            applyTitle = @"已为最高等级";
        }
        UIImage *vipImage = [UIImage imageNamed:@"MemberOfCenter-15"];
        UIImage *icon = [UIImage imageNamed:@"vip3"];
        NSArray *list = @[avatar, card, applyTitle, vipImage, icon];
        return list;
    } else {
        UIImage *avatar = [UIImage imageNamed:@"MemberOfCenter-10"];
        UIImage *card = [UIImage imageNamed:@"MemberOfCenter-0"];
        NSString *applyTitle;
        if ([param[@"levelStatus"] integerValue] == 0) {
            applyTitle = @"正在审核中...";
        } else {
            applyTitle = @"申请升级VIP";
        }
        UIImage *vipImage = [UIImage imageNamed:@"MemberOfCenter-5"];
        UIImage *icon = [UIImage imageNamed:@"vip1"];
        
        NSArray *list = @[avatar, card, applyTitle, vipImage, icon];
        return list;
    }
}
@end
