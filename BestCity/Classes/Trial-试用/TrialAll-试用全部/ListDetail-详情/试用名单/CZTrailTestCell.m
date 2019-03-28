//
//  CZTrailTestCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrailTestCell.h"
#import "UIImageView+WebCache.h"

@interface CZTrailTestCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *headerImage;
/** 注释 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *likeCount;

@end

@implementation CZTrailTestCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"CZTrailTestCell";
    CZTrailTestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:dic[@"userAvatar"]]];
    self.nameLabel.text = dic[@"userNickname"];
    self.likeCount.text = [NSString stringWithFormat:@"拉赞数%@", dic[@"voteCount"]];
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
        self.numbersLabel.textAlignment = NSTextAlignmentLeft;
        self.numbersLabel.backgroundColor = [UIColor whiteColor];
        self.numbersLabel.textColor = UIColorFromRGB(0xACACAC);
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
