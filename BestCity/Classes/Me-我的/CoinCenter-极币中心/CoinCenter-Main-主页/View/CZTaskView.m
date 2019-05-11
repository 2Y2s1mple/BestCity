//
//  CZTaskView.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTaskView.h"
#import "CZInvitationController.h"

@interface CZTaskView ()
/** 详情 */
@property (nonatomic, strong) UILabel *contentLabel;
/** 下边线 */
@property (nonatomic, strong) UIView *lineView;
/** 按钮 */
@property (nonatomic, strong) UIButton *arrowBtn;
@end

@implementation CZTaskView

- (void)setTaskData:(NSDictionary *)taskData
{
    _taskData = taskData;
    [self setupSubViews];
}

- (void)setupSubViews
{
    // 文字
    UILabel *itemTitle = [[UILabel alloc] init];
    itemTitle.text = [NSString stringWithFormat:@"%@ +%@", self.taskData[@"title"], self.taskData[@"point"]];
    itemTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    itemTitle.textColor = [UIColor blackColor];
    [itemTitle sizeToFit];
    itemTitle.x = 12;
    itemTitle.centerY = self.height / 2;
    [self addSubview:itemTitle];
    
    // 按钮 1邀请好友，2个人认证，3企业认证，4点赞，5分享内容，6阅读文章，7评论文章，8发文奖励）
    NSString *btnTitle;
    switch ([self.taskData[@"type"] integerValue]) {
        case 1:
            btnTitle = @"立即邀请";
            break;
        case 2:
            btnTitle = @"立即认证";
            break;
        case 3:
            btnTitle = @"立即认证";
            break;
        case 4:
            btnTitle = @"立即点赞";
            break;
        case 5:
            btnTitle = @"立即分享";
            break;
        case 6:
            btnTitle = @"立即阅读";
            break;
        case 7:
            btnTitle = @"立即评论";
            break;
        case 8:
            btnTitle = @"发文奖励";
            break;
        default:
            break;
    }
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn setTitle:btnTitle forState:UIControlStateNormal];
    [itemBtn setTitleColor:UIColorFromRGB(0xFFFF533A) forState:UIControlStateNormal];
    itemBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    itemBtn.width = 79;
    itemBtn.height = 26;
    itemBtn.layer.borderWidth = 1;
    itemBtn.layer.borderColor = UIColorFromRGB(0xFFFF533A).CGColor;
    itemBtn.layer.cornerRadius = 5;
    itemBtn.layer.masksToBounds = YES;
    itemBtn.centerY = itemTitle.centerY;
    itemBtn.x = self.width - 49 - itemBtn.width;
    [itemBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:itemBtn];
    
    // 上下尖号按钮
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [arrowBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    arrowBtn.width = 49;
    arrowBtn.height = self.height;
    arrowBtn.x = CZGetX(itemBtn);
    arrowBtn.centerY = itemBtn.centerY;
    [arrowBtn addTarget:self action:@selector(arrowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:arrowBtn];
    self.arrowBtn = arrowBtn;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = self.taskData[@"content"];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    contentLabel.textColor = CZGlobalGray;
    contentLabel.numberOfLines = 0;
    CGRect rect = [contentLabel.text boundingRectWithSize:CGSizeMake(self.width - 24, 200.0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:contentLabel.font} context:nil];
    contentLabel.x = itemTitle.x;
    contentLabel.y = CZGetY(itemTitle) + 20;
    contentLabel.width = self.width - 24;
    contentLabel.height = rect.size.height;
    [self addSubview:contentLabel];
    contentLabel.hidden = YES;
    self.contentLabel = contentLabel;

    
    // 下边线
    UIView *lineView = [[UIView alloc] init];
    lineView.height = 1;
    lineView.width = self.width - 24;
    lineView.x = 12;
    lineView.y = self.height - 1;
    lineView.backgroundColor = CZGlobalLightGray;
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)arrowAction:(UIButton *)sender
{
    NSLog(@"--------");
    if (sender.selected) {
        self.height = 62;
        self.lineView.y = self.height - 1;
        self.contentLabel.hidden = YES;
    } else {
        self.height = CZGetY(self.contentLabel) + 20;
        self.contentLabel.hidden = NO;
        self.lineView.y = self.height - 1;
    }
    sender.selected = !sender.selected;
    !self.delegate ? : [self.delegate updataTaskView:self];    
}


- (void)itemBtnAction:(UIButton *)sender
{
    NSString *text;
    NSDictionary *context;
    switch ([self.taskData[@"type"] integerValue]) {
        case 1: {
            text = @"我要赚极币--立即邀请";
            context = @{@"sign" : text};
            break;
        }
        case 4: {
            text = @"我要赚极币--立即点赞";
            context = @{@"sign" : text};
            break;
        }
        case 5: {
            text = @"我要赚极币--立即分享";
            context = @{@"sign" : text};
            break;
        }
        case 6: {
            text = @"我要赚极币--立即阅读";
            context = @{@"sign" : text};
            break;
        }
        case 7: {
            text = @"我要赚极币--立即评论";
            context = @{@"sign" : text};
        }
        default:
            break;
    }
    [MobClick event:@"ID5" attributes:context];

//    1首页，2发现，3评测，4邀请页面，5.认证页面
    NSLog(@"%@", text);
    switch ([self.taskData[@"location"] integerValue]) {
        case 1:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 0;
            break;
        }
        case 2:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 1;
            break;
        }
        case 3:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            break;
        }
        case 4:
        {
            CZInvitationController *vc = [[CZInvitationController alloc] init];
             [[self viewController].navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
            
            break;
            
        default:
            break;
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
