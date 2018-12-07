//
//  CZSettingCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSettingCell.h"
#import "Masonry.h"
#import "SDImageCache.h"

@interface CZSettingCell ()
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textSpace;

@end

@implementation CZSettingCell
+(instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"settingCell";
    CZSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.arrow.hidden = NO;
    self.leftTitle.text = title;
    self.rightTitle.hidden = YES;
    if ([title isEqualToString:@"联系客服"]) {
        self.rightTitle.hidden = NO;
        self.rightTitle.text = @"0571-88120907";
        self.arrow.hidden = YES;
        self.textSpace.constant = 14;
    } else if ([title isEqualToString:@"清除缓存"]) {
        //获取缓存的大小
        NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
        NSString *currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
        self.rightTitle.hidden = NO;
        self.rightTitle.text = currentVolum;
        
    }
}

// 计算缓存大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
