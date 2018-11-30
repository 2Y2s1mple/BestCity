//
//  CZAttentionCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionCell.h"
#import "CZAttentionBtn.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"

@interface CZAttentionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
/** 关注头像 */
@property (nonatomic, weak) IBOutlet UIImageView *headerImage;
/** 关注名字*/
@property (weak, nonatomic) IBOutlet UILabel *attentionNameLabel;
@end

@interface CZAttentionCell ()

@property (nonatomic, strong) CZAttentionBtn *btn;
@end

@implementation CZAttentionCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"attentionCell";
    CZAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

// 取消关注
- (void)deleteAttention
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.userShopmember[@"userId"];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/concernDelete"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"取消关注成功"]) {
            // 刷新tableView
            !self.delegate ? : [self.delegate reloadAttentionTableView];
            self.model.attentionType = CZAttentionBtnTypeAttention;
            [[NSNotificationCenter defaultCenter] postNotificationName:attentionCellNotifKey object:nil userInfo:@{@"userId" : param[@"attentionUserId"], @"msg" : @"取消关注成功"}];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 新增关注
- (void)addAttention
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.model.userShopmember[@"userId"];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/concernInsert"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"用户关注成功"]) {
            // 刷新tableView
            !self.delegate ? : [self.delegate reloadAttentionTableView];
            self.model.attentionType = CZAttentionBtnTypeFollowed;
            [[NSNotificationCenter defaultCenter] postNotificationName:attentionCellNotifKey object:nil userInfo:@{@"userId" : param[@"attentionUserId"], @"msg" : @"用户关注成功"}];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //添加关注按钮
    self.btn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(SCR_WIDTH - 70, (60 - 24) / 2.0, 60, 24) CommentType:self.model.attentionType didClickedAction:^(BOOL isSelected){
        if (isSelected) {
            [self addAttention];
        } else {
            NSLog(@"点击了%@按钮", self.model.userShopmember[@"userNickName"]);
            [self deleteAttention];
        }
    }];
    [self.contentView addSubview:self.btn];
}

- (void)setModel:(CZAttentionsModel *)model
{
    _model = model;
    self.btn.type = model.attentionType;
    self.attentionNameLabel.text = model.userShopmember[@"userNickName"];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.userShopmember[@"userNickImg"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
