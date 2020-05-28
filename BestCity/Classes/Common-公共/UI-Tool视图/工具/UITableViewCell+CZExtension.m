//
//  UITableViewCell+CZExtension.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "UITableViewCell+CZExtension.h"

@implementation UITableViewCell (CZExtension)
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    NSString *ID = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;

}
@end
