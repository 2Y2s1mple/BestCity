//
//  CZEACCollectionCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEACCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface CZEACCollectionCell ()
/** 背景图 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 图标 */
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
/** 名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 个性签名 */
@property (nonatomic, weak) IBOutlet UILabel *signatureLabel;
/** 关注 */
@property (nonatomic, weak) IBOutlet UIButton *attentionBtn;
/** 封面 */
@property (nonatomic, weak) IBOutlet UIView *coverView;

@end

@implementation CZEACCollectionCell

- (void)setModel:(CZEAttentionUserModel *)model
{
    _model = model;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.bgImg]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLabel.text = model.nickname;
    self.signatureLabel.text = model.detail;

    [self layoutIfNeeded];
    self.coverView.layer.cornerRadius = 6;
    self.coverView.layer.masksToBounds = YES;
    for (UIView *subView in self.coverView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat imageWidth = self.coverView.width / 3.0;
    CGFloat imageHeight = self.coverView.height;
    NSArray *images = model.imgs;
    switch (images.count) {
        case 1:
        {
            UIImageView *coverImage = [[UIImageView alloc] init];
            coverImage.size = CGSizeMake(imageWidth, imageHeight);
            coverImage.centerX = self.coverView.width / 2.0;
            [coverImage sd_setImageWithURL:[NSURL URLWithString:images[0]]];
            coverImage.layer.cornerRadius = 6;
            coverImage.layer.masksToBounds = YES;
            [self.coverView addSubview:coverImage];
            break;
        }
        case 2:
        {
            UIView *view2 = [[UIView alloc] init];
            view2.size = CGSizeMake(imageWidth * 2 + 1, imageHeight);
            view2.x = imageWidth / 2.0 - 0.5;
            view2.layer.cornerRadius = 6;
            view2.layer.masksToBounds = YES;
            [self.coverView addSubview:view2];

            for (int i = 0; i < 2; i++) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.x = i * (imageWidth + 1);
                imgView.width = imageWidth - 0.5;
                imgView.height = imageHeight;
                [imgView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                [view2 addSubview:imgView];
            }
            break;
        }
        case 3:
        {
            for (int i = 0; i < 3; i++) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.x = i * (imageWidth + 1);
                imgView.width = imageWidth - 0.5;
                imgView.height = imageHeight;
                [imgView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                [self.coverView addSubview:imgView];
            }
            break;
        }
        default:
            break;
    }
}

- (IBAction)attentionAction:(UIButton *)sender
{
    if (!sender.isSelected) {
        [CZJIPINSynthesisTool addAttentionWithID:self.model.userId action:^{
            [self attentionBtnStyle:self.attentionBtn];
        }];
    } else {
        [CZJIPINSynthesisTool deleteAttentionWithID:self.model.userId action:^{
            [self notAttentionBtnStyle:self.attentionBtn];
        }];
    }
    sender.selected = !sender.isSelected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    self.attentionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
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
    sender.layer.borderColor = CZGlobalLightGray.CGColor;
    [sender setTitle:@"已关注" forState:UIControlStateNormal];
    [sender setTitleColor:CZGlobalGray forState:UIControlStateNormal];
}
@end
