//
//  CZCommentDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/22.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCommentDetailCell.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"

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

- (void)setContentDic:(NSMutableDictionary *)contentDic
{
    _contentDic = contentDic;
    
   
    if (contentDic[@"userNickname"] != [NSNull null]) {
        // 头像
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:contentDic[@"userAvatar"] != [NSNull null] ? contentDic[@"userAvatar"] : @""] placeholderImage:[UIImage imageNamed:@"headDefault"]];
         // 名字
        self.nameLabel.text = contentDic[@"userNickname"];
    } else {
        self.iconImage.image = [UIImage imageNamed:@"headDefault"];
        self.nameLabel.text = @"游客";
    }
    
    // 点赞
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@", contentDic[@"voteCount"]] forState:UIControlStateNormal];
    self.likeButton.selected = [[NSString stringWithFormat:@"%@", contentDic[@"vote"]] integerValue];
    
    // 评论内容
    self.contentLabel.text = contentDic[@"content"];
    
    [self layoutIfNeeded];
    
    // 时间
//    NSString *createTime = contentDic[@"createTime"];
//    NSString *showTime = contentDic[@"showTime"];
//    NSString *time = (![showTime  isEqual: @""] && showTime != [NSNull null]) ? showTime : [createTime substringToIndex:10];
    self.timeLabel.text = contentDic[@"createTimeStr"];
    
    
    // cell高度
    self.cellHeight = CZGetY(self.timeLabel) + 10;
}

- (IBAction)replyButton:(id)sender
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }
    NSString *userName;
    if (self.contentDic[@"userNickname"] != [NSNull null]) {
        userName = self.contentDic[@"userNickname"];
    } else {
        userName = @"游客";
    }
    self.block(self.contentDic[@"commentId"], userName, [self.contentDic[@"children"] count], [self.contentDic[@"index"] integerValue]);
}


- (IBAction)commentLikeAction:(UIButton *)sender {
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }
    if (sender.isSelected) {
        sender.selected = NO;
        [self snapDelete:self.contentDic[@"commentId"]];
        [sender setTitle:[NSString stringWithFormat:@"%ld", ([sender.titleLabel.text integerValue] - 1)] forState:UIControlStateNormal];
        self.contentDic[@"voteCount"] = @([sender.titleLabel.text integerValue]);
    } else {
        sender.selected = YES;
        [self snapInsert:self.contentDic[@"commentId"]];
        [sender setTitle:[NSString stringWithFormat:@"%ld", ([sender.titleLabel.text integerValue] + 1)] forState:UIControlStateNormal];
        self.contentDic[@"voteCount"] = @([sender.titleLabel.text integerValue]);
    }
}

#pragma mark - 取消点赞接口
- (void)snapDelete:(NSString *)commentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = commentId;
    param[@"type"] = @(5);
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/vote/delete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"取消成功"];
            self.contentDic[@"vote"] = @(0);
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
        
    } failure:^(NSError *error) {}];
}

#pragma mark - 点赞接口
- (void)snapInsert:(NSString *)commentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = commentId;
    param[@"type"] = @(5);
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/vote/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"点赞成功"];
            self.contentDic[@"vote"] = @(1);
        } else {
            [CZProgressHUD showProgressHUDWithText:@"点赞失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {}];
}
@end
