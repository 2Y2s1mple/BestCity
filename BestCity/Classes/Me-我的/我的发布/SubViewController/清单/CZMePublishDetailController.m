//
//  CZDChoiceDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMePublishDetailController.h"

// 工具
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"

// 模型
#import "CZTestDetailModel.h"

// 视图
#import "CZNavigationView.h" // 导航
#import "CZBuyView.h"

@interface CZMePublishDetailController () <UIScrollViewDelegate>
// 视图
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 导航栏 */
@property (nonatomic, strong) CZNavigationView *nav;
/** 分享购买按钮 */
@property (nonatomic, strong) UIButton *likeView;
/** 关注按钮 */
@property (nonatomic, strong) UIButton *topBtn;

// 工具
/** 定时器block */
@property (nonatomic, copy) dispatch_block_t block;
/** 数据 */
@property (nonatomic, strong) CZTestDetailModel *dicDataModel;
@end

@implementation CZMePublishDetailController
/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;
/** 文章的类型: 1商品，2评测, 3发现，4试用 */
#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        CGFloat originY = CZGetY(self.topBtn);
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, SCR_WIDTH, SCR_HEIGHT - originY - (IsiPhoneX ? 83 : likeAndShareHeight))];
        if (self.detailType == CZJIPINModuleRelationBK) {
            _scrollerView.frame = CGRectMake(0, originY, SCR_WIDTH, SCR_HEIGHT - originY);
        }
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

- (CZNavigationView *)nav
{
    /** 文章的类型:7清单 */
    if (_nav == nil) {
        _nav = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"清单详情" rightBtnTitle:nil rightBtnAction:nil ];
        [self.view addSubview:_nav];
    }
    return _nav;
}

- (UIButton *)likeView
{
    if (_likeView == nil) {
        _likeView = [[UIButton alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight), SCR_WIDTH, likeAndShareHeight)];
        [_likeView addTarget:self action:@selector(relatedGoodsListAction) forControlEvents:UIControlEventTouchUpInside];
        [_likeView setTitle:@"相关商品" forState:UIControlStateNormal];
        _likeView.backgroundColor = UIColorFromRGB(0xE25838);
        [_likeView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _likeView.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _likeView;
}

- (UIButton *)topBtn
{
    if (_topBtn == nil) {
        CGFloat space = 14.0f;
        _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CZGetY(self.nav), SCR_WIDTH, likeAndShareHeight)];
        _topBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        CGRect rect = [self.remarkStr boundingRectWithSize:CGSizeMake(SCR_WIDTH - 2 * space, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : _topBtn.titleLabel.font} context:nil];
        CGFloat _hei = MAX(likeAndShareHeight, rect.size.height + 20);
        _topBtn.height = _hei;
        [_topBtn setTitle:self.remarkStr forState:UIControlStateNormal];
        _topBtn.backgroundColor = UIColorFromRGB(0xE25838);
        [_topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


    }
    return _topBtn;
}

- (void)relatedGoodsListAction
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
    if (self.dicDataModel.relatedGoodsList.count != 0) {
        CZBuyView *buyView = [[CZBuyView alloc] initWithFrame:self.view.frame];
        buyView.buyDataList = self.dicDataModel.relatedGoodsList;
        [self.view addSubview:buyView];
    }
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
            // 创建内容视图
            [self createSubViews];
            [self.view addSubview:self.likeView];
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 初始化视图
- (void)createSubViews
{
    CGFloat space = 14.0f;
    /**加载开箱测评*/
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 2 * space, SCR_WIDTH - 2 * space, 20)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.dicDataModel.title;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [self.scrollerView addSubview:titleLabel];
    CGRect rect = [self.dicDataModel.title boundingRectWithSize:CGSizeMake(SCR_WIDTH - 2 * space, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titleLabel.font} context:nil];
    CGFloat _hei = MAX(20, rect.size.height);
    titleLabel.height = _hei;

    //头像
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.layer.cornerRadius = 25;
    iconImage.layer.masksToBounds = YES;
    [iconImage sd_setImageWithURL:[NSURL URLWithString:self.dicDataModel.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    iconImage.frame = CGRectMake(space, CZGetY(titleLabel) + (2 * space), 50, 50);
    [self.scrollerView addSubview:iconImage];

    //名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(iconImage) + space, iconImage.y + 15, 100, 20)];
    nameLabel.text = self.dicDataModel.user[@"nickname"];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    [nameLabel sizeToFit];
    nameLabel.textColor = CZRGBColor(21, 21, 21);
    [self.scrollerView addSubview:nameLabel];

    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CZGetX(nameLabel) + space, nameLabel.y, 160, 20)];
    timeLabel.text = self.dicDataModel.createTimeStr;
    timeLabel.textColor = CZGlobalGray;
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    [self.scrollerView addSubview:timeLabel];

    if (self.dicDataModel.contentType == 3) {
        NSData *jsonData = [self.dicDataModel.content dataUsingEncoding:NSUTF8StringEncoding];

        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        CGFloat recordY = CZGetY(iconImage);
        for (NSDictionary *dic in dataArr) {
            if ([dic[@"type"]  isEqual: @"1"]) { // 文字
                UILabel *label = [self setupTitleView];
                label.text = dic[@"value"];
                [label sizeToFit];
                label.y = recordY + 20;
                recordY += label.height + 20;
                [self.scrollerView addSubview:label];
            } else {
                UIImageView *bigImage = [self setupImageView];
                CGFloat imageHeight = bigImage.width * [dic[@"height"] floatValue] / [dic[@"width"] floatValue];
                bigImage.height = imageHeight;
                bigImage.y = recordY + 20;
                recordY += bigImage.height + 20;
                [self.scrollerView addSubview:bigImage];
                [bigImage sd_setImageWithURL:[NSURL URLWithString:dic[@"value"]] completed:nil];
            }
        }
        //加个分隔线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, recordY + 49, SCR_WIDTH, 7)];
        lineView.backgroundColor = CZGlobalLightGray;
        [self.scrollerView addSubview:lineView];

        self.scrollerView.contentSize = CGSizeMake(0, CGRectGetMaxY(lineView.frame));
    }
}

- (UILabel *)setupTitleView
{
    UILabel *label = [[UILabel alloc] init];
    label.x = 14;
    label.width = SCR_WIDTH - 24;
    label.textColor = CZBLACKCOLOR;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    return label;
}

- (UIImageView *)setupImageView
{
    UIImageView *bigImage = [[UIImageView alloc] init];
    bigImage.x = 14;
    bigImage.width = SCR_WIDTH - 24;
    bigImage.height = 200;
    return bigImage;
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建滚动视图
    [self.view addSubview:self.scrollerView];
    // 创建导航栏
    [self.view addSubview:self.nav];
    [self.view addSubview:self.topBtn];
    // 获取数据
    [self obtainDetailData];

    
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


#pragma mark - <UIScrollViewDelegate>
/** 子控制器会用到 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
