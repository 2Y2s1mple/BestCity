//
//  CZFreeTakePartInCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeTakePartInCell.h"
#import "UIImageView+WebCache.h"

@interface CZFreeTakePartInCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *headerImage;
/** 注释 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *likeCount;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLabelWidth;

@end

@implementation CZFreeTakePartInCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{

    static NSString *ID = @"CZFreeTakePartInCell";
    CZFreeTakePartInCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]]];
    if ([dic[@"ismyself"]  isEqual: @(1)]) {
        self.headerImage.layer.borderWidth = 0.5;
        self.headerImage.layer.borderColor = CZREDCOLOR.CGColor;
        self.likeCount.textColor = CZREDCOLOR;
    } else {
        self.headerImage.layer.borderWidth = 0;
        self.headerImage.layer.borderColor = CZREDCOLOR.CGColor;
        self.likeCount.textColor = UIColorFromRGB(0x151515);
    }

    self.nameLabel.text = dic[@"nickname"];
    self.timerLabel.text = dic[@"createTime"];
    CGFloat rate = [dic[@"freeRate"] floatValue] * 100;
    self.likeCount.text = [NSString stringWithFormat:@"可免%.0lf%%", rate];

    self.numberLabelWidth.constant = 20;
    if ([self.numbersLabel.text integerValue] == 1) {
        self.numbersLabel.backgroundColor = UIColorFromRGB(0xE31436);
        self.numbersLabel.layer.cornerRadius = 10;
        self.numbersLabel.textAlignment = NSTextAlignmentCenter;
        self.numbersLabel.layer.masksToBounds = YES;
        self.numbersLabel.textColor = [UIColor whiteColor];
    } else if ([self.numbersLabel.text integerValue] == 2) {
        self.numbersLabel.backgroundColor = UIColorFromRGB(0xF76B1C);;
        self.numbersLabel.layer.cornerRadius = 10;
        self.numbersLabel.textAlignment = NSTextAlignmentCenter;
        self.numbersLabel.layer.masksToBounds = YES;
        self.numbersLabel.textColor = [UIColor whiteColor];
    } else if ([self.numbersLabel.text integerValue] == 3) {
        self.numbersLabel.backgroundColor = UIColorFromRGB(0x4A90E2);;
        self.numbersLabel.layer.cornerRadius = 10;
        self.numbersLabel.textAlignment = NSTextAlignmentCenter;
        self.numbersLabel.layer.masksToBounds = YES;
        self.numbersLabel.textColor = [UIColor whiteColor];
    } else {
        self.numbersLabel.textAlignment = NSTextAlignmentCenter;
        self.numbersLabel.backgroundColor = [UIColor whiteColor];
        self.numbersLabel.textColor = UIColorFromRGB(0xACACAC);
        self.numberLabelWidth.constant = 26;
    }

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
