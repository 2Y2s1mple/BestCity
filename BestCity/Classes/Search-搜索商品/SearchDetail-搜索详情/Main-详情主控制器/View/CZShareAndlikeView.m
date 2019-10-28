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
@property (nonatomic, copy) btnClickedBlock buyBlock;
@end

@implementation CZShareAndlikeView

- (instancetype)initWithFrame:(CGRect)frame leftBtnAction:(btnClickedBlock)leftBlock rightBtnAction:(btnClickedBlock)rightBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shareBlock = leftBlock;
        self.buyBlock = rightBlock;
    }
    return self;
}

- (void)setTitleData:(NSDictionary *)titleData
{
    _titleData = titleData;
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 两个按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(0, 0, 105, self.height);
    [shareBtn setTitle:@"  分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"Forward-2"] forState:UIControlStateNormal];
    shareBtn.backgroundColor = CZBTNGRAY;
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(shareBtn.width, shareBtn.y, SCR_WIDTH - shareBtn.width, shareBtn.height);


    NSString *buyBtnStr = _titleData[@"right"];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:buyBtnStr];
    [attrStr addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size: 18]} range:NSMakeRange(0, 4)];

    [buyBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = CZREDCOLOR;
    [buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyBtn];
    self.height = CGRectGetMaxY(shareBtn.frame);



//    if (!appVersion) {
//        width = SCR_WIDTH;
//        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        shareBtn.frame = CGRectMake(0, 0, width, self.height);
//        [shareBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
//        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        shareBtn.backgroundColor = CZBTNGRAY;
//        [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:shareBtn];
//        self.height = CGRectGetMaxY(shareBtn.frame);
//    } else {
//        width = SCR_WIDTH / 2;
//        // 两个按钮
//        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        shareBtn.frame = CGRectMake(0, 0, width, self.height);
//        [shareBtn setTitle:_titleData[@"left"] forState:UIControlStateNormal];
//        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        shareBtn.backgroundColor = CZBTNGRAY;
//        [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:shareBtn];
//
//        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        buyBtn.frame = CGRectMake(shareBtn.width, shareBtn.y, shareBtn.width, shareBtn.height);
//        [buyBtn setTitle:_titleData[@"right"] forState:UIControlStateNormal];
//        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        buyBtn.backgroundColor = CZREDCOLOR;
//        [buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:buyBtn];
//        self.height = CGRectGetMaxY(shareBtn.frame);
//    }
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
