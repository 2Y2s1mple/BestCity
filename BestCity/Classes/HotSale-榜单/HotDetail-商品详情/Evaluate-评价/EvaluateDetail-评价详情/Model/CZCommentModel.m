//
//  CZCommentModel.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/14.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCommentModel.h"

@implementation CZCommentModel
- (NSString *)realContent
{
    NSString *textStr = [NSString stringWithFormat:@"%@ 回复:  %@", self.nickName, self.content];
    return textStr;
}

- (NSString *)nickName
{
    NSString *nickName = self.userShopmember[@"userNickName"] != nil &&  self.userShopmember[@"userNickName"] != [NSNull null] ? self.userShopmember[@"userNickName"] : @"***";
    return nickName;
}

- (NSMutableAttributedString *)attriString
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.realContent];
    [attr addAttributes:@{NSForegroundColorAttributeName : CZREDCOLOR} range:[self.realContent rangeOfString:self.nickName]];
    return attr;
}

- (CGFloat)cellHeight
{
    return [self.realContent getTextHeightWithRectSize:CGSizeMake(SCR_WIDTH - 106, 1000) andFont:[UIFont systemFontOfSize:15]] + 20;
}

- (CGFloat)labelHeight
{
    return self.cellHeight - 20;
}

@end
