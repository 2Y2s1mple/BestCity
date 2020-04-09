//
//  CZMemberOfCenterController.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/1.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterController.h"
#import "CZMemberOfCenterOneView.h"
#import "CZMemberOfCenterTwoCommonView.h"
#import "GXScrollAD.h"
#import "CZScrollADCell.h"
#import "CZMemberOfCenterThreeView.h"
#import "CZMemberOfCenterFourView.h"
#import "CZMemberOfCenterFiveView.h"
#import "GXNetTool.h"
#import "UIButton+CZExtension.h" // 按钮扩展

@interface CZMemberOfCenterController ()
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 创建顶部 */
@property (nonatomic, strong) UIView *topBackView;
/** 卡片 */
@property (nonatomic, strong) CZMemberOfCenterTwoCommonView *cardCommon;
/** 轮播图 */
@property (nonatomic, strong) UIView *scrollimageBackView;
@property (nonatomic, strong) GXScrollAD *scrollImageView;

/** 广告 */
@property (nonatomic, strong) GXScrollAD *adImage;
/** 拉新必备 */
@property (nonatomic, strong) CZMemberOfCenterThreeView *laxinView;
/** vip进度 */
@property (nonatomic, strong) CZMemberOfCenterFourView *vipView;
/** <#注释#> */
@property (nonatomic, strong) CZMemberOfCenterFiveView *teacherView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
/** <#注释#> */
@property (nonatomic, strong) UIButton *popButton;
@end

@implementation CZMemberOfCenterController

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

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.y = (IsiPhoneX ? 44 : 20) + 10 + 30;
        if (!_isNavPush) {
            _scrollView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49) - _scrollView.y);
        } else {
            _scrollView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0) - _scrollView.y);
        }
//        _scrollView.backgroundColor = UIColorFromRGB(0xE04625);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self createTitle];

    [self.view addSubview:self.scrollView];

    // 刷新
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView.mj_header beginRefreshing];
}

#pragma mark - 创建UI
// 创建标题
- (void)createTitle
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = UIColorFromRGB(0x222222);
    backView.size = CGSizeMake(SCR_WIDTH, (IsiPhoneX ? 44 : 20) + 10 + 30);
    [self.view addSubview:backView];

    CZMemberOfCenterOneView *titleView = [CZMemberOfCenterOneView memberOfCenterOneView];
    titleView.isNavPush = self.isNavPush;
    titleView.y = (IsiPhoneX ? 44 : 20) + 10;
    titleView.size = CGSizeMake(SCR_WIDTH, 30);
    [backView addSubview:titleView];
}

- (void)createTopView
{
    UIView *topBackView = [[UIView alloc] init];
    self.topBackView = topBackView;
    topBackView.backgroundColor = UIColorFromRGB(0x222222);
    topBackView.width = SCR_WIDTH;
    topBackView.height = 296;
    [self.scrollView addSubview:topBackView];


    CZMemberOfCenterTwoCommonView *cardCommon = [CZMemberOfCenterTwoCommonView mMemberOfCenterTwoCommonView];
    self.cardCommon = cardCommon;
    cardCommon.y = 34;
    cardCommon.x = 10;
    cardCommon.width = SCR_WIDTH - 20;
    [topBackView addSubview:cardCommon];
    cardCommon.param = self.dataDic;

    UILabel *title = [[UILabel alloc] init];
    title.text = @"VIP尊享特权";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UIColorFromRGB(0xFAE1BF);
    title.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 23];
    [title sizeToFit];
    title.y = topBackView.height - 50;
    title.centerX = topBackView.width / 2.0;
    [topBackView addSubview:title];
}

// 创建轮播图
- (void)createScollView
{
    // 轮播图
    UIView *scrollimageView = [[UIView alloc] init];
    self.scrollimageBackView = scrollimageView;
//    scrollimageView.backgroundColor = [UIColor redColor];
    scrollimageView.y = CZGetY(self.topBackView);
    scrollimageView.width = SCR_WIDTH;
    [self.scrollView addSubview:scrollimageView];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MemberOfCenter-1"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.width = SCR_WIDTH;
    [scrollimageView addSubview:imageView];

    scrollimageView.height = imageView.height + 10;

    CGRect frame = CGRectMake(20, 20, SCR_WIDTH - 40, 190);
    NSArray *list = self.dataDic[@"imgList"];
    GXScrollAD *scrollView = [[GXScrollAD alloc] initWithFrame:frame dataSourceList:list scrollerConfig:^(GXScrollAD * _Nonnull maker) {
        maker.isAutoScroll = NO;
    } registerCell:nil scrollADCell:nil];
    self.scrollImageView = scrollView;
    [scrollimageView addSubview:scrollView];

    CGRect pageViewFrame = CGRectMake(0, CZGetY(scrollView) + 10, 40, 20);
    UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:pageViewFrame];
    //        _pageContrl.backgroundColor = [UIColor redColor];
    pageView.numberOfPages = 3;

    [pageView setValue:[UIImage imageNamed:@"MemberOfCenter-14"] forKeyPath:@"_currentPageImage"];
    [pageView setValue:[UIImage imageNamed:@"MemberOfCenter-13"] forKeyPath:@"_pageImage"];

    pageView.centerX  = SCR_WIDTH / 2.0;
    [scrollimageView addSubview:pageView];

    scrollView.currentIndexBlock = ^(NSInteger index) {
        NSLog(@"%ld", index);
        pageView.currentPage = index;
    };


}

