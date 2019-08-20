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
/** 背景View */
@property (nonatomic, strong) UIView *imageBackView;
/**  */
@property (nonatomic, strong) UIButton *likeBtn;
/** 点赞数 */
@property (nonatomic, strong) NSString *voteCount;



@end

@implementation CZGiveLikeView
#pragma mark - 商品的ID
- (void)setCurrentID:(NSString *)currentID
{
    _currentID = currentID;
    // 判断是否点赞
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
    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.imageBackView = imageBackView;
    imageBackView.layer.borderWidth = 1;
    imageBackView.layer.borderColor = [CZREDCOLOR CGColor];
    imageBackView.layer.cornerRadius = 5;
    imageBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    [imageBackView addGestureRecognizer:tap]; 
    [self addSubview:imageBackView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    [btn setImage:[UIImage imageNamed:@"like-nor-1"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"like-sel"] forState:UIControlStateSelected];
    [btn setTitleColor:CZREDCOLOR forState:UIControlStateSelected];
    [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn sizeToFit];
    btn.center = CGPointMake(self.width / 2, self.height / 2);
    self.likeBtn = btn;
    [self addSubview:btn];
}

#pragma mark - 点击方法
- (void)action
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:^{
            UINavigationController *nav = tabbar.selectedViewController;
            UIViewController *currentVc = nav.topViewController;
            [currentVc.navigationController popViewControllerAnimated:nil];
        }];
        return;
    }
    self.imageBackView.userInteractionEnabled = NO;

    // 判断是否点击过
    if (!self.likeBtn.isSelected) {
        // 点赞
        [self snapInsert];
    } else {
        // 取消点赞
        [self snapDelete];
    }
}

#pragma mark - 取消点赞接口
- (void)snapDelete
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.currentID;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/vote/delete"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            self.likeBtn.selected = NO;
            self.voteCount = [NSString stringWithFormat:@"%ld", ([self.voteCount integerValue] - 1)];
            [self snapStyle];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"取消失败"];
        }
        self.imageBackView.userInteractionEnabled = YES;
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
    param[@"targetId"] = self.currentID;
    param[@"type"] = self.type;
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/vote/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.likeBtn.selected = YES;
            self.voteCount = [NSString stringWithFormat:@"%ld", ([self.voteCount integerValue] + 1)];
            [self snapStyle];
        } 
        [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        self.imageBackView.userInteractionEnabled = YES;
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
    param[@"targetId"] = self.currentID;
    param[@"type"] = self.type;
    
    // 获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/view/status"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"vote"] isEqualToNumber:@(1)]) {
            self.likeBtn.selected = YES;
        } else {
            self.likeBtn.selected = NO;
        }
        self.voteCount = result[@"voteCount"];
        // 加载样式
        [self snapStyle];
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 加载样式
- (void)snapStyle
{
    if ([self.voteCount integerValue] == 0) { // 一个人也没有的情况
        self.likeBtn.selected = NO; // 灰色💕
        [self.likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
        self.imageBackView.layer.borderColor = [CZGlobalGray CGColor];
        
    } else if (!self.likeBtn.isSelected){
        self.imageBackView.layer.borderColor = [CZGlobalGray CGColor];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@", self.voteCount] forState:UIControlStateNormal];
    } else {
        self.imageBackView.layer.borderColor = [CZREDCOLOR CGColor];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@", self.voteCount] forState:UIControlStateNormal];
    }  
    [self.likeBtn sizeToFit];
    self.likeBtn.width += 10;
    self.likeBtn.centerX = self.width / 2.0;
}


@end
