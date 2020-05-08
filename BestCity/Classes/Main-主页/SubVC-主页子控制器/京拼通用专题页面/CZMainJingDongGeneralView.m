//
//  CZMainJingDongGeneralView.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMainJingDongGeneralView.h"
#import "GXScrollAD.h"
#import "CZCollectionTypeOneCell.h"
// 工具
#import "GXNetTool.h"
#import "CZCategoryLineLayoutView.h"

@interface CZMainJingDongGeneralView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** <#注释#> */
@property (nonatomic, strong) NSArray *adList;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *mainTitleLabel;
/** <#注释#> */
@property (nonatomic, strong) NSArray *categoryTitles;
/** <#注释#> */
@property (nonatomic, strong) NSString *categoryId;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *categoryType;

@end

@implementation CZMainJingDongGeneralView

- (UICollectionView *)collectView
{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        
        CGFloat Y = IsiPhoneX ? (85 + 44): (85 + 20);
        
        CGRect frame = CGRectMake(0, Y + 10, SCR_WIDTH, SCR_HEIGHT -  Y - 10 - (IsiPhoneX ? 34 : 0));
        _collectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor clearColor];
        _collectView.dataSource = self;
        _collectView.delegate = self;
        [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CZMainJingDongGeneralHeaderView"];
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([CZCollectionTypeOneCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZCollectionTypeOneCell"]; // 一行
    }
    return _collectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainTitleLabel.text = self.mainTitle;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchVC)];
    [self.searchView addGestureRecognizer:tap];
    
    [self getTitles];
    
    [self.view addSubview:self.collectView];

    [self setupRefresh];
}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.collectView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    self.collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.item];
    CZCollectionTypeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZCollectionTypeOneCell" forIndexPath:indexPath];
    cell.dataDic = dic;
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCR_WIDTH, 140);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.item];
    NSDictionary *bannerParam = @{
        @"targetType" : @"12",
        @"targetId" : dic[@"otherGoodsId"],
        @"targetTitle" : @"",
        @"source" : [NSString stringWithFormat:@"%@", dic[@"source"]],
    };
    [CZFreePushTool bannerPushToVC:bannerParam];
}



// 头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.adList.count > 0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CZMainJingDongGeneralHeaderView" forIndexPath:indexPath];
            [headerView addSubview:self.headerView];
            return headerView;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

// 头视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
         if (self.adList.count > 0) {
             return CGSizeMake(0, self.headerView.height);
         } else {
             return CGSizeZero;
         }
    } else {
        return CGSizeZero;
    }
}

// 头视图
- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.width = SCR_WIDTH;
        
        NSMutableArray *list = [NSMutableArray array];
        [self.adList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [list addObject:obj[@"img"]];
        }];
        
        GXScrollAD *ad = [[GXScrollAD alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 160) dataSourceList:list scrollerConfig:^(GXScrollAD * _Nonnull maker) {
            maker.isShowPageView = YES;
        } registerCell:nil scrollADCell:nil];
        
        ad.selectedIndexBlock = ^(NSInteger index) {
            NSLog(@"%ld", index);
            NSDictionary *dic = self.adList[index];
            NSDictionary *param = @{
                @"targetType" : dic[@"type"],
                @"targetId" : dic[@"objectId"],
                @"targetTitle" : dic[@"name"],
            };
            [CZFreePushTool bannerPushToVC:param];
        };
        [_headerView addSubview:ad];
        
        
        CGRect frame = CGRectMake(0, CZGetY(ad), SCR_WIDTH, 50);
        // 分类的按钮
        NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:self.categoryTitles setupNameKey:@"categoryName" imageKey:@"img" IdKey:@"categoryId" objectKey:@"type"];
        
        CZCategoryLineLayoutView *categoryView = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:CZCategoryLineLayoutViewTypeDefault2 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
            NSLog(@"%@", item.categoryName);
            self.categoryId = item.categoryId;
            self.categoryType = item.objectInfo;
            [self.collectView.mj_header beginRefreshing];
        }];
        [_headerView addSubview:categoryView];
        
        UIView *line = [[UIView alloc] init];
        line.width = SCR_WIDTH;
        line.height = 1;
        line.y = CZGetY(categoryView);
        line.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [_headerView addSubview:line];
        _headerView.height = CZGetY(line);
    }
    return _headerView;
}


#pragma mark - 数据
- (void)getTitles
{
    [self.collectView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"source"] = @(self.type); // (1京东 2淘宝 4拼多多)
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/tbk/category1"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.adList = result[@"adList"];
            self.categoryTitles = result[@"data"];
            self.categoryId = self.categoryTitles[0][@"categoryId"];
            self.categoryType = self.categoryTitles[0][@"type"];
            [self.collectView.mj_header beginRefreshing];
        }
        
    } failure:^(NSError *error) {}];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    self.page = 1;
    [self.collectView.mj_footer endRefreshing];
    NSString *url;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([self.categoryType isEqual: @(1)]) {
        param[@"source"] = @(self.type);
        param[@"page"] = @(self.page);
        url = @"api/v2/tbk/commendGoodsList";
    } else {
        param[@"category1Id"] = self.categoryId;
        param[@"source"] = @(self.type);
        param[@"page"] = @(self.page);
        url = @"api/v2/tbk/getOtherGoodsListByCategory1";
    }

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:url] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            
            // 创建头部视图
            [self.collectView reloadData];
        }
        // 结束刷新
        [self.collectView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTrailDataSorce
{
    // 结束尾部刷新
    
    self.page++;
    [self.collectView.mj_header endRefreshing];
    NSString *url;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([self.categoryType isEqual: @(1)]) {
        param[@"source"] = @(self.type);
        param[@"page"] = @(self.page);
        url = @"api/v2/tbk/commendGoodsList";
    } else {
        param[@"category1Id"] = self.categoryId;
        param[@"source"] = @(self.type);
        param[@"page"] = @(self.page);
        url = @"api/v2/tbk/getOtherGoodsListByCategory1";
    }
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:url] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = result[@"data"];
            if (list.count == 0) {
                [self.collectView.mj_footer endRefreshingWithNoMoreData];
            } else {
                NSMutableArray *dataSource = [NSMutableArray arrayWithArray:self.dataSource];
                [dataSource addObjectsFromArray:list];
                self.dataSource = dataSource;
                [self.collectView reloadData];
                // 结束刷新
                [self.collectView.mj_footer endRefreshing];
            }
        } else {
            // 结束刷新
            [self.collectView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectView.mj_footer endRefreshing];
    }];
}

#pragma mark - 事件
- (void)pushSearchVC
{
    [CZFreePushTool push_searchView];
}

@end
