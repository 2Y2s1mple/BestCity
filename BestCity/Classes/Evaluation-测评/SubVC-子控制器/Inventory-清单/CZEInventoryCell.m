//
//  CZEInventoryCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEInventoryCell.h"
#import "UIImageView+WebCache.h"
#import "CZMeIntelligentController.h"


@interface CZEInventoryCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 主标题 */
@property (nonatomic, weak) IBOutlet UILabel *mainTitle;
/** 编辑的头像 */
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
/** 编辑的名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UIButton *visitLabel;
@end
@implementation CZEInventoryCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZEInventoryCell";
    CZEInventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(CZETestModel *)model
{
    _model = model;
    // 主标题
    self.mainTitle.text = model.title;

    // 大图片
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"testImage6"]];

    // 编辑头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"head1"]];

    // 编辑名字
    self.nameLabel.text = model.user[@"nickname"];

    // 访问量
    [self.visitLabel setTitle:[NSString stringWithFormat:@"%@阅读", model.pv] forState:UIControlStateNormal];

    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.visitLabel) + 20;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2.0;
    self.avatarImageView.layer.masksToBounds = YES;
    self.mainTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageAction)];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:tap];
}

- (void)headerImageAction
{
    NSLog(@"-------------%@", self.model.user[@"userId"]);
    CZMeIntelligentController *vc = [[CZMeIntelligentController alloc] init];
    vc.freeID = self.model.user[@"userId"];
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

    // Configure the view for the selected state
}

@end
