//
//  CZTrialApplySuccessCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialApplySuccessCell.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "CZAddressController.h"
#import "CZMyTrialController.h"
#import "CZTrialApplySuccessController.h"

@interface CZTrialApplySuccessCell ()
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 第一行文字 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 第二行文字 */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
/** 第三行文字 */
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
/** 失败原因 */
@property (nonatomic, weak) IBOutlet UILabel *remarkLabel;
/** 下面按钮 */
@property (nonatomic, weak) IBOutlet UIButton *shareBtn;
/** 计算尺寸的横线 */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTop;
/** 最下面的横线 */
@property (nonatomic, weak) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineViewTop;

@end

@implementation CZTrialApplySuccessCell

- (IBAction)btnAction:(UIButton *)sender {
    if ([sender.titleLabel.text  isEqual: @"确认参与"]) {
        //确认参与
        [self defaultAddress];
    } else {
        !self.gotoEditorBlock ? :self.gotoEditorBlock(self.dicData.ID);
    }
}


// 获取默认地址接口
- (void)defaultAddress
{
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/address/default"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self invokingConfirm];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"请先选择默认地址后才能确认参与"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"填写地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    CZAddressController *vc = [[CZAddressController alloc] init];
                    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
                    UINavigationController *nav = tabbar.selectedViewController;
                    [nav pushViewController:vc animated:YES
                     ];
                }]];
                [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
            }
        }
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 调用参与接口
- (void)invokingConfirm
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"trialId"] = self.dicData.ID;
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/confirm"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            !self.block ? :self.block();
        } else {

        }
        [CZProgressHUD showProgressHUDWithText:@"已提交成功"];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZTrialApplySuccessCell";
    CZTrialApplySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setDicData:(CZTrialApplySuccessModel *)dicData
{
    self.remarkLabel.hidden = YES;
    self.shareBtn.hidden = NO;
    self.lineView.hidden = NO;
    self.lineViewTop.constant = -16;
    self.bottomLineViewTop.constant = 0;
    
    _dicData = dicData;//status: -1申请失败 0申请中 1申请成功 2确认参与，3超时申请失败
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:dicData.img]];
    self.titleLabel.text = dicData.name;
    self.subTitleLabel.text = [NSString stringWithFormat:@"请在%@前确认", [dicData.reportEndTime substringToIndex:10]];
    
    if ([dicData.status isEqualToNumber: @(1)]) { // 1申请成功
        self.statusLabel.text = @"申请成功";
        [self.shareBtn setTitle:@"确认参与" forState:UIControlStateNormal];
    } else if ([dicData.status isEqualToNumber: @(2)]) { // 2确认参与
        self.subTitleLabel.text = [NSString stringWithFormat:@"请在%@前提交试用报告", dicData.activitiesEndTime];
        switch ([dicData.reportStatus integerValue]) {
                //reportStatus 状态 0:草稿箱 1:审核中 2:已发布 -1：未通过 -2 未提交
            case 0: // 草稿箱
                self.statusLabel.text = @"未提交报告";
                [self.shareBtn setTitle:@"继续编辑报告" forState:UIControlStateNormal];
                break;
            case 1: // 审核中
                self.statusLabel.text = @"审核中";
                self.shareBtn.hidden = YES;
                self.remarkLabel.hidden = YES;
                self.lineView.hidden = YES;
                self.bottomLineViewTop.constant = -50;
                break;
            case 2: // 已发布
                self.statusLabel.text = @"报告审核通过";
                self.shareBtn.hidden = YES;
                self.remarkLabel.hidden = YES;
                self.lineView.hidden = YES;
                self.bottomLineViewTop.constant = -50;
                break;
            case -1: // 未通过
                self.statusLabel.text = @"报告审核未通过";
                [self.shareBtn setTitle:@"重新撰写报告" forState:UIControlStateNormal];
                self.remarkLabel.hidden = NO;
                self.lineViewTop.constant = 12;
                self.remarkLabel.text = [NSString stringWithFormat:@"失败原因：%@",  dicData.remark]; // 被拒信息
                break;
            case -2: // 未提交
                self.statusLabel.text = @"未提交报告";
                [self.shareBtn setTitle:@"撰写试用报告" forState:UIControlStateNormal];
                break;

            default:
                break;
        }
    }
    [self layoutIfNeeded];
    dicData.cellHeight = CZGetY(self.bottomLineView);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
