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

/** 上部的滑动条 */
@property (nonatomic, strong)UIView *scrollerLine;
/** 记录点击的标题 */
@property (nonatomic, strong) UIButton *recordBtn;
/** 右面点击事件 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
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

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (instancetype)initWithFrame:(CGRect)frame type:(CZJIPINModuleType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? -44 : -20), SCR_WIDTH, (IsiPhoneX ? 44 : 20))];
        [self addSubview:topView];
        topView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        [self setupNavigateView:type];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, SCR_WIDTH, 1)];
        line.backgroundColor = CZGlobalLightGray;
        [self addSubview:line];
    }
    return self;
}

//自定义的导航栏
- (void)setupNavigateView:(CZJIPINModuleType)type
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
    
    if (type == CZJIPINModuleHotSale) {
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
            titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
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
    } else if (type == CZJIPINModuleDiscover){
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
//        titleLabel.text = @"发现详情";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    } else if (type == CZJIPINModuleEvaluation) {
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
//        titleLabel.text = @"评测详情";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    } else if (type == CZJIPINModuleRelationBK) {
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        titleLabel.text = self.titleText;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    } else if (type == CZJIPINModuleQingDan) {
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
//        titleLabel.text = @"清单详情";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    } else {
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
//        titleLabel.text = @"报告详情";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightBtn;
    if (type == CZJIPINModuleRelationBK) {
        [rightBtn setImage:[UIImage imageNamed:@"Trail-share-black"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"Trail-share-black"] forState:UIControlStateSelected];
        [rightBtn addTarget:self action:@selector(shareBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [rightBtn setImage:[UIImage imageNamed:@"nav-favor"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"nav-favor-sel"] forState:UIControlStateSelected];
        [rightBtn addTarget:self action:@selector(clickedRight:) forControlEvents:UIControlEventTouchUpInside];
    }
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

- (void)shareBtnDidClicked:(UIButton *)sender
{
    [self.delegate didClickedTitleWithIndex:0];
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
    param[@"targetId"] = self.projectId;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/view/status"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"collect"] isEqualToNumber:@(1)]) {
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
    param[@"targetId"] = self.projectId;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"/api/collect/delete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            [CZProgressHUD showProgressHUDWithText:@"取消收藏"];
            self.rightBtn.selected = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:collectNotification object:nil];
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



    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:^{
            UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
            UINavigationController *nav = tabbar.selectedViewController;
            UIViewController *currentVc = nav.topViewController;
            [currentVc.navigationController popViewControllerAnimated:nil];
        }];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.projectId;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/collect/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已收藏"]) {
            [CZProgressHUD showProgressHUDWithText:@"收藏成功"];
            self.rightBtn.selected = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:collectNotification object:nil];
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

- (void)hiddenTitle
{
    self.titleLabel.hidden = YES;
}

- (void)showTitle
{
    self.titleLabel.hidden = NO;
}
@end
