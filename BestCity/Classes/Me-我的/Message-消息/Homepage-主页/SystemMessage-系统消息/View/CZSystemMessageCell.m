//
//  CZSystemMessageCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSystemMessageCell.h"

@interface CZSystemMessageCell ()
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 时间 */
@property (nonatomic, weak) IBOutlet UILabel *timerLabel;
/** 详情 */
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
/** 小点点 */
@property (nonatomic, weak) IBOutlet UIView *redView;

@end

@implementation CZSystemMessageCell
- (void)setModel:(CZSystemMessageModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.timerLabel.text = [model.createTime length] >= 10 ? [model.createTime substringToIndex:10] : @"";
    self.redView.hidden = [model.status integerValue];
    
}


+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"systemMessageCell";
    CZSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 20;
    frame.size.width -= 40;
    
    frame.origin.y += 20;
    frame.size.height -= 20;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.redView.layer.cornerRadius = 5;
    self.redView.layer.masksToBounds = YES;
}

@end
