//
//  CZHisSearchCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZHisSearchCell.h"
#import "GXNetTool.h"

@interface CZHisSearchCell ()
/** 文字 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 图片 */
@property (nonatomic, weak) IBOutlet UIButton *deletBtn;
@end

@implementation CZHisSearchCell

+ (instancetype)cellWithTableView:(UITableView *)tableView deleteBtnBlock:(deleteBtnBlock)block
{
    static NSString *ID = @"searchCell";
    CZHisSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.deleteBlock = block;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deletBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHistoryData:(NSDictionary *)historyData
{
    _historyData = historyData;
    self.titleLabel.text = historyData[@"word"];
}

- (IBAction)deleteBtnAction
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.historyData[@"id"];
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search/delete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {        
            !self.deleteBlock ? : self.deleteBlock();
            [CZProgressHUD hideAfterDelay:1];
        }        
    } failure:^(NSError *error) {}];

    
}


@end
