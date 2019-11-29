//
//  CZTaobaoDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTaobaoDetailController.h"
#import "CZScollerImageTool.h"
#import "GXNetTool.h"
#import "UIButton+CZExtension.h" // 按钮扩展
#import "CZCollectButton.h"

// 视图
#import "CZTaobaoGoodsView.h"
#import "CZTaoBaoShopNameView.h" // 淘宝商家标题

@interface CZTaobaoDetailController ()<UIScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *detailModel;
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
/** 收藏 */
@property (nonatomic, strong) CZCollectButton *collectButton;

/** <#注释#> */
@property (nonatomic, assign) CGFloat recordHeight;
@end

/** 分享控件高度 */
static CGFloat const likeAndShareHeight = 49;
@implementation CZTaobaoDetailController
#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : likeAndShareHeight))];
        self.scrollerView.delegate = self;
        _scrollerView.backgroundColor = CZGlobalWhiteBg;
    }
    return _scrollerView;
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CZCollectButton *)collectButton
{
    if (_collectButton == nil) {
        _collectButton = [CZCollectButton collectButton];
        _collectButton.frame = CGRectMake(SCR_WIDTH - 14 - 30, (IsiPhoneX ? 54 : 30), 30, 30);
        [_collectButton setImage:[UIImage imageNamed:@"hot-list-favor"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"nav-favor-sel"] forState:UIControlStateSelected];
        _collectButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _collectButton.layer.cornerRadius = 15;
        _collectButton.layer.masksToBounds = YES;
        _collectButton.type = @"1";
        _collectButton.commodityID = self.otherGoodsId;
    }
    return _collectButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self getSourceData];

    [self.view addSubview:self.scrollerView];

    // 加载pop按钮
    [self.view addSubview:self.popButton];

    // 加载收藏按钮
    [self.view addSubview:self.collectButton];
}

- (void)getSourceData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"otherGoodsId"] = @"560617264724";
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/goodsDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.detailModel = result[@"data"];

            // 初始化顶部视图
            [self imageGoodsView];

            // 最下面购买视图
            [self setupBottomView];

            self.scrollerView.contentSize = CGSizeMake(0, self.recordHeight);
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 轮播图和详情
- (void)imageGoodsView
{
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 370)];
    [self.scrollerView addSubview:imageView];
    imageView.imgList = [self.detailModel[@"imgList"] isKindOfClass:[NSNull class]] ? @[] : self.detailModel[@"imgList"];
    self.recordHeight += imageView.height; // 高度

    CZTaobaoGoodsView *titlesView = [CZTaobaoGoodsView taobaoGoodsView];
    titlesView.y = self.recordHeight;
    titlesView.width = SCR_WIDTH;
    titlesView.model = self.detailModel;
    [self.scrollerView addSubview:titlesView];
    self.recordHeight += titlesView.commodityH; // 高度

    // 功能评分
    [self functionScoresViewImage:@"quality" title:@"功能评分" contextList:self.detailModel[@"scoreOptionsList"]];

    // 产品参数
    [self functionScoresViewImage:@"parameter" title:@"产品参数" contextList:self.detailModel[@"parametersList"]];
    self.recordHeight += 8; // 高度

    // 淘宝商家
    CZTaoBaoShopNameView *shopNameView = [CZTaoBaoShopNameView taoBaoShopNameView];
    [self.scrollerView addSubview:shopNameView];
    shopNameView.paramDic = self.detailModel;
    shopNameView.y = self.recordHeight;
    self.recordHeight += shopNameView.height; // 高度

    // 推荐理由
    [self recommendReason];

    
}

