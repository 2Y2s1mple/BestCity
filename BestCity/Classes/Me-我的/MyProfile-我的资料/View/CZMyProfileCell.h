//
//  CZMyProfileCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CZMyProfileCellType) {
    CZMyProfileCellTypeDefault,
    CZMyProfileCellTypeSubTitle,
};

@interface CZMyProfileCell : UITableViewCell
/** 左侧的标题 */
@property (nonatomic, strong) NSString *title;
/** 右侧的副标题 */
@property (nonatomic, strong) NSString *subTitle;
/** 头像URL */
@property (nonatomic, strong) UIImage *headerImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CZMyProfileCellType)type;
@end
