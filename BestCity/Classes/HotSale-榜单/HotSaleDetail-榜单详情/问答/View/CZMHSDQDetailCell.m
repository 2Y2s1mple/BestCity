//
//  CZMHSDQDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDQDetailCell.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"

@interface CZMHSDQDetailCell ()
@property (nonatomic, weak) IBOutlet UIImageView *avatarImage;
@property (nonatomic, weak) IBOutlet UILabel *answerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timerLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UIButton *likeBtn;
@end

@implementation CZMHSDQDetailCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZMHSDQDetailCell";
    CZMHSDQDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)setModel:(CZMHSDQDetailModel *)model
{
    _model = model;
    self.answerNameLabel.text = model.userNickname;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.userAvatar]];
    self.timerLabel.text = model.createTime;
    self.answerLabel.text = model.content;

    self.likeBtn.selected = [model.vote boolValue];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@", model.voteCount] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@", model.voteCount] forState:UIControlStateSelected];

    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.answerLabel) + 20;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.answerNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.timerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    self.answerLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 16];
    self.answerLabel.preferredMaxLayoutWidth = SCR_WIDTH - 28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)likeBtnAction:(UIButton *)sender
{
    ISPUSHLOGIN;
    if (sender.isSelected) {
        sender.selected = NO;
        [self snapDelete:self.model.ID];
        [sender setTitle:[NSString stringWithFormat:@"%ld", ([sender.titleLabel.text integerValue] - 1) <= 0 ? 0 : ([sender.titleLabel.text integerValue] - 1)] forState:UIControlStateNormal];
        self.model.voteCount = @([sender.titleLabel.text integerValue]);
    } else {
        sender.selected = YES;
        [self snapInsert:self.model.ID];
        [sender setTitle:[NSString stringWithFormat:@"%ld", ([sender.titleLabel.text integerValue] + 1)] forState:UIControlStateSelected];
        self.model.voteCount = @([sender.titleLabel.text integerValue]);
    }
}


#pragma mark - 取消点赞接口
- (void)snapDelete:(NSString *)commentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = commentId;
    param[@"type"] = @"6";

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/vote/delete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"取消成功"];
            self.model.vote = @(0);
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];

    } failure:^(NSError *error) {}];
}

#pragma mark - 点赞接口
- (void)snapInsert:(NSString *)commentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = commentId;
    param[@"type"] = @(6);

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/vote/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            self.model.vote = @(1);
            [CZProgressHUD showProgressHUDWithText:@"点赞成功"];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"点赞失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {}];
}
@end
