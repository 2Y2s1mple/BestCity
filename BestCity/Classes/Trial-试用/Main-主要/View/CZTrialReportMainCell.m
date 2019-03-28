//
//  CZTrialReportMainCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialReportMainCell.h"
#import "UIImageView+WebCache.h"

@interface CZTrialReportMainCell ()
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *headerImage;
@property (nonatomic, weak) IBOutlet UILabel *headerName;
@property (nonatomic, weak) IBOutlet UILabel *visitName;
@end


@implementation CZTrialReportMainCell

- (void)setTrailReportModel:(CZTrailReportModel *)trailReportModel
{
    _trailReportModel = trailReportModel;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:trailReportModel.img]];
    self.nameLabel.text = trailReportModel.title;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:trailReportModel.user[@"avatar"]]];
    self.headerName.text = trailReportModel.user[@"nickname"];
    self.visitName.text = [NSString stringWithFormat:@"%@阅读", trailReportModel.pv];;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZTrialReportMainCell";
    CZTrialReportMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
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
