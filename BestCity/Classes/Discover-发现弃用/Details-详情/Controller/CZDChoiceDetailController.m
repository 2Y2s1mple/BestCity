//
//  CZDChoiceDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDChoiceDetailController.h"

// 工具
#import "GXNetTool.h"
#import "CZAttentionBtn.h"
#import "UIImageView+WebCache.h"

// 模型
#import "CZTestDetailModel.h"

// 视图
#import "CZRecommendNav.h" // 导航
#import "CZTestSubController.h" // 测评
#import "CZEvaluateSubController.h" // 评论
#import "CZCommonRecommendController.h" // 推荐文章
#import "CZBuyView.h"
#import "CZShareView.h"
#import "CZEvaluationBottomView.h"
#import "CZOpenAlibcTrade.h"

// universal links
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/UIViewController+MLSDKRestore.h>


#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import "TSLWebViewController.h"
#import "CZUserInfoTool.h"

@interface CZDChoiceDetailController () <CZRecommendNavDelegate, UIScrollViewDelegate>
// 视图
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 导航栏 */
@property (nonatomic, strong) CZRecommendNav *nav;
/** 评测 */
@property (nonatomic, strong) CZTestSubController *testVc;
/** 评价 */
@property (nonatomic, strong) CZEvaluateSubController *evaluate;
/** 推荐文章 */
@property (nonatomic, strong) CZCommonRecommendController *recommen;
/** 最下面购买条 */
@property (nonatomic, strong) UIView *bottomView;
/** 关注按钮 */
@property (nonatomic, strong) CZAttentionBtn *attentionBtn;
/** 小头像 */
@property (nonatomic, strong) UIImageView *header;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;

// 工具
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
/** 定时器block */
@property (nonatomic, copy) dispatch_block_t block;
/** 分享参数 */
@property (nonatomic, strong) NSDictionary *shareParam;
/** 数据 */
@property (nonatomic, strong) CZTestDetailModel *dicDataModel;
/** 分享按钮数据 */
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) MLSDKScene *scene;
@end

@implementation CZDChoiceDetailController
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 55;
/** 文章的类型: 1商品，2评测, 3发现，4试用 */

//实现带有场景参数的初始化方法，并根据场景参数还原该控制器：
-(instancetype)initWithMobLinkScene:(MLSDKScene *)scene
{
    if (self = [super init]) {
        self.scene = scene;
        if ([self.scene.path isEqualToString:@"/evaluation"]) {
            self.detailType = [CZJIPINSynthesisTool getModuleType:2];
            self.findgoodsId = scene.params[@"id"];
        } else if ([self.scene.path isEqualToString:@"/listing1"]) {
            self.detailType = CZJIPINModuleQingDan;
            self.findgoodsId = scene.params[@"id"];
        } else if ([self.scene.path isEqualToString:@"/listing2"]) {
            self.detailType = CZJIPINModuleQingDan;
            self.findgoodsId = scene.params[@"id"];
        }

    }
    return self;
}

#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        CGFloat originY = (IsiPhoneX ? 44 : 20) + 40;
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, SCR_HEIGHT - originY - (IsiPhoneX ? 83 : likeAndShareHeight))];
        if (self.detailType == CZJIPINModuleRelationBK) {
            _scrollerView.frame = CGRectMake(0, originY, SCR_WIDTH, SCR_HEIGHT - originY);
        }
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

- (CZRecommendNav *)nav
{
    /** 文章的类型: 1商品，2评测, 3发现，4试用 */
    //    1商品，2评测，4试用, 5问答，7清单
    if (_nav == nil) {
        self.nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 40) type:self.detailType];
        self.nav.type = [CZJIPINSynthesisTool getModuleTypeNumber:self.detailType];
        self.nav.projectId = self.findgoodsId;
        self.nav.delegate = self;
        if (self.TitleText.length > 0) {
            self.nav.titleText = self.TitleText;
        }

        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"Forward-1"] forState:UIControlStateNormal];
        shareBtn.size = CGSizeMake(20, 20);
        shareBtn.centerY = 20;
        shareBtn.x = SCR_WIDTH - 80;
        [_nav addSubview:shareBtn];
        [shareBtn addTarget:self action:@selector(createShareAlert) forControlEvents:UIControlEventTouchUpInside];

    }
    return _nav;
}

