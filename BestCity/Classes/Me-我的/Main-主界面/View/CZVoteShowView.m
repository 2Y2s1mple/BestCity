//
//  CZVoteShowView.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZVoteShowView.h"

@interface CZVoteShowView ()

@end

@implementation CZVoteShowView

+ (instancetype)voteShowView
{
    CZVoteShowView *showView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    showView.layer.cornerRadius = 10;
    showView.layer.masksToBounds = YES;
    
    return showView;   
}

@end
