//
//  CZGiveLikeView.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZGiveLikeView.h"
#import "GXNetTool.h"

@interface CZGiveLikeView ()
/** 点赞 */
@property (nonatomic, strong) UILabel *likeNumber;
@end

@implementation CZGiveLikeView

- (void)setIsClicked:(BOOL)isClicked
{
    _isClicked = isClicked;
    if (isClicked) {
        
    }
}

#pragma mark - 评测的ID
- (void)setEvalId:(NSString *)evalId
{
    _evalId = evalId;
    // 判断是否点赞
    [self isSnapSelect];
}

#pragma mark - 商品的ID
- (void)setCurrentID:(NSString *)currentID
{
    _currentID = currentID;
    // 判断是否点赞
    [self isSnapSelect];
}

#pragma mark - 发现的ID
- (void)setFindGoodsId:(NSString *)findGoodsId
{
    _findGoodsId = findGoodsId;
    [self isSnapSelect];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    //背后的圆圈
    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 76, 76)];
    imageBackView.center = CGPointMake(self.width / 2, self.height / 2);
    imageBackView.layer.borderWidth = 1;
    imageBackView.layer.borderColor = [CZREDCOLOR CGColor];
    imageBackView.layer.cornerRadius = imageBackView.height / 2;
    imageBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    [imageBackView addGestureRecognizer:tap];
    [self addSubview:imageBackView];
    
    //小手图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appreciate-big"]];
    imageView.frame = CGRectMake(10, 10, 35, 32);
    imageView.center = CGPointMake(imageBackView.width / 2, imageBackView.height / 2 - 10);
    [imageBackView addSubview:imageView];
    
    //点赞的数字
    UILabel *likeNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 38, 20)];
    likeNumber.center = CGPointMake(imageView.center.x, imageView.center.y + 30);
    likeNumber.text = @"123";
    likeNumber.textColor = CZGlobalGray;
    likeNumber.font = [UIFont systemFontOfSize:15];
    likeNumber.textAlignment = NSTextAlignmentCenter;
    [imageBackView addSubview:likeNumber];
    self.likeNumber = likeNumber;
}

#pragma mark - 点击方法
- (void)action
{
    //判断是否点击过
    if (!self.isClicked) {
        // 点赞
        [self snapInsert];
        //初始化小手
        __block UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:label];
        label.text = @"+1";
        label.textColor = CZRGBColor(227,20,54);
        label.font = [UIFont systemFontOfSize:15];
        label.center = CGPointMake(self.width / 2 + 40, self.height / 2 - 40);
        
        //给小手一个过渡
        [UIView animateWithDuration:1 animations:^{
            label.transform = CGAffineTransformMakeTranslation(0, -30);
        }];
        
        //延时删除
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [label removeFromSuperview];
            self.likeNumber.text = [NSString stringWithFormat:@"%ld", ([self.likeNumber.text integerValue] + 1)];
            self.likeNumber.textColor = CZREDCOLOR;
        });
        
    } else {
        // 取消点赞
        [self snapDelete];
        self.likeNumber.textColor = CZGlobalGray;
        self.likeNumber.text = [NSString stringWithFormat:@"%ld", ([self.likeNumber.text integerValue] - 1)];
    }
}

#pragma mark - 取消点赞接口
- (void)snapDelete
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.currentID) {
        param[@"goodsId"] = self.currentID;
    } else if (self.findGoodsId) {
        param[@"findGoodsId"] = self.findGoodsId;
    } else if (self.evalId) {
        param[@"evalId"] = self.evalId;
    }
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/snapDelete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已删除"]) {
            self.isClicked = NO;
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 点赞接口
- (void)snapInsert
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.currentID) {
        param[@"goodsId"] = self.currentID;
    } else if (self.findGoodsId) {
        param[@"findGoodsId"] = self.findGoodsId;
    } else if (self.evalId) {
        param[@"evalId"] = self.evalId;
    }
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/snapInsert"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"添加成功"]) {
            self.isClicked = YES;
        } else {
            [CZProgressHUD showProgressHUDWithText:@"点赞失败"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 判断文章是否点过赞
- (void)isSnapSelect
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.currentID) {
        param[@"goodsId"] = self.currentID;
    } else if (self.findGoodsId) {
        param[@"findGoodsId"] = self.findGoodsId;
    } else if (self.evalId) {
        param[@"evalId"] = self.evalId;
    }
    
    // 获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/snapSelect"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已点赞"]) {
            [self snap:result[@"count"]];
        } else {
            [self enSnap:result[@"count"]];
        }
        self.likeNumber.text = [NSString stringWithFormat:@"%@", result[@"count"]];

    } failure:^(NSError *error) {

    }];
}

#pragma mark - 已点赞样式
- (void)snap:(NSString *)count
{
    self.isClicked = YES;
    self.likeNumber.textColor = CZREDCOLOR;
    self.likeNumber.text = [NSString stringWithFormat:@"%@", count];
}

#pragma mark - 未点赞样式
- (void)enSnap:(NSString *)count
{
    self.isClicked = NO;
    self.likeNumber.textColor = CZGlobalGray;
    self.likeNumber.text = [NSString stringWithFormat:@"%@", count];
}
@end
