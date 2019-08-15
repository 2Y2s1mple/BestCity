//
//  CZETestOpenBoxCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZETestOpenBoxCell.h"
#import "UIImageView+WebCache.h"
@interface CZETestOpenBoxCell ()
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *headerImage;
@property (nonatomic, weak) IBOutlet UILabel *headerName;
@property (nonatomic, weak) IBOutlet UILabel *visitName;
@end

@implementation CZETestOpenBoxCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZETestOpenBoxCell";
    CZETestOpenBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(CZETestModel *)model
{
    _model = model;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.nameLabel.text = model.title;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar"]]];
    self.headerName.text = model.user[@"nickname"];
    self.visitName.text = [NSString stringWithFormat:@"%@阅读", model.pv];;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
