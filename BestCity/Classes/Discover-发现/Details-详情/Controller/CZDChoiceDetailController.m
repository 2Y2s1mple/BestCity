//
//  CZDChoiceDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDChoiceDetailController.h"
#import "GXNetTool.h"
#import "CZRecommendNav.h" // 导航
#import "CZTestSubController.h" // 测评
#import "CZEvaluateSubController.h" // 评论

/** 模型 */
#import "CZTestDetailModel.h"
#import "CZShareAndlikeView.h" // 分享
#import "CZBuyView.h"
#import "CZAttentionBtn.h"
#import "UIImageView+WebCache.h"



@interface CZDChoiceDetailController () <CZRecommendNavDelegate, UIScrollViewDelegate>
/** 分享参数 */
@property (nonatomic, strong) NSDictionary *shareParam;
/** 数据 */
@property (nonatomic, strong) CZTestDetailModel *dicDataModel;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 导航栏 */
@property (nonatomic, strong) CZRecommendNav *nav;
/** 评测 */
@property (nonatomic, strong) CZTestSubController *testVc;
/** 评价 */
@property (nonatomic, strong) CZEvaluateSubController *evaluate;
/** 分享购买按钮 */
@property (nonatomic, strong) CZShareAndlikeView *likeView;
/** 记录偏移量 */
@property (nonatomic, assign) CGFloat recordOffsetY;
/** 关注按钮 */
@property (nonatomic, strong) CZAttentionBtn *attentionBtn;
/** 小头像 */
@property (nonatomic, strong) UIImageView *header;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CZDChoiceDetailController
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;
/** 文章的类型: 1商品，2评测, 3发现，4试用 */
#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        CGFloat originY = (IsiPhoneX ? 44 : 20) + 40;
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, SCR_HEIGHT - originY - likeAndShareHeight)];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

- (CZRecommendNav *)nav
{
    /** 文章的类型: 1商品，2评测, 3发现，4试用 */
    if (_nav == nil) {
        if (self.detailType == CZDChoiceDetailControllerDiscover) {
            self.nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 40) type:CZRecommendNavDiscover];
            self.nav.type = @"3";
        } else {
            self.nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, 40) type:CZRecommendNavEvaluation];
            self.nav.type = @"2";
        }
        self.nav.projectId = self.findgoodsId;
        self.nav.delegate = self;
    }
    return _nav;
}

- (CZShareAndlikeView *)likeView
{
    if (_likeView == nil) {
        __weak typeof(self) weakSelf = self;
        _likeView = [[CZShareAndlikeView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight), SCR_WIDTH, likeAndShareHeight) leftBtnAction:^{
            CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
            share.param = self.shareParam;
            [weakSelf.view addSubview:share];
        } rightBtnAction:^{
            if (self.dicDataModel.relatedGoodsList.count != 0) {
                CZBuyView *buyView = [[CZBuyView alloc] initWithFrame:self.view.frame];
                buyView.buyDataList = self.dicDataModel.relatedGoodsList;
                [weakSelf.view addSubview:buyView];
            }
        }];
        if (self.dicDataModel.relatedGoodsList.count != 0) {
            _likeView.titleData = @{@"left" : @"分享", @"right" : @"相关商品"};
        } else {
            _likeView.titleData = @{@"left" : @"分享", @"right" : @"暂无商品"};
        }
    }
    return _likeView;
}

#pragma mark - 获取数据
- (void)obtainDetailData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = self.findgoodsId;
    if (self.detailType == CZDChoiceDetailControllerDiscover) {
        param[@"type"] = @"3";
    } else {
        param[@"type"] = @"2";
    }
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/article/detail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dicDataModel = [CZTestDetailModel objectWithKeyValues:result[@"data"]];
            // 创建内容视图
            [self createSubViews];
            // 创建分享购买视图
            NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
            shareDic[@"shareTitle"] =  self.dicDataModel.shareTitle;
            shareDic[@"shareContent"] = self.dicDataModel.shareContent;
            shareDic[@"shareUrl"] = self.dicDataModel.shareUrl;
            shareDic[@"shareImg"] = self.dicDataModel.shareImg;
            self.shareParam = shareDic;
            [self.view addSubview:self.likeView];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
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
    NSString *type  = (self.detailType == CZDChoiceDetailControllerDiscover) ? @"3" : @"2";
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
    self.scrollerView.contentSize = CGSizeMake(0, self.testVc.scrollerView.height + self.evaluate.scrollerView.height);
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


#pragma mark - 取消关注
- (void)deleteAttention
{
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

#pragma mark - 新增关注
- (void)addAttention
{
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

@end
