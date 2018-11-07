//
//  CZHotsaleSearchController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotsaleSearchController.h"
#import "CZHotsaleSearchDetailController.h"
#import "CZHotSearchView.h"
#import "CZHotTagsView.h"

@interface CZHotsaleSearchController ()<hotsaleSearchDetailControllerDelegate, CZHotSearchViewDelegate, CZHotTagsViewDelegate>

/** 历史搜索视图 */
@property (nonatomic, strong) CZHotTagsView *hisView;
/** 热门搜索视图 */
@property (nonatomic, strong) CZHotTagsView *hotView;
/** 删除Btn */
@property (nonatomic, strong) UIButton *btnClose;
/** 记录要删除的tag */
@property (nonatomic, assign) NSInteger recordTag;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *searchView;
@end

@implementation CZHotsaleSearchController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置搜索栏
    [self setupSearchView];
    
    self.hisView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, 100, SCR_WIDTH, 300)];
    self.hisView.type = CZHotTagLabelTypeLongPressGesture;
    self.hisView.delegate = self;
    self.hisView.title = @"历史搜索";
    [self.view addSubview:_hisView];
    
    self.hotView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, CZGetY(_hisView) + 20, SCR_WIDTH, 300)];
    self.hotView.type = CZHotTagLabelTypeTapGesture;
    self.hotView.title = @"热门搜索";
    self.hotView.delegate = self;
    self.hotView.hisArray = [NSMutableArray arrayWithArray:@[@"1电动牙刷|", @"2洗衣轮洗衣机机|", @"2洗衣轮洗衣机机|", @"1电动牙刷|", @"2洗衣轮洗衣机机|", @"2洗衣轮洗衣机机|", @"2洗衣轮洗衣机机|", @"2洗衣轮洗衣机机|", @"1电动牙刷|", @"2洗衣轮洗衣机机|", @"2洗衣轮洗衣机机|", @"2洗衣轮洗衣机机|", @"2洗衣轮洗衣机机|"]];
    [self.view addSubview:_hotView];
}

#pragma mark - 搜索框创建
- (void)setupSearchView
{
    __weak typeof(self) weakSelf = self;
    self.searchView = [[CZHotSearchView alloc] initWithFrame:CGRectMake(10, 30, SCR_WIDTH, FSS(34)) msgAction:^(NSString *rightBtnText){
        if ([rightBtnText isEqualToString:@"搜索"]) {
            [weakSelf pushSearchDetail];
            // 添加到历史搜索
            [weakSelf.hisView createTagLabelWithTitle:weakSelf.searchView.searchText withEventType:CZHotTagLabelTypeDefault];
            // 更新热门的尺寸
            weakSelf.hotView.frame = CGRectMake(0, CZGetY(weakSelf.hisView) + 20, SCR_WIDTH, 300);
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.searchView.textFieldBorderColor = CZGlobalGray;
    self.searchView.textFieldActive = YES;
    self.searchView.msgTitle = @"取消";
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
}

#pragma mark - 监听文本框的编辑<CZHotSearchViewDelegate>
- (void)hotView:(CZHotSearchView *)hotView didTextFieldChange:(CZTextField *)textField
{
    if (textField.text.length == 0) {
        hotView.msgTitle = @"取消";
    } else {
        hotView.msgTitle = @"搜索";
    }
}

#pragma mark - 跳转
- (void)pushSearchDetail
{
    CZHotsaleSearchDetailController *vc = [[CZHotsaleSearchDetailController alloc] init];
    vc.textTitle = self.searchView.searchText;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear
{
    if (clear) {
        //详情页面点击了清除
        self.searchView.searchText = nil;
    } else {
        
    }
}

#pragma mark - 创建历史搜索
- (void)createHistorySearchModule
{
    self.hisView = [[CZHotTagsView alloc] initWithFrame:CGRectMake(0, 100, SCR_WIDTH, 300)];
    self.hisView.type = CZHotTagLabelTypeLongPressGesture;
    self.hisView.delegate = self;
    self.hisView.title = @"历史搜索";
    [self.view addSubview:_hisView];
}

#pragma mark - <CZHotTagsViewDelegate>
// 点击事件
- (void)hotTagsView:(CZHotTagsView *)tagsView didSelectedTag:(CZHotTagLabel *)tagLabel
{
    self.searchView.searchText = tagLabel.text;
    [self pushSearchDetail];
}

// 长按事件
- (void)hotTagsViewLongPressAccessoryEvent
{
    // 更新热门的尺寸
    self.hotView.frame = CGRectMake(0, CZGetY(self.hisView) + 20, SCR_WIDTH, 300);
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