// 广告
- (void)createAd
{
    CGRect frame = CGRectMake(10, CZGetY(self.scrollimageBackView) + 10, SCR_WIDTH - 20, 38);
    NSArray *list = self.dataDic[@"messageList"];
    GXScrollAD *scrollImage = [[GXScrollAD alloc] initWithFrame:frame dataSourceList:list scrollerConfig:^(GXScrollAD * _Nonnull maker) {
        maker.timeInterval = 2;
        maker.scrollDirection = UICollectionViewScrollDirectionVertical;
    } registerCell:^(UICollectionView * _Nonnull collectionView) {
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZScrollADCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZScrollADCell"];
    } scrollADCell:^UICollectionViewCell * _Nonnull(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
        NSDictionary *model = list[indexPath.item];
        CZScrollADCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZScrollADCell" forIndexPath:indexPath];
        cell.paramDic = model;
        return cell;
    }];
    scrollImage.backgroundColor = UIColorFromRGB(0xF8DBB5);
    scrollImage.layer.cornerRadius = 19;
    scrollImage.layer.masksToBounds = YES;
    scrollImage.selectedIndexBlock = ^(NSInteger index) {
        NSLog(@"%ld", index);
        // 跳好友
        [CZFreePushTool push_inviteFriend];
    };
    self.adImage = scrollImage;
    [self.scrollView addSubview:scrollImage];
}

// 拉新必备
- (void)createlaxinView
{
    CZMemberOfCenterThreeView *laxinView = [CZMemberOfCenterThreeView memberOfCenterThreeView];
    self.laxinView = laxinView;
    laxinView.y = CZGetY(self.adImage) + 13;
    laxinView.width = SCR_WIDTH;
    [self.scrollView addSubview:laxinView];

}

// vip进度
- (void)createvipJinduView
{
    CZMemberOfCenterFourView *vipView = [CZMemberOfCenterFourView memberOfCenterFourView];
    self.vipView = vipView;
    vipView.y = CZGetY(self.laxinView) + 30;
    vipView.width = SCR_WIDTH;
    [self.scrollView addSubview:vipView];
    vipView.param = self.dataDic;

}

// 专属导师
- (void)createTeacherView
{
    CZMemberOfCenterFiveView *vipView = [CZMemberOfCenterFiveView memberOfCenterFiveView];
    self.teacherView = vipView;
    vipView.y = CZGetY(self.vipView) + 50;
    vipView.width = SCR_WIDTH;
    [self.scrollView addSubview:vipView];
    vipView.param = self.dataDic;
}

#pragma mark - 数据
#pragma mark - 获取数据
- (void)setupRefresh
{
    self.scrollView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];

//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

- (void)reloadNewTrailDataSorce
{
    // 先结束头部刷新
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/user/levelIndex"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataDic = result[@"data"];

            if (self.scrollImageView == nil) {

                // 顶部标题卡片
                [self createTopView];

                // 轮播图
                [self createScollView];

                // 广告
                [self createAd];

                // 拉新必备
                [self createlaxinView];

                // vip进度
                [self createvipJinduView];

                // 专属导师
                [self createTeacherView];

                self.scrollView.contentSize = CGSizeMake(0, CZGetY([self.scrollView.subviews lastObject]) + 100);
            } else {
                [self loadNewData];
            }

        }
        // 结束刷新
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.scrollView.mj_header endRefreshing];
    }];
}



#pragma mark - 控制状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 刷新
- (void)loadNewData
{
    // 卡片
    self.cardCommon.param = self.dataDic;
    // 轮播图
    self.scrollImageView.dataSourceList = self.dataDic[@"imgList"];
    [self.scrollImageView reloadDataSource];
    // VIP进度
    self.vipView.param = self.dataDic;
    // 专属老师
    self.teacherView.param = self.dataDic;

}
@end
