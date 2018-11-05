//
//  CZHotsaleSearchController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotsaleSearchController.h"
#import "UIButton+CZExtension.h"
#import "CZTextField.h"
#import "CZHotsaleSearchDetailController.h"

@interface CZHotsaleSearchController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, hotsaleSearchDetailControllerDelegate>

/** 历史搜索视图 */
@property (nonatomic, strong)  UIView *hisView;
/** 热门搜索视图 */
@property (nonatomic, strong) UIView *hotView;
/** 搜索栏 */
@property (nonatomic, strong) CZTextField *textField;
/** 删除Btn */
@property (nonatomic, strong) UIButton *btnClose;
/** 历史搜索 */
@property (nonatomic, strong) NSMutableArray *hisArray;
/** 记录要删除的tag */
@property (nonatomic, assign) NSInteger recordTag;
/** 搜索的tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 当输入文字时的数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CZHotsaleSearchController
/** 搜索的数据 */
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/** 历史搜索的数据 */
- (NSMutableArray *)hisArray
{
    if (_hisArray == nil) {
        _hisArray = [NSMutableArray arrayWithArray:@[@"1电动牙刷|", @"2洗衣轮洗衣机机|", @"3波轮", @"4电", @"5洗衣机|", @"6波轮洗衣机衣机|", @"1电动牙刷|", @"2洗衣机|", @"3波机|", @"4电动衣机牙刷|", @"5洗衣机|", @"6波轮洗衣机衣机|"]];
    }
    return _hisArray;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FSS(34) + 40, SCR_WIDTH, SCR_HEIGHT - 49 - FSS(34) + 40) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置搜索栏
    [self setupTopViewWithFrame:CGRectMake(0, 30, SCR_WIDTH, FSS(34))];
    
    self.hisView = [self createRecordViewWithFrame:CGRectMake(0, 100, SCR_WIDTH, 300) title:@"历史搜索"];
    [self.view addSubview:_hisView];
    
    self.hotView = [self createRecordViewWithFrame:CGRectMake(0, CZGetY(_hisView) + 20, SCR_WIDTH, 300) title:@"热门搜索"];
    [self.view addSubview:_hotView];
}

- (void)setupTopViewWithFrame:(CGRect)frame
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:topView];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(topView.width - 40 - 14, 7, FSS(40), FSS(21));
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    cancelBtn.center = CGPointMake(cancelBtn.center.x, topView.height / 2);
    
    self.textField = [[CZTextField alloc] initWithFrame:CGRectMake(14, 0, CGRectGetMinX(cancelBtn.frame) - 24, topView.height)];
    self.textField.delegate = self;
    //代理方法监听时候都会慢一步
    [self.textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [topView addSubview:self.textField];
}

//监听文本框的编辑
- (void)textFieldAction:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self.tableView removeFromSuperview];
    } else {
        [self.view addSubview:self.tableView];
    }
    
}

- (UIView *)createRecordViewWithFrame:(CGRect)frame title:(NSString *)title
{
    UIView *hisView = [[UIView alloc] initWithFrame:frame];
    UILabel *hisLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, FSS(20))];
    hisLabel.text = title;
    hisLabel.font = [UIFont systemFontOfSize:15];
    [hisView addSubview:hisLabel];
    

    CGFloat recordWidth = 0;//计算超越的
    CGFloat currentWidth = 10;//当前的宽度
    NSInteger recordRow = 0;//记录行
    CGFloat space = 10.0;
    
    NSInteger index = 0;
    for (NSString *str in self.hisArray) {
        index++;
        CGSize size = [str boundingRectWithSize:CGSizeMake(1000, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
        
        recordWidth = recordWidth + space + (size.width + 15);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = self.hisArray[index - 1];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 15;
        label.layer.masksToBounds = YES;
        label.backgroundColor = CZGlobalLightGray;
        label.tag = index + 100;
        label.userInteractionEnabled = YES;
        [hisView addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [label addGestureRecognizer:tap];
        
        if ([title isEqualToString:@"历史搜索"]) {
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
            [label addGestureRecognizer:longPress];
        }
        
        if (recordWidth > SCR_WIDTH - space) {
//            NSLog(@"到第%ld个字符串超越了", index);
            recordRow++;
            currentWidth = space;
            recordWidth = space + (size.width + 15);//
        }
        
        label.frame = CGRectMake(currentWidth, 40 + (40 * recordRow), size.width + 15 , 30);
        currentWidth = currentWidth + space + size.width + 15;
    }
    UILabel *lab= (UILabel *)[[hisView subviews] lastObject];
    hisView.height = CZGetY(lab);
    return hisView;
}

#pragma mark - 长按手势
- (void)longAction:(UILongPressGestureRecognizer *)longPressGest
{
    UILabel *label = (UILabel *)longPressGest.view;
    if (longPressGest.state == UIGestureRecognizerStateBegan) {
        [self.btnClose removeFromSuperview];
        //创建一个删除按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"search-close"] forState:UIControlStateNormal];
        self.recordTag = label.tag;
        self.btnClose = btn;
        [btn addTarget:self action:@selector(btnCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        [[label superview] addSubview:btn];
        btn.frame = CGRectMake(CZGetX(label) - 10, CGRectGetMinY(label.frame) - 5, 15, 15);
    } else {

    }
}

#pragma mark - 轻拍手势
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    self.textField.text = label.text;
    CZHotsaleSearchDetailController *vc = [[CZHotsaleSearchDetailController alloc] init];
    vc.textTitle = self.textField.text;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear
{
    if (clear) {
        //详情页面点击了清除
        self.textField.text = nil;
        [self.tableView removeFromSuperview];
    } else {
        //详情页面点击了编辑
        [self.view addSubview:self.tableView];
    }
}


- (void)btnCloseAction:(UIButton *)sender
{
    [self.hisArray removeObjectAtIndex:(self.recordTag - 101)];
    for (UIView *view in [[sender superview] subviews]) {
        [view removeFromSuperview];
    }
    UIView *hisView = [self createRecordViewWithFrame:CGRectMake(0, 100, SCR_WIDTH, 300) title:@"历史搜索"];
    [self.view addSubview:hisView];
}

- (void)cancleAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HotsaleSearchDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"电视机";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZHotsaleSearchDetailController *vc = [[CZHotsaleSearchDetailController alloc] init];
    vc.textTitle = self.textField.text;
    vc.delegate = self;
    [self.view endEditing:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
