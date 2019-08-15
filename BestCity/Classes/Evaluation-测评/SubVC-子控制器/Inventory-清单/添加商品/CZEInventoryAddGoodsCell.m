//
//  CZEInventoryAddGoodsCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEInventoryAddGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"

@interface CZEInventoryAddGoodsCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** tag1 */
@property (nonatomic, weak) IBOutlet UIButton *tag1;
/** tag2 */
@property (nonatomic, weak) IBOutlet UIButton *tag2;
/** tag3 */
@property (nonatomic, weak) IBOutlet UIButton *tag3;
/** tag4 */
@property (nonatomic, weak) IBOutlet UIButton *tag4;
/** 当前价格 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/** 一键添加 */
@property (nonatomic, weak) IBOutlet UIButton *btn;
@end

@implementation CZEInventoryAddGoodsCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZEInventoryAddGoodsCell";
    CZEInventoryAddGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setViewModel:(CZEInventoryAddGoodsCellViewMdoel *)viewModel
{
    _viewModel = viewModel;
    NSDictionary *dataDic = viewModel.dataDic;;

    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.titleLabel.text = dataDic[@"goodsName"];
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    self.tag4.hidden = YES;

    CGFloat maxWidth = SCR_WIDTH;

    NSArray *tagsArr = dataDic[@"goodsTagsList"];
    for (int i = 0; i < tagsArr.count; i++) {
        switch (i) {
            case 0:
                [self.tag1 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                self.tag1.hidden = NO;
                self.tag2.hidden = YES;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 1:
                [self.tag2 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                [self layoutIfNeeded];
                if (CGRectGetMaxX(self.tag2.frame) > SCR_WIDTH) {
                    break;
                }
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 2:
                [self.tag3 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                [self layoutIfNeeded];
                if (CGRectGetMaxX(self.tag3.frame) > SCR_WIDTH) {
                    break;
                }
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = YES;
                break;
            case 3:
                //                [self.tag4 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                //                self.tag1.hidden = NO;
                //                self.tag2.hidden = NO;
                //                self.tag3.hidden = NO;
                //                self.tag4.hidden = NO;
                break;
            default:
                break;
        }
    }
    NSString *actualPrice = [NSString stringWithFormat:@"¥%.2f", [dataDic[@"otherPrice"] floatValue]];
    self.actualPriceLabel.text = actualPrice;

    if (!viewModel.isSelected) {
        self.btn.backgroundColor = UIColorFromRGB(0x84B5D3);
        [self.btn setTitle:@"一键添加" forState:UIControlStateNormal];
    } else {
        self.btn.backgroundColor = UIColorFromRGB(0xE25838);
        [self.btn setTitle:@"取消添加" forState:UIControlStateNormal];
    }
}

/** 关注按钮响应方法 */
- (void)attentionAction:(UIButton *)sender
{
    sender.enabled = NO;
    if (self.viewModel.isSelected) {
        [self snapDelete:self.viewModel.dataDic[@"goodsId"]];
        self.btn.backgroundColor = UIColorFromRGB(0x84B5D3);
        [self.btn setTitle:@"一键添加" forState:UIControlStateNormal];
    } else {
        if (addGoodsNumber >= 5) {
            [CZProgressHUD showProgressHUDWithText:@"商品已经达到上线"];
            [CZProgressHUD hideAfterDelay:1.5];
            return;
        }
        [self snapInsert:self.viewModel.dataDic[@"goodsId"]];
        self.btn.backgroundColor = UIColorFromRGB(0xE25838);
        [self.btn setTitle:@"取消添加" forState:UIControlStateNormal];
        
    }
    self.viewModel.isSelected = !self.viewModel.isSelected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.actualPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.btn.layer.cornerRadius = 15;
    [self.btn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 取消
- (void)snapDelete:(NSString *)commentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.viewModel.articleId;;
    param[@"goodsId"] = commentId;

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/deleteGoods"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"取消成功"];
            addGoodsNumber--;
            !self.block ? : self.block();
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
        self.btn.enabled = YES;
    } failure:^(NSError *error) {
        self.btn.enabled = YES;
    }];
}

#pragma mark - 添加
- (void)snapInsert:(NSString *)commentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.viewModel.articleId;
    param[@"goodsId"] = commentId;

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/addGoods"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"添加成功"];
            addGoodsNumber++;
            !self.block ? : self.block();
        } else {
            [CZProgressHUD showProgressHUDWithText:@"点赞失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];
        self.btn.enabled = YES;
    } failure:^(NSError *error) {
        self.btn.enabled = YES;
    }];
}
@end
