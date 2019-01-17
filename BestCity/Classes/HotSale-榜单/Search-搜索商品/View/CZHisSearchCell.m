//
//  CZHisSearchCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZHisSearchCell.h"
@interface CZHisSearchCell ()
/** 文字 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 图片 */
@property (nonatomic, weak) IBOutlet UIButton *deletBtn;
@end

@implementation CZHisSearchCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"searchCell";
    CZHisSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHistoryData:(NSString *)historyData
{
    _historyData = historyData;
    self.titleLabel.text = historyData;
}

@end
