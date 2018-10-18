//
//  CZSettingCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSettingCell.h"
#import "Masonry.h"

@interface CZSettingCell ()
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation CZSettingCell
+(instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"settingCell";
    CZSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.leftTitle.text = title;
    self.rightTitle.hidden = YES;
//    self.arrow.hidden = NO;
    if ([title isEqualToString:@"联系客服"] || [title isEqualToString:@"清除缓存"]) {
//        self.arrow.hidden = YES;
        self.rightTitle.hidden = NO;
        self.rightTitle.text = @"400-1801616";
        self.accessoryType = UITableViewCellAccessoryNone;
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
