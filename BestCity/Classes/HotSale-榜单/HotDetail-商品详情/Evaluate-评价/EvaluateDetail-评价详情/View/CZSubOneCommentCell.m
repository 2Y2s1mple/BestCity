//
//  CZSubOneCommentCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/22.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZSubOneCommentCell.h"

@interface CZSubOneCommentCell ()
/** 谁回复的 */
@property (nonatomic, strong) UILabel *replyNameLabel;
/** 回复内容 */
@property (nonatomic, strong) UILabel *replyContentLabel;
/** 回复的label计算用 */
@property (nonatomic, strong) UILabel *label;
/** 父视图计算用 */
@property (nonatomic, strong) UIView *backView;
/** 带尖的图片 */
@property (nonatomic, strong) UIImageView *arrowImage;
@end
@implementation CZSubOneCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZSubOneCommentCell";
    CZSubOneCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CZSubOneCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupProperty];
    }
    return self;
}

- (void)setupProperty
{
    // 背景view
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [self.contentView addSubview:self.backView];
    
    // 带尖的图片
    UIImage *image = [UIImage imageNamed:@"LikeCmtBg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    self.arrowImage = [[UIImageView alloc] init];
    self.arrowImage.image = image;
    [self.backView addSubview:self.arrowImage];
    
    // 回复人
    self.replyNameLabel = [[UILabel alloc] init];
    self.replyNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    [self.backView addSubview:self.replyNameLabel];
    
    // 内容
    self.replyContentLabel = [[UILabel alloc] init];
    self.replyContentLabel.numberOfLines = 0;
    self.replyContentLabel.textColor = [UIColor blackColor];
    self.replyContentLabel.font = self.replyNameLabel.font;
    [self.backView addSubview:self.replyContentLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.x = 58;
    self.backView.y = 0;
    self.backView.width = SCR_WIDTH - 68;
    
    self.arrowImage.frame = CGRectMake(0, 0, self.backView.width, self.backView.height);
}

- (void)setContentDic:(NSDictionary *)contentDic
{
    _contentDic = contentDic;
    
    if (contentDic[@"isArrow"]) {
        self.arrowImage.hidden = NO;
    } else {
        self.arrowImage.hidden = YES;
    }
    
    NSString *userName;
    if (contentDic[@"userShopmember"] != [NSNull null] && contentDic[@"userShopmember"] != nil) {
        userName = contentDic[@"userShopmember"][@"userNickName"];
    } else {
        userName = @"游客";
    }
    NSString *textStr = [NSString stringWithFormat:@"%@ 回复:", userName];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attr addAttributes:@{NSForegroundColorAttributeName : CZGlobalGray} range:[textStr rangeOfString:userName]];
    self.replyNameLabel.attributedText = attr;
    self.replyNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.replyNameLabel.x = 10;
    self.replyNameLabel.y = 10;
    [self.replyNameLabel sizeToFit];
    if (self.replyNameLabel.width > 80) {
        self.replyNameLabel.width = 80;
    }
    
    // 更新一下
//    [self layoutIfNeeded];
    self.replyContentLabel.text = contentDic[@"content"]; //@"与水直接接触的内胆、不锈钢材质安全放心";
    self.replyContentLabel.x = CZGetX(self.replyNameLabel) + 10;
    self.replyContentLabel.y = self.replyNameLabel.y;
    self.replyContentLabel.width = (SCR_WIDTH - 68) - self.replyContentLabel.x - 10;
    self.replyContentLabel.height = [self.replyContentLabel.text getTextHeightWithRectSize:CGSizeMake(self.replyContentLabel.width, 1000) andFont:self.replyContentLabel.font];
    
    // 计算cell高度
    self.backView.height = CZGetY(self.replyContentLabel) + 10;
    self.cellHeight = self.backView.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
