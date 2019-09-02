//
//  CZEAttentionArticleCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEAttentionArticleCell.h"
#import "UIImageView+WebCache.h"
//数据模型
#import "CZEAttentionItemViewModel.h"
#import "CZMeIntelligentController.h"

@interface CZEAttentionArticleCell ()
/** 主标题 */
@property (nonatomic, weak) IBOutlet UILabel *mainTitle;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 编辑的头像 */
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
/** 编辑的名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 个性签名 */
@property (nonatomic, weak) IBOutlet UILabel *signatureLabel;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UILabel *visitLabel;
/** 最下面的line */
@property (nonatomic, weak) IBOutlet UIView *lineView;
/** 关注按钮 */
@property (nonatomic, weak) IBOutlet UIButton *attentionBtn;
/** 数据模型 */
@property (nonatomic, strong) CZEAttentionItemViewModel *viewModel;
@end

@implementation CZEAttentionArticleCell

+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZEAttentionArticleCell";
    CZEAttentionArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZEAttentionArticleCell class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)bindViewModel:(NSObject *)viewModel
{
    self.viewModel = viewModel;
    /** 主标题 */
    self.mainTitle.text = self.viewModel.model.article[@"title"];
    /** 大图片 */
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.article[@"img"]]];
    /** 编辑的头像 */
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.article[@"user"][@"avatar"]]];
    /** 编辑的名字 */
    self.nameLabel.text = self.viewModel.model.article[@"user"][@"nickname"];
    /** 个性签名 */
    self.signatureLabel.text = self.viewModel.model.article[@"user"][@"detail"];
    /** 访问量 */
    self.visitLabel.text = [NSString stringWithFormat:@"%@阅读",  self.viewModel.model.article[@"pv"]];
    // 显示或隐藏关注按钮
    self.attentionBtn.hidden = self.viewModel.isShowAttention;
    // 设置关注按钮
    [self notAttentionBtnStyle:self.attentionBtn];

    [self layoutIfNeeded];
    /** 最下面的line */
    self.viewModel.cellHeight = CZGetY(self.lineView);
}


/** 关注按钮响应方法 */
- (void)attentionAction:(UIButton *)sender
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    if (!sender.isSelected) {
        [CZJIPINSynthesisTool addAttentionWithID:self.viewModel.model.article[@"user"][@"userId"] action:^{
           [self attentionBtnStyle:self.attentionBtn];
        }];
    } else {
        [CZJIPINSynthesisTool deleteAttentionWithID:self.viewModel.model.article[@"user"][@"userId"] action:^{
             [self notAttentionBtnStyle:self.attentionBtn];
        }];
    }
    sender.selected = !sender.isSelected;
}

- (IBAction)iconAction:(UITapGestureRecognizer *)sender {
    NSLog(@"跳转到个人主页");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.mainTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.attentionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    [self.attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageAction)];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:tap];
}


- (void)headerImageAction
{
    NSLog(@"-------------%@", self.viewModel.model.article[@"user"][@"userId"]);
    CZMeIntelligentController *vc = [[CZMeIntelligentController alloc] init];
    vc.freeID = self.viewModel.model.article[@"user"][@"userId"];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

// 未关注样式
- (void)notAttentionBtnStyle:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    sender.layer.borderColor = UIColorFromRGB(0xE25838).CGColor;
    [sender setTitle:@"关 注" forState:UIControlStateNormal];
    [sender setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateNormal];
}

// 已关注样式
- (void)attentionBtnStyle:(UIButton *)sender
{
    sender.layer.borderColor = CZGlobalGray.CGColor;
    [sender setTitle:@"已关注" forState:UIControlStateNormal];
    [sender setTitleColor:CZGlobalGray forState:UIControlStateNormal];
}

@end
