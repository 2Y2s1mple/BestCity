//
//  CZAllCriticalCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAllCriticalCell.h"
#import "UIImageView+WebCache.h"
#import "CZCommentDetailView.h"

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
/** 回复内容 */
@property (nonatomic, strong) CZCommentDetailView *commentDetailView;

@end

@implementation CZAllCriticalCell

- (CZCommentDetailView *)commentDetailView
{
    if (_commentDetailView == nil) {
        _commentDetailView = [[CZCommentDetailView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0)];
        [self.contentView addSubview:_commentDetailView];
    }
    return _commentDetailView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RANDOMCOLOR;
        [self setupProperty];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}



- (void)setupProperty
{
    //图片
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    self.icon.layer.cornerRadius = 19;
    self.icon.layer.masksToBounds = YES;
    [self.contentView addSubview:_icon];
    
    //名字
    self.name = [[UILabel alloc] init];
    _name.text = @"李丹妮";
    _name.font = [UIFont systemFontOfSize:16];
    _name.textColor = CZGlobalGray;
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

- (void)setModel:(CZEvaluateModel *)model
{
    _model = model;
    CGFloat space = 10.0;
    // 头像
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.fromImg] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.icon.x = space;
    self.icon.y = 2 * space;
    self.icon.width = 38;
    self.icon.width = 38;
    
    // 名子
    self.name.text = model.userShopmember[@"userNickName"];
    self.name.frame = CGRectMake(CZGetX(_icon) + space, _icon.center.y - 15, 100, 30);
    
    
    // 点赞数
    [self.likeBtn setTitle:model.snapNum forState:UIControlStateNormal];
    self.likeBtn.frame = CGRectMake(self.contentView.width - 10 - 80, _icon.center.y - 15, 80, 30);
    
    // 详情
    // 计算高度
    self.contentlabel.frame = CGRectMake(_name.x, CZGetY(_icon) + 10, self.contentView.width - CZGetX(self.icon) - 10, 0);
    self.contentlabel.height = [model.content boundingRectWithSize:CGSizeMake(self.contentView.width - CZGetX(self.icon) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    self.contentlabel.text = model.content;
    
    // 时间
    self.timeLabel.text = [model.createTime substringToIndex:10];
    self.timeLabel.frame = CGRectMake(_contentlabel.x, CZGetY(_contentlabel) + 10, 80, 20);
    
    // 回复按钮
    self.replyBtn.frame = CGRectMake(CZGetX(_timeLabel), _timeLabel.center.y - 10, 80, 20);
    
    // 创建回复界面
//    self.contentView.height = CZGetY(_replyBtn);
//    UIView *detail = [self commentDetailAddView:self.contentView originY: CZGetY(self.replyBtn) model:model];
    self.commentDetailView.x = 0;
    self.commentDetailView.y = CZGetY(_replyBtn);

    self.commentDetailView.height = 100;
    self.commentDetailView.model = model;
    
    
    _model.cellHeight = CZGetY(_commentDetailView);
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    
}

@end
