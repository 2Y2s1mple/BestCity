//
//  CZTabbaoSearchDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTabbaoSearchDetailController.h"
#import "CZTaobaoSearchView.h"
#import "CZguessWhatYouLikeCell.h"
#import "CZguessLineCell.h"
#import <AdSupport/AdSupport.h>
#import "GXNetTool.h"
//#import "CZGuessWhatYouLikeView.h"asd 265

@interface CZTabbaoSearchDetailController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout>
/** <#注释#> */
@property (nonatomic, strong) CZTaobaoSearchView *searchView;
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectView;

/** <#注释#> */
@property (nonatomic, strong) NSString *asc; // (1正序，0倒序);
@property (nonatomic, strong) NSString *orderByType;  // 0综合，1价格，2补贴，3销量
@property (nonatomic, assign) NSInteger page;

/** <#注释#> */
@property (nonatomic, strong) UIButton *typeBtn1;
@property (nonatomic, strong) UIButton *typeBtn2;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;


/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *guessList;
/** <#注释#> */
@property (nonatomic, strong) UIButton *recordBtn;
/** <#注释#> */
@property (nonatomic, assign) NSInteger recoredBtnClick;


/** <#注释#> */
@property (nonatomic, assign) BOOL layoutType;


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

    [self setupSearchView];
}

- (void)setupSearchView
{
    UIView *view = [[UIView alloc] init];
    view.y = self.searchViewY;
    view.width = SCR_WIDTH;
    view.height = self.searchHeight;
    [self.view addSubview:view];


    UIButton *popBtn = [[UIButton alloc] init];
    [popBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    popBtn.x = 0;
    popBtn.size = CGSizeMake(45, self.searchHeight);
    popBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [popBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:popBtn];

    UIView *backView = [[UIView alloc] init];
    backView.x = 45;
    backView.width = SCR_WIDTH - 45 - 15;
    backView.height = self.searchHeight;
    backView.backgroundColor = UIColorFromRGB(0xD8D8D8);
    backView.layer.cornerRadius = 19;
    backView.layer.masksToBounds = YES;
    [view addSubview:backView];

    CZTextField *textF = [[CZTextField alloc] init];
    textF.text = self.searchText;
    textF.delegate = self;
    textF.width = backView.width - 76;
    textF.height = self.searchHeight;
//    [textF addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [backView addSubview:textF];

    UIButton *msgBtn = [[UIButton alloc] init];
    msgBtn.backgroundColor = UIColorFromRGB(0xE25838);
    [msgBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [msgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    msgBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 17];
    msgBtn.x = CGRectGetMaxX(textF.frame);
    msgBtn.size = CGSizeMake(76, self.searchHeight);
    msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [msgBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:msgBtn];


    for (int i = 0; i < 2; i++) {
        UIButton *btn1 = [[UIButton alloc] init];
        btn1.tag = 100 + i;
        btn1.y = CZGetY(view) + 22;

        [btn1 setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateSelected];
        [btn1 setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        btn1.width = SCR_WIDTH / 2.0;
        btn1.height = 25;
        btn1.x = i * btn1.width;
        [self.view addSubview:btn1];

        UIView *btnLine = [[UIView alloc] init];
        btnLine.tag = 100;
        btnLine.y = btn1.height + 5;
        btnLine.width = 65;
        btnLine.height = 3;
        btnLine.centerX = btn1.width / 2.0;
        btnLine.backgroundColor = UIColorFromRGB(0xE25838);
        [btn1 addSubview:btnLine];
        if (i == 1) {
            [btn1 setTitle:@"搜淘宝" forState:UIControlStateNormal];
            btnLine.hidden = YES;
            btn1.selected = NO;
            self.typeBtn2 = btn1;
            self.line2 = btnLine;
        } else {
            self.typeBtn1 = btn1;
            self.line1 = btnLine;
            [btn1 setTitle:@"搜极品城" forState:UIControlStateNormal];
            btn1.selected = YES;
        }
        [btn1 addTarget:self action:@selector(changeTabbao:) forControlEvents:UIControlEventTouchUpInside];

    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(view) + 25 + 5 + 3 + 22, SCR_WIDTH, 1)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];

    [self createTitles];
}

- (void)changeTabbao:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqual: @"搜淘宝"]) {
        self.type = @"2";
        sender.selected = YES;
        self.line2.hidden = NO;

        self.typeBtn1.selected = NO;
        self.line1.hidden = YES;
    } else {
        self.type = @"1";
        sender.selected = YES;
        self.line1.hidden = NO;
        self.typeBtn2.selected = NO;
        self.line2.hidden = YES;
    }
    [self reloadNewDataSorce];
}