#pragma mark - 组下面的购买条
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight), SCR_WIDTH, likeAndShareHeight)];
        _bottomView.backgroundColor = RANDOMCOLOR;

        if (self.dicDataModel.relatedGoodsList.count == 1) {
            CZEvaluationBottomView *bottom = [CZEvaluationBottomView evaluationBottomView];
            bottom.size = _bottomView.size;
            [_bottomView addSubview:bottom];
            __weak typeof(self) weakSelf = self;
            bottom.paramDic = [self.dicDataModel.relatedGoodsList firstObject];
            [bottom setBugBlock:^{
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
                [weakSelf openTaobao];
            }];
            
        } else if (self.dicDataModel.relatedGoodsList.count > 1) {
            UIButton *moreGoods = [[UIButton alloc] init];
            moreGoods.size = _bottomView.size;
            moreGoods.backgroundColor = UIColorFromRGB(0xE25838);
            [moreGoods setTitle:@"相关商品" forState:UIControlStateNormal];
            [moreGoods setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            moreGoods.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
            [_bottomView addSubview:moreGoods];
            [moreGoods addTarget:self action:@selector(jumpRelatedGoodsList) forControlEvents:UIControlEventTouchUpInside];
        } else {
            UIButton *moreGoods = [[UIButton alloc] init];
            moreGoods.size = _bottomView.size;
            moreGoods.backgroundColor = UIColorFromRGB(0xE25838);
            [moreGoods setTitle:@"暂无商品" forState:UIControlStateNormal];
            [moreGoods setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            moreGoods.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
            [_bottomView addSubview:moreGoods];
        }
    }
    return _bottomView;


//    if (_likeView == nil) {
//
//        _likeView = [[CZShareAndlikeView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight), SCR_WIDTH, likeAndShareHeight) leftBtnAction:^{
//
//        } rightBtnAction:^{


//        }];
//        if (self.dicDataModel.relatedGoodsList.count != 0) {
//            NSDictionary *versionParam = [CZSaveTool objectForKey:requiredVersionCode];
//              if ( [versionParam[@"open"] isEqualToNumber:@(1)]) {
//                  _likeView.titleData = @{@"left" : self.dataDic[@"btnTxt"], @"right" : self.dataDic[@"btnTxt2"]};
//              } else {
//                  _likeView.titleData = @{@"left" : @"分享", @"right" : @"相关商品"};
//              }
//        } else {
//            _likeView.titleData = @{@"left" : @"分享", @"right" : @"暂无商品"};
//        }
//    }
//    return _likeView;
}

#pragma mark - 获取数据
- (void)obtainDetailData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.findgoodsId;
    param[@"type"] = [CZJIPINSynthesisTool getModuleTypeNumber:self.detailType];

    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/article/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dicDataModel = [CZTestDetailModel objectWithKeyValues:result[@"data"]];
            self.dataDic = result;
            // 创建内容视图
            [self createSubViews];
            // 创建分享购买视图
            NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
            shareDic[@"shareTitle"] =  self.dicDataModel.shareTitle;
            shareDic[@"shareContent"] = self.dicDataModel.shareContent;
            shareDic[@"shareUrl"] = self.dicDataModel.shareUrl;
            shareDic[@"shareImg"] = self.dicDataModel.shareImg;
            self.shareParam = shareDic;
            if (self.detailType != CZJIPINModuleRelationBK) {
                [self.view addSubview:self.bottomView];
            }
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 初始化视图
- (void)createSubViews
{
    UIImageView *header = [[UIImageView alloc] init];
    [header sd_setImageWithURL:self.dicDataModel.user[@"avatar"] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.header = header;
    [self.nav addSubview:header];
    header.x = 44;
    header.height = 20;
    header.width = 20;
    header.layer.cornerRadius = header.width * 0.5;
    header.layer.masksToBounds = YES;
    header.centerY = self.nav.height / 2.0;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.text = self.dicDataModel.user[@"nickname"];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    [nameLabel sizeToFit];
    [self.nav addSubview:nameLabel];
    nameLabel.x = CZGetX(header) + 5;
    nameLabel.centerY = header.centerY;
    
    // 关注按钮
    CZAttentionBtnType type1;
    if ([self.dicDataModel.user[@"follow"] integerValue] == 0) {
        type1 = CZAttentionBtnTypeAttention;
    } else {
        type1 = CZAttentionBtnTypeFollowed;
    }
    self.attentionBtn = [CZAttentionBtn attentionBtnWithframe:CGRectMake(CZGetX(nameLabel) + 15, nameLabel.y, 50, 22) CommentType:type1 didClickedAction:^(BOOL isSelected){
        if (isSelected) {
            [self addAttention];
        } else {
            [self deleteAttention];
        }
    }];
    
    [self.nav addSubview:self.attentionBtn];
    self.nameLabel.hidden = YES;
    self.header.hidden = YES;
    self.attentionBtn.hidden = YES;
    
    /** 文章的类型: 1商品，2评测, 3发现，4试用 */
    NSString *type  = (self.detailType == CZJIPINModuleDiscover || self.detailType == CZJIPINModuleRelationBK) ? [CZJIPINSynthesisTool getModuleTypeNumber:self.detailType] : [CZJIPINSynthesisTool getModuleTypeNumber:CZJIPINModuleEvaluation];
    
    // 测评
    self.testVc = [[CZTestSubController alloc] init];
    self.testVc.view.y = 0;
    [self.scrollerView addSubview:self.testVc.view];
    [self addChildViewController:self.testVc];
    self.testVc.detailTtype = type; 
    self.testVc.model = self.dicDataModel;
    
    // 评价
    self.evaluate = [[CZEvaluateSubController alloc] init];
    self.evaluate.view.y = self.testVc.scrollerView.height;
    [self.scrollerView addSubview:self.evaluate.view];
    [self addChildViewController:self.evaluate];
    self.evaluate.type = type;
    self.evaluate.targetId = self.dicDataModel.articleId;
    
    // 推荐文章
    if (self.detailType != CZJIPINModuleRelationBK) {
        self.recommen = [[CZCommonRecommendController alloc] init];
        self.recommen.view.y = self.evaluate.view.y + self.evaluate.scrollerView.height;
        self.recommen.articleArr = self.dicDataModel.relatedArticleList;
        [self.scrollerView addSubview:self.recommen.view];
        [self addChildViewController:self.recommen];
    }
    
    // 设置滚动高度
    self.scrollerView.contentSize = CGSizeMake(0, self.testVc.scrollerView.height + self.evaluate.scrollerView.height);
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 获取数据
    [self obtainDetailData];
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    // 创建导航栏
    [self.view addSubview:self.nav];
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBoxInspectWebViewHeightChange:) name:OpenBoxInspectWebHeightKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionChange:) name:@"discoverAttentionChangeNOtification" object:nil];
    
    self.block = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        [CZGetJIBITool getJiBiWitType:@(6)];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), self.block);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    dispatch_block_cancel(self.block);
}

