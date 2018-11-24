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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setProjectId:(NSString *)projectId
{
    _projectId = projectId;
    // 判断收没收藏
    [self isCollectDetail];
}

- (void)setFindGoodsId:(NSString *)findGoodsId
{
    _findGoodsId = findGoodsId;
    // 判断收没收藏
    [self isCollectDetail];
}

- (void)setEvalId:(NSString *)evalId
{
    _evalId = evalId;
    // 判断收没收藏
    [self isCollectDetail];
}


#pragma mark - 类方法创建
+ (instancetype)collectButton
{
    CZCollectButton *btn = [[self alloc] init];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [btn setImage:IMAGE_NAMED(@"tab-favor-nor") forState:UIControlStateNormal];
    [btn setImage:IMAGE_NAMED(@"tab-favor-sel") forState:UIControlStateSelected];
    [btn addTarget:btn action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
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
    if (self.projectId) {
        param[@"projectId"] = self.projectId;
    } else if (self.findGoodsId) {
        param[@"findGoodsId"] = self.findGoodsId;
    } else if (self.evalId) {
        param[@"evalId"] = self.evalId;
    }
    
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collect"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已收藏"]) {
            NSLog(@"%@", result);
            self.selected = YES;
        } else {
            self.selected = NO;
        }
         [self setTitle:[NSString stringWithFormat:@"%@", result[@"count"]] forState:UIControlStateNormal];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 取消收藏
- (void)collectDelete
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.projectId) {
        param[@"projectId"] = self.projectId;
    } else if (self.findGoodsId) {
        param[@"findGoodsId"] = self.findGoodsId;
    } else if (self.evalId) {
        param[@"evalId"] = self.evalId;
    }
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collectDelete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已删除"]) {
            self.selected = NO;
            [self setTitle:[NSString stringWithFormat:@"%ld", [self.titleLabel.text integerValue] - 1] forState:UIControlStateNormal];
            [CZProgressHUD showProgressHUDWithText:@"取消收藏"];
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
    if (self.projectId) {
        param[@"projectId"] = self.projectId;
    } else if (self.findGoodsId) {
        param[@"findGoodsId"] = self.findGoodsId;
    } else if (self.evalId) {
        param[@"evalId"] = self.evalId;
    }
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collectInsert"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已添加"]) {
            self.selected = YES;
            [self setTitle:[NSString stringWithFormat:@"%ld", [self.titleLabel.text integerValue] + 1] forState:UIControlStateNormal];
            [CZProgressHUD showProgressHUDWithText:@"收藏成功"];
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
