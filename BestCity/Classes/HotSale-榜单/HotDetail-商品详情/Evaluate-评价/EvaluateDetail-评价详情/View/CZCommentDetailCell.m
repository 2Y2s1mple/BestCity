//
//  CZCommentDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/22.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCommentDetailCell.h"
#import "UIImageView+WebCache.h"

@interface CZCommentDetailCell ()
/** 头像 */
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
/** 名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 点赞 */
@property (nonatomic, weak) IBOutlet UIButton *likeButton;
/** 评论内容 */
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
/** 时间 */
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
/** 回复按钮 */
@property (nonatomic, weak) IBOutlet UIButton *replyButton;
@end

@implementation CZCommentDetailCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZCommentDetailCell";
    CZCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.preferredMaxLayoutWidth = SCR_WIDTH - 68;
    
}

- (void)setContentDic:(NSDictionary *)contentDic
{
    _contentDic = contentDic;
    
   
    if (contentDic[@"userShopmember"] != [NSNull null]) {
        // 头像
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:contentDic[@"userShopmember"][@"userNickImg"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
         // 名字
        self.nameLabel.text = contentDic[@"userShopmember"][@"userNickName"];
    } else {
        self.iconImage.image = [UIImage imageNamed:@"headDefault"];
        self.nameLabel.text = @"游客";
    }
    
    // 点赞
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@", contentDic[@"snapNum"]] forState:UIControlStateNormal];
    self.likeButton.selected = [[NSString stringWithFormat:@"%@", contentDic[@"userSnap"]] integerValue];
    
    // 评论内容
    self.contentLabel.text = contentDic[@"content"];
    
    [self layoutIfNeeded];
    
    // 时间
    self.timeLabel.text = [contentDic[@"createTime"] substringToIndex:10];
    
    
    // cell高度
    self.cellHeight = CZGetY(self.timeLabel) + 10;
}

- (IBAction)replyButton:(id)sender
{
    NSLog(@"000000");
    NSString *userName;
    if (self.contentDic[@"userShopmember"] != [NSNull null]) {
        userName = self.contentDic[@"userShopmember"][@"userNickName"];
    } else {
        userName = @"游客";
    }
    self.block(self.contentDic[@"commentId"], userName);
}


@end