- (void)createTitles
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.y = CZGetY([self.view.subviews lastObject]) + 5;
    backView.width = SCR_WIDTH;
    backView.height = 38;
    [self.view addSubview:backView];

    CGFloat leftRightSpace = 20;
    CGFloat itemWidth = 42;
    CGFloat space = (SCR_WIDTH - 2 *leftRightSpace - itemWidth * 5) / 4;

    NSArray *list = @[@"综合", @"价格", @"补贴", @"销量", @""];
    for (int i = 0; i < list.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 105 + i;
        btn.x = leftRightSpace + i * (itemWidth + space);
        [btn setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
        btn.width = itemWidth;
        btn.height = 38;
        [btn setTitle:list[i] forState:UIControlStateNormal];
        [backView addSubview:btn];
        [btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        self.orderByType = @"0"; // 0综合，1价格，2补贴，3销量
        self.asc = @"1"; // (1正序，0倒序)
        if (i == 0) {
            [btn setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
            self.recordBtn = btn;
        }

        if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"search_asc"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"search_nasc"] forState:UIControlStateSelected];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        }
        if (i == 4) {
            [btn setImage:[UIImage imageNamed:@"search_line"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"search_cols"] forState:UIControlStateSelected];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    [self createContent];
    [self setupRefresh]; // 获取数据
}

- (void)titleAction:(UIButton *)sender
{
    if (sender.tag != 106) {
        self.recoredBtnClick = 0;
    }
    //（0综合，1价格，2补贴，3销量）
    switch (sender.tag) {
        case 105:
            self.orderByType = @"0";
            break;
        case 106:
        {
            self.recoredBtnClick++;
            if (self.recoredBtnClick == 1) {
                sender.selected = NO;
                self.asc = @"1"; // (1正序，0倒序)
            } else if(self.recoredBtnClick == 2) {
                sender.selected = YES;
                self.asc = @"0"; // (1正序，0倒序)
                self.recoredBtnClick = 0;
            }
            self.orderByType = @"1";
            break;
        }
        case 107:
            self.orderByType = @"2";
            break;
        case 108:
            self.orderByType = @"3";
            break;
        case 109:
        {
            if (sender.isSelected) {
                sender.selected = NO; // 条
                self.layoutType = YES;
            } else {
                sender.selected = YES; // 块
                self.layoutType = NO;
            }
            [self reloadNewDataSorce];
            return;
        }
        default:
            break;
    }

    [self.recordBtn setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
    [sender setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
    self.recordBtn = sender;
    [self reloadNewDataSorce];
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

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CZGetY([self.view.subviews lastObject]), SCR_WIDTH, SCR_HEIGHT - (CZGetY([self.view.subviews lastObject]) + 10)) collectionViewLayout:layout];

    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectView = collectionView;

    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessWhatYouLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessWhatYouLikeCell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessLineCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessLineCell"];

    [self.collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    [self.collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"guess"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = @[self.dataSource, self.guessList];
    NSDictionary *dic = list[indexPath.section][indexPath.item];
    if (indexPath.section == 0) {
        if (self.layoutType == YES) { // 一条
            CZguessLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessLineCell" forIndexPath:indexPath];
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
    param[@"deviceType"] = idfa;
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"keyword"] = self.searchText;
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2补贴，3销量
    param[@"type"] = self.type; // 分类（1搜索极品城，2搜索淘宝）
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/searchGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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
    param[@"deviceType"] = idfa;
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"keyword"] = self.searchText;
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2补贴，3销量
    param[@"type"] = self.type; // 分类（1搜索极品城，2搜索淘宝）
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/searchGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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
    self.collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSorce)];
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



@end
