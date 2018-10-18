//
//  CZDiscountCouponCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDiscountCouponCell.h"
#import "Masonry.h"
@interface CZDiscountCouponCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@end

@implementation CZDiscountCouponCell

+(instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"DiscountCouponCell";
    CZDiscountCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setType:(CZDiscountCouponCellType)type
{
    _type = type;
    switch (self.type) {
        case 0:
        {
            self.backImage.image = [UIImage imageNamed:@"unused"];
            //关注按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"立即使用" forState:UIControlStateNormal];
            btn.frame = CGRectMake(SCR_WIDTH - 20 - 60, 60, 60, 24);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 13;
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.backgroundColor = [UIColor redColor];
            [btn addTarget:self action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
            break;
            
        case 1:
        {
            self.backImage.image = [UIImage imageNamed:@"used"];
            UILabel *label = [[UILabel alloc] init];
            label.text = @"已使用";
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = CZGlobalGray;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.timeLabel);
                make.left.equalTo(self.timeLabel.mas_right).offset(10);
            }];
        }
            break;
        case 2:
        {
            self.backImage.image = [UIImage imageNamed:@"used"];
            UILabel *label = [[UILabel alloc] init];
            label.text = @"已过期";
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = CZGlobalGray;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.timeLabel);
                make.left.equalTo(self.timeLabel.mas_right).offset(10);
            }];
        }
            break;
        default:
            
            break;
    }
}


- (void)didClickedBtn:(UIButton *)sender
{
    NSLog(@"%s", __func__);
}

@end
