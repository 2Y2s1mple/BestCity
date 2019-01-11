//
//  CZCollectButton.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/21.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCollectButton.h"
#import "GXNetTool.h"

@implementation CZCollectButton

- (void)setCommodityID:(NSString *)commodityID
{
    _commodityID = commodityID;
    [self isCollectDetail];
}

#pragma mark - 类方法创建
+ (instancetype)collectButton
{
    CZCollectButton *btn = [CZCollectButton buttonWithType:UIButtonTypeCustom];
//    btn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
//    [btn setImage:IMAGE_NAMED(@"tab-favor-nor") forState:UIControlStateNormal];
//    [btn setImage:IMAGE_NAMED(@"tab-favor-sel") forState:UIControlStateSelected];
    [btn addTarget:btn action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)collectAction:(CZCollectButton *)sender
{
    if (sender.isSelected) { //选中, 已收藏
        [self collectDelete]; // 取消收藏
    } else { //未选中, 要收藏
        [self collectInsert]; // 收藏
    }
}

#pragma mark - 判断是否收藏了此文章
- (void)isCollectDetail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.commodityID;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/view/status"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"collect"] isEqualToNumber:@(1)]) {
            self.selected = YES;
        } else {
            self.selected = NO;
        } 
    } failure:^(NSError *error) {}];
}

#pragma mark - 取消收藏
- (void)collectDelete
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.commodityID;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"/api/collect/delete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            self.selected = NO;
            [CZProgressHUD showProgressHUDWithText:@"取消收藏"];
            [[NSNotificationCenter defaultCenter] postNotificationName:collectNotification object:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消收藏失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 收藏
- (void)collectInsert
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.commodityID;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/collect/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已收藏"]) {
            self.selected = YES;
            [CZProgressHUD showProgressHUDWithText:@"收藏成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:collectNotification object:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"收藏失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}


@end
