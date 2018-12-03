//
//  CZRecommendNav.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZRecommendNav.h"
#import "UIButton+CZExtension.h"
#import "Masonry.h"
#import "GXNetTool.h"

@interface CZRecommendNav ()
@property (nonatomic, strong) NSArray *mainTitles;
/** 上部的滑动条 */
@property (nonatomic, strong)UIView *scrollerLine;
/** 记录点击的标题 */
@property (nonatomic, strong) UIButton *recordBtn;
/** 右面点击事件 */
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation CZRecommendNav
/** 主标题数组 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"商品", @"评测", @"评价"];
    }
    return _mainTitles;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupNavigateView];
    }
    return self;
}

//自定义的导航栏
- (void)setupNavigateView
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    CGFloat btnX = 70;
    CGFloat btnW = (SCR_WIDTH - 127) / 3.0;
    CGFloat btnH = 20;
    for (int i = 0; i < self.mainTitles.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            self.recordBtn = titleBtn;
        }
        titleBtn.frame = CGRectMake(btnX + i * btnW, 0, btnW, btnH);
        [self addSubview:titleBtn];
        titleBtn.center = CGPointMake(titleBtn.center.x, self.height / 2);
        [titleBtn setTitle:self.mainTitles[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        if (i == 0) titleBtn.selected = YES;
        titleBtn.tag = i + 100;
        [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *scrollerLine = [[UIView alloc] init];
    scrollerLine.backgroundColor = [UIColor redColor];
    self.scrollerLine = scrollerLine;
    [self addSubview:scrollerLine];
    [scrollerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([self viewWithTag:100]);
        make.bottom.equalTo(self).offset(-2);
        make.height.equalTo(@2);
        make.width.equalTo(@20);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightBtn;
    [rightBtn setImage:[UIImage imageNamed:@"nav-favor"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"score-sel"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(clickedRight:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(0);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
}

// 商品的ID
- (void)setProjectId:(NSString *)projectId
{
    _projectId = projectId;
    [self isCollectDetail];
}


#pragma mark - 判断是否收藏了此文章
- (void)isCollectDetail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"projectId"] = self.projectId;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collect"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已收藏"]) {
            self.rightBtn.selected = YES;
        } else {
            self.rightBtn.selected = NO;
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 取消收藏
- (void)collectDelete
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"projectId"] = self.projectId;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collectDelete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已删除"]) {
            NSLog(@"%@", result);
            [CZProgressHUD showProgressHUDWithText:@"取消收藏"];
            self.rightBtn.selected = NO;
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消收藏失败"];
            self.rightBtn.selected = YES;
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
    param[@"projectId"] = self.projectId;
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collectInsert"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已添加"]) {
            NSLog(@"%@", result);
            [CZProgressHUD showProgressHUDWithText:@"收藏成功"];
            self.rightBtn.selected = YES;
        } else {
            [CZProgressHUD showProgressHUDWithText:@"收藏失败"];
            self.rightBtn.selected = NO;
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}
- (void)clickedRight:(UIButton *)sender
{
    if (sender.selected) {
        // 取消收藏
        [self collectDelete];
    } else {
        // 收藏
        [self collectInsert];
    }
}

- (void)popAction
{
    [self.delegate recommendNavWithPop:self];
}

- (void)titleBtnAction:(UIButton *)sender
{
    self.recordBtn.selected = NO;
    sender.selected = YES;
    
    CGFloat btnW = (SCR_WIDTH - 127) / 3.0;
    switch (sender.tag) {
        case 100: btnW = 0;
            break;
        case 102: btnW = 2 * btnW;
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollerLine.transform = CGAffineTransformMakeTranslation(btnW, 0);
    }];
    self.recordBtn = sender;
    !self.delegate ? : [self.delegate didClickedTitleWithIndex:sender.tag - 100];
}

- (void)setMonitorIndex:(NSInteger)monitorIndex
{
    _monitorIndex = monitorIndex;
    UIButton *btn = [self viewWithTag:100 + monitorIndex];
    CGFloat btnW = (SCR_WIDTH - 127) / 3.0;
    switch (monitorIndex) {
        case 0:
        {
            self.recordBtn.selected = NO;
            btn.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollerLine.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
        }
            break;
        case 1:
        {
            self.recordBtn.selected = NO;
            btn.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollerLine.transform = CGAffineTransformMakeTranslation(btnW, 0);
            }];
        }
            break;
        case 2:
        {
            self.recordBtn.selected = NO;
            btn.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollerLine.transform = CGAffineTransformMakeTranslation(btnW * 2, 0);
            }];
        }
            break;
        default:
            break;
    }
    self.recordBtn = btn;
}
@end
