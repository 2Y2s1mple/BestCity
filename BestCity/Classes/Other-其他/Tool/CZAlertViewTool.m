//
//  CZAlertViewTool.m
//  BestCity
//
//  Created by JasonBourne on 2018/10/20.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAlertViewTool.h"


@interface CZAlertViewTool ()
/**  */
@property (nonatomic, copy)CZActionBlock block;
@end

@implementation CZAlertViewTool
+ (void)showSheetAlertAction:(CZActionBlock)block
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        block();
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:YES completion:nil];
    
}
@end
