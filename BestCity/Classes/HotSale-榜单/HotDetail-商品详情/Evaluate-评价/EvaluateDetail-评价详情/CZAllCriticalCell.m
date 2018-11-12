//
//  CZAllCriticalCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAllCriticalCell.h"

@interface CZAllCriticalCell ()
/** icon */
@property (nonatomic, strong) UIImageView *icon;
/** 名字 */
@property (nonatomic, strong) UILabel *name;
/** 点赞小手 */
@property (nonatomic, strong) UIButton *likeBtn;
/** 内容 */
@property (nonatomic, strong) UILabel *contentlabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 回复 */
@property (nonatomic, strong) UIButton *replyBtn;

@end

@implementation CZAllCriticalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupProperty];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupProperty
{
    //图片
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    [self.contentView addSubview:_icon];
    
    
    //名字
    self.name = [[UILabel alloc] init];
    _name.text = @"李丹妮";
    _name.font = [UIFont systemFontOfSize:16];
    _name.textColor = CZRGBColor(21, 21, 21);
    [self.contentView addSubview:_name];
    
    
    //点赞小手
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn setTitle:@"245" forState:UIControlStateNormal];
    [_likeBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"appreciate-nor"]
             forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"appreciate-sel"]
             forState:UIControlStateHighlighted];
    [self.contentView addSubview:_likeBtn];
    
    
    // 内容
    self.contentlabel = [[UILabel alloc] init];
    _contentlabel.text = @"";
    _contentlabel.font = [UIFont systemFontOfSize:15];
    _contentlabel.textColor = CZRGBColor(21, 21, 21);
    _contentlabel.numberOfLines = 0;
    _contentlabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_contentlabel];
    
    
    //时间
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"2018.09.21";
    _timeLabel.textColor = CZGlobalGray;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLabel];
 
    
    //回复
    self.replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyBtn setTitle:@"·   回复"forState:UIControlStateNormal];
    _replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_replyBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [self.contentView addSubview:_replyBtn];
}

- (void)setModel:(CZAllCriticalModel *)model
{
    _model = model;
    self.icon.image = [UIImage imageNamed:model.icon];
    self.name.text = model.name;
    [self.likeBtn setTitle:model.likeNumber forState:UIControlStateNormal];
    
    NSString *text = model.contentText;
    
    _textHeight = [text boundingRectWithSize:CGSizeMake(SCR_WIDTH - 90, 1000) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    
    self.contentlabel.text = model.contentText;
    
    self.timeLabel.text = model.time;
    [self layoutIfNeeded];
    
    model.cellHeight = _height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat space = 10.0;
    self.icon.frame = CGRectMake(space, 2 * space, 50, 50);
    self.name.frame = CGRectMake(CZGetX(_icon) + space, _icon.center.y - 15, 100, 30);
    self.likeBtn.frame = CGRectMake(self.contentView.width - 10 - 80, _icon.center.y - 15, 80, 30);
    self.contentlabel.frame = CGRectMake(_name.x, CZGetY(_icon) + 10, self.contentView.width - _name.x - 10, _textHeight);
    self.timeLabel.frame = CGRectMake(_contentlabel.x, CZGetY(_contentlabel) + 10, 80, 20);
    self.replyBtn.frame = CGRectMake(CZGetX(_timeLabel), _timeLabel.center.y - 10, 80, 20);
    _height = CZGetY(_replyBtn);
}

@end
