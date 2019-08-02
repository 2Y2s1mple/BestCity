//
//  CZScrollMenuModule.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZScrollMenuModule.h"

@interface CZScrollMenuModule ()
{
    UIButton *_recordBtn;
}
@end

@implementation CZScrollMenuModule

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self addSubview:self.createTitlesView(titles)];
}

// 创建标题菜单
- (UIView * (^)(NSArray *))createTitlesView
{
    return ^ (NSArray *titles) {
        UIScrollView *backView = [[UIScrollView alloc] init];
        backView.showsHorizontalScrollIndicator = NO;
        backView.backgroundColor = [UIColor whiteColor];
        backView.height = self.height;
        backView.width = self.width;

        CGFloat space = 20;
        CGFloat btnX = 15;
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i + 100;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
            [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
            [btn sizeToFit];
            btn.centerY = backView.height / 2.0;
            btn.x = btnX;
            [backView addSubview:btn];
            btnX += (space + btn.width);
            [btn addTarget:self action:@selector(contentViewDidClickedBtn:) forControlEvents:UIControlEventTouchUpInside];

            UIView *view = [[UIView alloc] init];
            view.tag = i + 200;
            view.x = btn.x;
            view.y = backView.height - 4;
            view.width = btn.width;
            view.height = 3;
            view.backgroundColor = self.selectColor;
            view.layer.cornerRadius = 2;
            [backView addSubview:view];
            view.hidden = YES;

            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(view), SCR_WIDTH, 1)];
            line.backgroundColor = CZGlobalLightGray;
            [backView addSubview:line];

            backView.contentSize = CGSizeMake(btnX, 0);

            if (i == 0) {
                view.hidden = NO;
                [btn setTitleColor:self.selectColor forState:UIControlStateNormal];
                self->_recordBtn = btn;
            }
        }
        return backView;
    };
}

- (void)contentViewDidClickedBtn:(UIButton *)sender
{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    if (_recordBtn != sender) {
        // 现在的btn
        [sender setTitleColor:self.selectColor forState:UIControlStateNormal];
        NSInteger lineViewTag = sender.tag + 100;
        UIView *lineView =  [sender.superview viewWithTag:lineViewTag];
        lineView.hidden = NO;

        NSLog(@"%s", __func__);
        // 前一个Btn
        [_recordBtn setTitleColor:self.normalColor forState:UIControlStateNormal];
        UIView *recordLineView =  [sender.superview viewWithTag:_recordBtn.tag + 100];
        recordLineView.hidden = YES;
        _recordBtn = sender;
        self.didSelectedTitle(sender.tag - 100);
    }
}

@end
