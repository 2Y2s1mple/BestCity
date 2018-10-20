//
//  CZMyProfileCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMyProfileCell.h"
#import "UIImageView+WebCache.h"

@interface  CZMyProfileCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/** 头像 */
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;

@end

@implementation CZMyProfileCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CZMyProfileCellType)type
{
    switch (type) {
        case 0:
        {
            static NSString *ID = @"myProfileCell";
            CZMyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
            }
            return cell;
        }
            break;
        case 1:
        {
            static NSString *ID = @"myProfileCell2";
            CZMyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
            }
            return cell;
        }
            break;
            
        default:
            break;
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)setHeaderImage:(NSString *)headerImage
{
    _headerImage = headerImage;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"headDefault"]];
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
