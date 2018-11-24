//
//  CZPackUpCommentCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/22.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZPackUpCommentCell.h"
@interface CZPackUpCommentCell ()
/** 查看10条n按钮 */
@property (nonatomic, weak) IBOutlet UIButton *packUpNnfoldButton;
/** 共有几条回复 */
@property (nonatomic, weak) IBOutlet UIButton *totalCommentButton;
@end

@implementation CZPackUpCommentCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZPackUpCommentCell";
    CZPackUpCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (void)setContentDic:(NSMutableDictionary *)contentDic
{
    _contentDic = contentDic;
    self.cellHeight = 40;
    [self.totalCommentButton setTitle:[NSString stringWithFormat:@"共%ld条回复", [contentDic[@"commentArr"] count]] forState:UIControlStateNormal];
    
    if ([contentDic[@"packUpStatus"]  isEqual: @"1"]) {
         // 显示更多按钮
        [self showPackUP];
        // 判断展开和收起状态
        [self moreBtnsStatus];
    } else if ([contentDic[@"packUpStatus"]  isEqual: @"0"]){
        // 隐藏更多按钮
        [self showTotal];
    } else {
        self.packUpNnfoldButton.selected = YES; // 收起
        // 显示更多按钮
        [self showPackUP];
    }
}

#pragma mark - 显示收起按钮
- (void)showPackUP
{
    self.totalCommentButton.hidden = YES;
    self.packUpNnfoldButton.hidden = NO;
}

#pragma mark - 显示一共按钮
- (void)showTotal
{
    self.totalCommentButton.hidden = NO;
    self.packUpNnfoldButton.hidden = YES;
}

#pragma mark - 计算展示和收起的状态
- (void)moreBtnsStatus
{
    // 评论数组
    NSMutableArray *commentArr = self.contentDic[@"commentArr"];
    // 外边显示了多少条
    NSInteger showCount = [self.contentDic[@"showCount"] integerValue];
    
    if (commentArr.count > showCount) { // 总数大于外面显示的
        self.packUpNnfoldButton.selected = NO; // 显示展示10条
        self.contentDic[@"packUpStatus"] =  @"1"; //显示更多按钮
        // 还能显示多少条
        NSInteger canShowConut = commentArr.count - showCount;
        // 每次显示加载条数
        NSInteger maxAddNum = 10;
        if (canShowConut > maxAddNum) { // 大于10, 还显示10条
            self.contentDic[@"canShowConut"] = @(maxAddNum);
        } else { // 小于10, 显示剩余条
            self.contentDic[@"canShowConut"] = @(canShowConut);
        }
        
    } else { // 如果总数小于等于外面显示的显示了多少条
        self.packUpNnfoldButton.selected = YES; // 收起
        self.contentDic[@"packUpStatus"] =  @"2"; //显示收起按钮
    }
    
}

- (void)outSideStatus
{
   
    
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
