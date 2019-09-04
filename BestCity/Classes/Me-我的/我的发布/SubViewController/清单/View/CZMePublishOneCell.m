//
//  CZMePublishOneCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMePublishOneCell.h"
#import "UIImageView+WebCache.h"
#import "CZEInventoryEditorController.h"
#import "GXNetTool.h"

@interface CZMePublishOneCell ()
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *visitName;
/**  */
@property (nonatomic, weak) IBOutlet UILabel *remakeLabel;
@end

@implementation CZMePublishOneCell

+ (instancetype)cellwithTableView1:(UITableView *)tableView
{
    static NSString *ID = @"CZMePublishOneCell1";
    CZMePublishOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return cell;
}

+ (instancetype)cellwithTableView2:(UITableView *)tableView
{
    static NSString *ID = @"CZMePublishOneCell2";
    CZMePublishOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][1];
    }
    return cell;
}

+ (instancetype)cellwithTableView3:(UITableView *)tableView
{
    static NSString *ID = @"CZMePublishOneCell3";
    CZMePublishOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][2];
    }
    return cell;
}

+ (instancetype)cellwithTableView4:(UITableView *)tableView
{
    static NSString *ID = @"CZMePublishOneCell4";
    CZMePublishOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][3];
    }
    return cell;
}


- (void)setModel:(CZETestModel *)model
{
    _model = model;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.nameLabel.text = model.title;


    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *date = [formatter dateFromString:model.createTime];
    [formatter setDateFormat:@"YYYY-MM-dd"];

    self.dateLabel.text =  [formatter stringFromDate:date];
    self.visitName.text = [NSString stringWithFormat:@"%@阅读", model.pv];

    self.remakeLabel.text = [NSString stringWithFormat:@"原因：%@袭", model.remark];
}

- (IBAction)EditorAction:(UIButton *)sender {
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
    CZEInventoryEditorController *vc = [[CZEInventoryEditorController alloc] init];
    vc.trialId = self.model.articleId;
   [[self viewController].navigationController pushViewController:vc animated:YES];
}

/** <#注释#> */
- (IBAction)pulishAction
{
    NSLog(@"--------------");
}

// 发布
- (IBAction)publishAction
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"title"] =  self.model.title;
    param[@"content"] =  self.model.content;
    param[@"img"] =  self.model.img;
    param[@"articleId"] = self.model.articleId;

    if ([param[@"img"] length] < 1) {
        [CZProgressHUD showProgressHUDWithText:@"封面图片不得为空"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/publishListing"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"提交成功"];
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



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
