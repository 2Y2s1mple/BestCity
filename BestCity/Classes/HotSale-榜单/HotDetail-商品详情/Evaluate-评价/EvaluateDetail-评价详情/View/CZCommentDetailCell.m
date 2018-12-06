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
    
   
    if (contentDic[@"userShopmember"] != [NSNull null]) {
        // 头像
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:contentDic[@"userShopmember"][@"userNickImg"] != [NSNull null] ? contentDic[@"userShopmember"][@"userNickImg"] : @""] placeholderImage:[UIImage imageNamed:@"headDefault"]];
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
    NSString *createTime = contentDic[@"createTime"];
    NSString *showTime = contentDic[@"showTime"];
    NSString *time = (![showTime  isEqual: @""] && showTime != [NSNull null]) ? showTime : [createTime substringToIndex:10];
    self.timeLabel.text = time;
    
    
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
    self.block(self.contentDic[@"commentId"], userName, [self.contentDic[@"userCommentList"] count], [self.contentDic[@"index"] integerValue]);
}


- (IBAction)commentLikeAction:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        [self snapDelete:self.contentDic[@"commentId"]];
        [sender setTitle:[NSString stringWithFormat:@"%ld", ([sender.titleLabel.text integerValue] - 1)] forState:UIControlStateNormal];
        self.contentDic[@"snapNum"] = @([sender.titleLabel.text integerValue]);
    } else {
        sender.selected = YES;
        [self snapInsert:self.contentDic[@"commentId"]];
        [sender setTitle:[NSString stringWithFormat:@"%ld", ([sender.titleLabel.text integerValue] + 1)] forState:UIControlStateNormal];
        self.contentDic[@"snapNum"] = @([sender.titleLabel.text integerValue]);
    }
}

#pragma mark - 取消点赞接口
- (void)snapDelete:(NSString *)commentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"commentId"] = commentId;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/snapDelete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已删除"]) {
            [CZProgressHUD showProgressHUDWithText:@"取消成功"];
            self.contentDic[@"userSnap"] = @(0);
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
    param[@"commentId"] = commentId;
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/snapInsert"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"添加成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"点赞成功"];
            self.contentDic[@"userSnap"] = @(1);
        } else {
            [CZProgressHUD showProgressHUDWithText:@"点赞失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {}];
}
@end
