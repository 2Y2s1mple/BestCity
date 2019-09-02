//
//  CZMHSDQuestCell2.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDQuestCell2.h"
#import "GXNetTool.h"
#import "CZUpdataView.h"

@interface CZMHSDQuestCell2 ()
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
/** 审核中 */
@property (nonatomic, weak) IBOutlet UILabel *reviewLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@end

@implementation CZMHSDQuestCell2

+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZMHSDQuestCell2";
    CZMHSDQuestCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)setModel:(CZMHSDQuestModel *)model
{
    _model = model;

    self.answerLabel.text = model.title;
    self.reviewLabel.text = model.remark;

    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.lineView);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.answerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    /** 审核中 */
    self.reviewLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** <#注释#> */
- (IBAction)deleteAction
{
    CZUpdataView *backView = [CZUpdataView reminderView];
    backView.frame = [UIScreen mainScreen].bounds;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview: backView];
    backView.textString = @"话题一旦删除，将无法找回";
    [backView setConfirmBlock:^{
        [self deleteQuest];
    }];
}

// 删除接口
- (void)deleteQuest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"questionId"] =  self.model.ID;

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/my/question/delete"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"删除成功"];
            self.action(self);
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }

        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}
@end
