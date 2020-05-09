//
//  CZTableViewCell1.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTableViewCell1.h"
#import "UIImageView+WebCache.h"

#import "GXNetTool.h"
#import "TSLWebViewController.h"
#import "CZUserInfoTool.h"


@interface CZTableViewCell1 ()
@property (nonatomic, weak) IBOutlet UIImageView *shopImg;
@property (nonatomic, weak) IBOutlet UILabel *shopName;
@property (nonatomic, weak) IBOutlet UIImageView *itemImgView;
@property (nonatomic, weak) IBOutlet UILabel *itemTitle;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *userCountLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *btn;

@end

@implementation CZTableViewCell1
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZTableViewCell1";
    CZTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(NSDictionary *)model {
    _model = [model changeAllNnmberValue];

    [self.shopImg sd_setImageWithURL:[NSURL URLWithString:_model[@"shopImg"]]];
    self.shopName.text = [NSString stringWithFormat:@"%@赞助", _model[@"shopName"]];
    [self.itemImgView sd_setImageWithURL:[NSURL URLWithString:_model[@"img"]]];
    self.itemTitle.text = _model[@"name"];
    self.userCountLabel.text = [NSString stringWithFormat:@"剩余%ld件", [_model[@"count"] integerValue] - [_model[@"userCount"] integerValue]];
    [self.btn setTitle:[NSString stringWithFormat:@"立即购买（额外返现%@元）", _model[@"freePrice"]] forState:UIControlStateNormal];
}

// 购买
- (IBAction)buyBtnAction
{
    ISPUSHLOGIN;
    // 为了同步关联的淘宝账号
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
        if (isAuthTaobao) {
            // 打开淘宝
            [self openAlibcTradeWithId:self.model[@"goodsId"]];
        }
    }];
}

- (void)openAlibcTradeWithId:(NSString *)ID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = ID;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsBuyLink"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZJIPINSynthesisTool jipin_jumpTaobaoWithUrlString:result[@"data"]];
        } else {
        }
    } failure:^(NSError *error) {

    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userCountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