#pragma mark - 监听关注的变化
- (void)attentionChange:(NSNotification *)notifi
{
    NSDictionary *dic = notifi.userInfo;
    if ([dic[@"value"] integerValue] == 0) {
        self.attentionBtn.type = CZAttentionBtnTypeAttention; // 取消关注样式
    } else {
        self.attentionBtn.type = CZAttentionBtnTypeFollowed; // 关注样式
    }
}

#pragma mark - 监听子控件的frame的变化
- (void)openBoxInspectWebViewHeightChange:(NSNotification *)notfi
{
    self.evaluate.view.y = self.testVc.scrollerView.height;
    self.recommen.view.y = self.evaluate.view.y + self.evaluate.scrollerView.height;
    
    self.scrollerView.contentSize = CGSizeMake(0, self.testVc.scrollerView.height + self.evaluate.scrollerView.height + self.recommen.view.height);
}

#pragma mark - <UIScrollViewDelegate>
/** 子控制器会用到 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - <CZRecommendNavDelegate>
- (void)recommendNavWithPop:(UIView *)view
{
    [CZProgressHUD hideAfterDelay:0];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickedTitleWithIndex:(NSInteger)index
{
    CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
    share.param = @{
                    @"shareUrl" : [NSString stringWithFormat:@"https://www.jipincheng.cn/share/bkDetail.html?id=%@", self.findgoodsId],
                    @"shareTitle" : self.dicDataModel.shareTitle,
                    @"shareContent" : self.dicDataModel.shareContent,
                    @"shareImg" : [UIImage imageNamed:@"headDefault"],
                    };
    [self.view addSubview:share];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0 && offsetY < scrollView.contentSize.height - scrollView.height) {
        if (offsetY >= 120) {
            self.nameLabel.hidden = NO;
            self.header.hidden = NO;
            self.attentionBtn.hidden = NO;
            [self.nav hiddenTitle];
            
        } else {
            self.nameLabel.hidden = YES;
            self.header.hidden = YES;
            self.attentionBtn.hidden = YES;
            [self.nav showTitle];
        }
        self.recordOffsetY = offsetY;
    }
}

#pragma mark - 事件
// 取消关注
- (void)deleteAttention
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.dicDataModel.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/delete"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            // 关注
            self.attentionBtn.type = CZAttentionBtnTypeAttention;
            [CZProgressHUD showProgressHUDWithText:@"取关成功"];
            self.testVc.isAttentionUser = NO; // 通知设置测评界面的关注
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

//新增关注
- (void)addAttention
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = self.dicDataModel.user[@"userId"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"关注成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"关注成功"];
            self.attentionBtn.type = CZAttentionBtnTypeFollowed;
            self.testVc.isAttentionUser = YES; // 通知设置测评界面的关注
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 创建分享视图
- (void)createShareAlert
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

    // 为了同步关联的淘宝账号
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
        if (isAuthTaobao) {
            CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
            share.shareTypeParam = @{@"type" : @"2", @"object" : self.findgoodsId}; // 评测
            share.param = self.shareParam;
            [self.view addSubview:share];
        }
    }];
}

- (void)jumpRelatedGoodsList
{
    CZBuyView *buyView = [[CZBuyView alloc] initWithFrame:self.view.frame];
    buyView.buyDataList = self.dicDataModel.relatedGoodsList;
    [self.view addSubview:buyView];
}

- (void)openTaobao
{
    NSDictionary *dic = [self.dicDataModel.relatedGoodsList firstObject];
    // 为了同步关联的淘宝账号
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
        if (isAuthTaobao) {
            // 打开淘宝
            [self openAlibcTradeWithId:dic[@"goodsId"]];
        }
    }];
}

- (void)openAlibcTradeWithId:(NSString *)ID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = ID;
    //获取详情数据
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsBuyLink"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZJIPINSynthesisTool jipin_jumpTaobaoWithUrlString:result[@"data"]];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"接口错误"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}











@end
