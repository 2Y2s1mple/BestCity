//
//  CZTabbaoSearchDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTabbaoSearchDetailController.h"
#import "CZTitlesViewTypeLayout.h"


#import "CZguessWhatYouLikeCell.h"
#import "CZCollectionTypeOneCell.h"
#import <AdSupport/AdSupport.h>
#import "GXNetTool.h"
#import "KCUtilMd5.h"

#import "CZTaobaoDetailController.h"

@interface CZTabbaoSearchDetailController () <UICollectionViewDelegate, UICollectionViewDataSource>

/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectView;

/** <#注释#> */
@property (nonatomic, strong) NSString *asc; // (1正序，0倒序);
@property (nonatomic, strong) NSString *orderByType;  // 0综合，1价格，2返现，3销量
@property (nonatomic, assign) NSInteger page;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *guessList;

/** <#注释#> */
@property (nonatomic, assign) BOOL layoutType;

/** 记录当前的参数, 防止多次点击 */
@property (nonatomic, strong) NSDictionary *recordParam;


@end

@implementation CZTabbaoSearchDetailController
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)guessList
{
    if (_guessList == nil) {
        _guessList = [NSMutableArray array];
    }
    return _guessList;
}

// 搜索框Y值
- (CGFloat)searchViewY
{
    return (IsiPhoneX ? 54 : 30);
}

// 搜索框H值
- (CGFloat)searchHeight
{
    return 38;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);

    [self createTitles];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectView.height = self.view.height - 48;
}

- (void)createTitles
{
    self.orderByType = @"0"; // 0综合，1价格，2返现，3销量
    self.asc = @"1"; // (1正序，0倒序)
    self.layoutType = YES;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xD8D8D8);
    line.y = 0;
    line.width = SCR_WIDTH;
    line.height = 1;
    [self.view addSubview:line];
    
    CZTitlesViewTypeLayout *view = [[CZTitlesViewTypeLayout alloc] init];
    view.y = 1;
    view.width = SCR_WIDTH;
    view.height = 38;
    [view setBlcok:^(BOOL isLine, BOOL isAsc, NSInteger index) {
        // orderByType : 0综合，1价格，2返现，3销量
        self.orderByType =  [NSString stringWithFormat:@"%ld", (long)index];
        self.asc = [NSString stringWithFormat:@"%d", isAsc];
        self.layoutType = isLine;
        [self reloadNewDataSorce];
        
    }];
    [self.view addSubview:view];
    
    [self createContent];
    [self setupRefresh]; // 获取数据
}

- (void)createContent
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xF5F5F5);
    line.y = CZGetY([self.view.subviews lastObject]);
    line.height = 10;
    line.width = SCR_WIDTH;
    [self.view addSubview:line];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layoutType = YES;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CZGetY(line), SCR_WIDTH, self.view.height - (CZGetY(line))) collectionViewLayout:layout];

    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectView = collectionView;

    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessWhatYouLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessWhatYouLikeCell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZCollectionTypeOneCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZCollectionTypeOneCell"];

    [self.collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    [self.collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"guess"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = @[self.dataSource, self.guessList];
    NSDictionary *dic = list[indexPath.section][indexPath.item];
    if (indexPath.section == 0) {
        if (self.layoutType == YES) { // 一条
            CZCollectionTypeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZCollectionTypeOneCell" forIndexPath:indexPath];
            cell.dataDic = dic;
            return cell;
        } else { // 块
            CZguessWhatYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessWhatYouLikeCell" forIndexPath:indexPath];
            cell.dataDic = dic;
            return cell;
        }

    } else {
        CZguessWhatYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessWhatYouLikeCell" forIndexPath:indexPath];
        cell.dataDic = dic;
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *list = @[self.dataSource, self.guessList];
    return [list[section] count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

#pragma  mark - 获取数据
- (void)reloadNewDataSorce
{
    // 结束尾部刷新
    [self.collectView.mj_footer endRefreshing];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    param[@"deviceType"] = @"IDFA";
    param[@"deviceValue"] = [KCUtilMd5 stringToMD5:idfa];
    param[@"deviceEncrypt"] = @"MD5";
    param[@"keyword"] = self.searchText;
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2返现，3销量
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"source"] = self.type; // 分类（(1京东,2淘宝，4拼多多)
    param[@"page"] = @(self.page);

    self.recordParam = param;

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/searchGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (self.recordParam != param) return;
        if ([result[@"msg"] isEqualToString:@"success"]) {

            self.dataSource = [NSMutableArray array];
            self.guessList = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"]) {
                if ([dic[@"goodsType"]  isEqual: @(3)]) {
                    [self.guessList addObject:dic];
                } else {
                    [self.dataSource addObject:dic];
                }
            }

            self.collectView.contentOffset = CGPointMake(0, 0);
            [self.collectView reloadData];
        }
        // 结束刷新
        [self.collectView.mj_header endRefreshing];

    } failure:^(NSError *error) {// 结束刷新
        [self.collectView.mj_header endRefreshing];

    }];
}

