//
//  CZEvaluationChoicenessCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationChoicenessCell.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
@interface CZEvaluationChoicenessCell ()
/** 关注*/
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/** 名称 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 粉丝数 */
@property (nonatomic, weak) IBOutlet UILabel *fansLabel;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 大图片文字 */
@property (nonatomic, weak) IBOutlet UILabel *bigImageLabel;
/** 时间 */
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UIButton *visitBtn;
/** 评论 */
@property (nonatomic, weak) IBOutlet UIButton *commentBtn;
@end

@implementation CZEvaluationChoicenessCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
            !self.delegate ? : [self.delegate reloadCEvaluationChoicenessData];
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
            !self.delegate ? : [self.delegate reloadCEvaluationChoicenessData];
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

- (IBAction)attentionAction:(UIButton *)sender {
    if (self.attentionBtn.isSelected) {
        self.attentionBtn.selected = NO;
        // 取消关注
        [self deleteAttention];
    } else {
        self.attentionBtn.selected = YES;
        // 新增关注
        [self addAttention];
    }
    [self setupAttentBtn];
}

- (void)setModel:(CZEvaluationChoicenessModel *)model
{
    _model = model;
    // 名字
    self.nameLabel.text = model.userShopmember[@"userNickName"];
    // icon
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.userShopmember[@"userNickImg"]] placeholderImage:[UIImage imageNamed:@"head1"]];
    // 粉丝
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝数:%@", model.userShopmember[@"fansCount"]];
    // 关注
    self.attentionBtn.selected = [model.concernNum integerValue];
    [self setupAttentBtn];
    // 大图片
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.imgId] placeholderImage:[UIImage imageNamed:@"testImage6"]];
    // 大图片文字
    self.bigImageLabel.text = model.evalWayName;
    // 时间
    self.timeLabel.text = model.showTime;
    // 访问量
    [self.visitBtn setTitle:model.visitCount forState:UIControlStateNormal];
    // 评论
    [self.commentBtn setTitle:model.commentNum forState:UIControlStateNormal];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"evaluationChoicenessCell";
    CZEvaluationChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setupAttentBtn
{
    if (!_attentionBtn.isSelected) {
    // 关注
        [_attentionBtn setBackgroundColor:CZGlobalWhiteBg];
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _attentionBtn.layer.borderWidth = 0.5;
        _attentionBtn.layer.cornerRadius = 13;
        _attentionBtn.layer.borderColor = [UIColor redColor].CGColor;
        [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [_attentionBtn setBackgroundColor:CZGlobalGray];
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _attentionBtn.layer.borderWidth = 0.5;
        _attentionBtn.layer.cornerRadius = 13;
        _attentionBtn.layer.borderColor = CZGlobalGray.CGColor;
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionBtn setTitleColor:CZGlobalWhiteBg forState:UIControlStateSelected];
    }
}

@end
