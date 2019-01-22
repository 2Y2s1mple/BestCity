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
    param[@"attentionUserId"] = self.model.userId;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/delete"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            // 刷新tableView
            [CZProgressHUD showProgressHUDWithText:@"取关成功"];
//            !self.delegate ? : [self.delegate reloadAttentionTableView];
            self.btn.type = CZAttentionBtnTypeAttention;
            
            
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {}];
}

// 新增关注
- (void)addAttention
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"attentionUserId"] = self.model.userId;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"关注成功"]) {
            // 刷新tableView
            [CZProgressHUD showProgressHUDWithText:@"关注成功"];
            if ([self.model.cellType  isEqual: @"fans"]) {
                self.btn.type = CZAttentionBtnTypeTogether;
            } else {
                self.btn.type = CZAttentionBtnTypeFollowed;
            }
//            !self.delegate ? : [self.delegate reloadAttentionTableView];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {}];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //添加关注按钮
    self.btn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(SCR_WIDTH - 70, (60 - 24) / 2.0, 60, 24) CommentType:0 didClickedAction:^(BOOL isSelected){
        if (isSelected) {
            [self addAttention];
        } else {
            [self deleteAttention];
        }
    }];
    [self.contentView addSubview:self.btn];
}

- (void)setModel:(CZAttentionsModel *)model
{
    _model = model;
    if ([self.model.cellType  isEqual: @"fans"]) {
        if ([self.model.status isEqualToNumber:@(1)]) {
            self.btn.type = CZAttentionBtnTypeTogether;
        } else {
            self.btn.type = CZAttentionBtnTypeAttention;
        }
    } else {
        self.btn.type = CZAttentionBtnTypeFollowed;
    }
    self.attentionNameLabel.text = model.nickname;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"headDefault"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