- (void)loadMoreDataSorce
{
    // 结束尾部刷新
    [self.collectView.mj_header endRefreshing];
    self.page++;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    param[@"deviceType"] = @"IDFA";
    param[@"deviceValue"] = [KCUtilMd5 stringToMD5:idfa];
    param[@"deviceEncrypt"] = @"MD5";
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"keyword"] = self.searchText;
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2返现，3销量
    param[@"source"] = self.type; // 分类（(1京东,2淘宝，4拼多多)
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/tbk/searchGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {

            for (NSDictionary *dic in result[@"data"]) {
                if ([dic[@"goodsType"]  isEqual: @(3)]) {
                    [self.guessList addObject:dic];
                } else {
                    [self.dataSource addObject:dic];
                }
            }
            [self.collectView reloadData];
        }
        // 结束刷新
        [self.collectView.mj_footer endRefreshing];

    } failure:^(NSError *error) {// 结束刷新
        [self.collectView.mj_footer endRefreshing];

    }];
}

- (void)cancleAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.currentDelegate HotsaleSearchDetailController:self isClear:NO];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

- (void)setupRefresh
{
    self.collectView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDataSorce)];
    [self.collectView.mj_header beginRefreshing];
    self.collectView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSorce)];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];

        UIImageView *imageView = [header viewWithTag:101];
        if (imageView == nil) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_no_data"]];
            imageView.tag = 101;
            [header addSubview:imageView];
            imageView.centerX = SCR_WIDTH / 2.0;
            imageView.centerY = 90;
        }
        header.backgroundColor = UIColorFromRGB(0xF5F5F5);
        return header;
    } else {
        UICollectionReusableView *guess = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"guess"forIndexPath:indexPath];


        UIView *view = [guess viewWithTag:100];
        if (view == nil) {
            view = [[UIView alloc] init];
            view.tag = 100;
            view.width = SCR_WIDTH;
            view.height = 10;
            view.backgroundColor = UIColorFromRGB(0xF5F5F5);
            [guess addSubview:view];
        }


        UIImageView *image = [guess viewWithTag:101];
        if (image == nil) {
            image = [[UIImageView alloc] init];
            image.tag = 101;
            image.image = [UIImage imageNamed:@"taobaoDetai_guess"];
            [image sizeToFit];
            image.centerX = SCR_WIDTH / 2.0;
            image.y = 24;
            [guess addSubview:image];
        }

        if (self.layoutType == YES) { // 一条
            view.hidden = YES;
            image.y = 14;
        } else { // 块
            view.hidden = NO;
            image.y = 24;
        }
        guess.backgroundColor = [UIColor whiteColor];
        return guess;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dataSource.count == 0) {
           return CGSizeMake(0, 180);
        } else {
           return CGSizeMake(0, 0);
        }
    } else {
        if (self.guessList.count == 0) {
           return CGSizeMake(0, 0);
        } else {
            if (self.layoutType == YES) { // 一条
                return CGSizeMake(0, 40);
            } else { // 块
                return CGSizeMake(0, 50);
            }
        }
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        if (self.layoutType == YES) { // 一条
            return UIEdgeInsetsMake(0, 0, 0, 0);
        } else { // 块
            if (self.dataSource.count == 0) {
                return UIEdgeInsetsMake(0, 0, 0, 0);
            } else {
                return UIEdgeInsetsMake(10, 15, 10, 15);
            }
        }
    } else {
       return UIEdgeInsetsMake(10, 15, 10, 15);
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.layoutType == YES) { // 一条
            return CGSizeMake(SCR_WIDTH, 150);
        } else { // 块
            return CGSizeMake((SCR_WIDTH - 40) / 2.0, 312);
        }
    } else {
       return CGSizeMake((SCR_WIDTH - 40) / 2.0, 312);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = @[self.dataSource, self.guessList];
    NSDictionary *param = list[indexPath.section][indexPath.item];
    [CZFreePushTool push_tabbaokeDetailWithId:param[@"otherGoodsId"] title:@"" source:[NSString stringWithFormat:@"%@", param[@"source"]]];
}


@end