// 初始化底部菜单
- (void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.size = CGSizeMake(SCR_WIDTH, 49);
    bottomView.y = SCR_HEIGHT - (IsiPhoneX ? 83 : 49);
    [self.view addSubview:bottomView];

    // 两个按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(0, 0, 145, bottomView.height);
    [shareBtn setTitle:@"  分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"Forward-2"] forState:UIControlStateNormal];
    shareBtn.backgroundColor = CZBTNGRAY;
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shareBtn];

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(shareBtn.width, shareBtn.y, SCR_WIDTH - shareBtn.width, shareBtn.height);


    NSString *buyBtnStr = @"立即购买（省¥%.2lf）";
    buyBtnStr = [NSString stringWithFormat:buyBtnStr, ([self.detailModel[@"fee"] floatValue] + [self.detailModel[@"couponPrice"] floatValue])];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:buyBtnStr];
    [attrStr addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size: 18]} range:NSMakeRange(0, 4)];

    [buyBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = CZREDCOLOR;
    [buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
}


// 创建产品参数
- (void)functionScoresViewImage:(NSString *)iconName title:(NSString *)titleName contextList:(NSArray *)list
{
    UIView *containerView = [[UIView alloc] init];
    containerView.y = self.recordHeight;
    containerView.width = SCR_WIDTH;
    [self.scrollerView addSubview:containerView];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quality"]];
    iconImageView.x = 14;
    iconImageView.y = 14;
    iconImageView.size = CGSizeMake(19, 19);
    [containerView addSubview:iconImageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleName;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [titleLabel sizeToFit];
    titleLabel.centerY = iconImageView.centerY;
    titleLabel.x = CZGetX(iconImageView) + 3;
    [containerView addSubview:titleLabel];


    UIScrollView *scoresView = [[UIScrollView alloc] init];
    [containerView addSubview:scoresView];
    scoresView.y = CZGetY(iconImageView) + 15;
    scoresView.width = SCR_WIDTH;
    scoresView.height = 85;
    scoresView.backgroundColor = [UIColor whiteColor];

    NSInteger count;
    if ([titleName isEqualToString:@"功能评分"]) {
        count = list.count + 1;
    } else {
        count = list.count;
    }
    for (int i = 0; i < count; i++) {
        CGFloat width = 75;
        CGFloat height  = 85;
        UIView *view = [[UIView alloc] init];
        view.x = 14 + i * width;
        view.height = height;
        view.width = width;
        view.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [scoresView addSubview:view];
        scoresView.contentSize = CGSizeMake(CZGetX(view) + 14, 0);

        UILabel *label = [[UILabel alloc] init];
        UILabel *label1 = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label1.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label1.textAlignment = NSTextAlignmentCenter;
        label.height = view.height / 2.0 - 0.75;
        label1.height = label.height;

        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        if (i == (count - 1)) {
            label.x = 0.5;
            label.y = 0.5;
            label.width = view.width - 1;

            label1.x = label.x;
            label1.y = CZGetY(label) + 0.5;
            label1.width = view.width - 1;
        } else {
            label.x = 0.5;
            label.y = 0.5;
            label.width = view.width - 0.5;

            label1.x = label.x;
            label1.y = CZGetY(label) + 0.5;
            label1.width = view.width - 0.5;
        }


        [view addSubview:label];
        [view addSubview:label1];

        if ([titleName isEqualToString:@"功能评分"]) {
            if (i == 0) {
                label.textColor = UIColorFromRGB(0x565252);
                label.text = @"综合评分";

                label1.textColor = UIColorFromRGB(0xE25838);
                label1.text = [NSString stringWithFormat:@"%@分", self.detailModel[@"score"]];
            } else {
                NSDictionary *dic = list[i - 1];
                label.textColor = UIColorFromRGB(0x9D9D9D);
                label.text = dic[@"name"];

                label1.textColor = UIColorFromRGB(0x565252);
                label1.text = [dic[@"score"] stringByAppendingString:@"分"];
            }
        } else {
            NSDictionary *dic = list[i];
            label.textColor = UIColorFromRGB(0x9D9D9D);
            label.text = dic[@"name"];

            label1.textColor = UIColorFromRGB(0x565252);
            label1.text = [dic[@"value"] stringByAppendingString:@"分"];
        }


    }
    containerView.height = CZGetY(scoresView) + 14;
    self.recordHeight += containerView.height ;
}

// 推荐理由
- (void)recommendReason
{
    UIView *backView =[[UIView alloc] init];
    backView.y =self.recordHeight;
    backView.width =SCR_WIDTH;
//    backView.height = 430;
    [self.scrollerView addSubview:backView];

    UIImageView *titleBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taobaoDetail_矩形"]];
    titleBackImage.centerX = backView.width / 2.0;
    titleBackImage.y = 15;
    titleBackImage.size = CGSizeMake(132, 39);
    [backView addSubview:titleBackImage];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"推荐理由";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    titleLabel.size = titleBackImage.size;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBackImage addSubview:titleLabel];

    UIView *subView = [[UIView alloc] init];
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    subView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [backView addSubview:subView];
    subView.x = 14;
    subView.y = 75;
    subView.width = SCR_WIDTH - 28;

    UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"“"]];
    [subView addSubview:topImage];
    topImage.x = 7.5;
    topImage.y = 7.5;


    NSString *contextStr = @"      超大容量1.5L！食品级304不锈钢，一键保温持续70度，自动断电保护，无二次沸腾！用这个温度冲奶粉，泡茶营养价值很高~【赠运费险】   超大容量1.5L！食品级304不锈钢，一键保温持续70度，自动断电保护，无二次沸腾！用这个温度冲奶粉，泡茶营养价值很高~【赠运费险】   超大容量1.5L！食品级304不锈钢，一键保温持续70度，自动断电保护，无二次沸腾！用这个温度冲奶粉，泡茶营养价值很高~【赠运费险】超大容量1.5L！食品级不…钢，一键保温持续70度，自动断电保护，无二次沸腾！用这个温度冲奶粉，泡茶…养价值很高~【赠运费险】";

    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = contextStr;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    contentLabel.x = 25;
    contentLabel.y = CZGetY(topImage) + 3;
    contentLabel.width = subView.width - 50;

    CGFloat height = [contextStr boundingRectWithSize:CGSizeMake(contentLabel.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : contentLabel.font} context:nil].size.height;

    contentLabel.height = height;
    [subView addSubview:contentLabel];

    UIButton *showAll = [UIButton buttonWithType:UIButtonTypeSystem];
    [showAll setTitle:@"展开更多" forState:UIControlStateNormal];
    [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right"] forState:UIControlStateNormal];
    [showAll setImage:[UIImage imageNamed:@"taobaoDetail_list-right-1"] forState:UIControlStateSelected];
    showAll.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    showAll.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    [showAll setTitleColor:UIColorFromRGB(0xCECECE) forState:UIControlStateNormal];
    [subView addSubview:showAll];
    [showAll sizeToFit];
    showAll.y = CZGetY(contentLabel) + 10;
    showAll.centerX = contentLabel.centerX;



    subView.height = CZGetY(showAll);
    backView.height = CZGetY(subView);
    self.recordHeight += backView.height;
}


@end
