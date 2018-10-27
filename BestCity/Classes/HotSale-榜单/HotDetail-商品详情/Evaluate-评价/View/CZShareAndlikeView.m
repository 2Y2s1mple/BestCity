//
//  CZShareAndlikeView.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZShareAndlikeView.h"

@interface CZShareAndlikeView ()
/** 分享时间的block */
@property (nonatomic, copy) btnClickedBlock shareBlock;
/** 领券 */
@property (nonatomic, assign) btnClickedBlock buyBlock;
@end

@implementation CZShareAndlikeView

- (instancetype)initWithFrame:(CGRect)frame leftBtnAction:(btnClickedBlock)leftBlock rightBtnAction:(btnClickedBlock)rightBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        self.shareBlock = leftBlock;
        self.buyBlock = rightBlock;
    }
    return self;
}

- (void)setupSubViews
{
    //两个按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(0, 0, SCR_WIDTH / 2, self.height);
    [shareBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.backgroundColor = CZGlobalLightGray;
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(shareBtn.width, shareBtn.y, shareBtn.width, shareBtn.height);
    [buyBtn setTitle:@"领券并购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = CZRGBColor(227,20,54);
    [buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyBtn];
    
    self.height = CGRectGetMaxY(shareBtn.frame);
}

- (void)shareBtnAction
{
    self.shareBlock();
}

- (void)buyBtnAction
{
    self.buyBlock();
}
@end
