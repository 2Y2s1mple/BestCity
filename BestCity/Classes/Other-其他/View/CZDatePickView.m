//
//  CZDatePickView.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/8.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDatePickView.h"
#import "Masonry.h"

@interface CZDatePickView ()<UIPickerViewDelegate, UIPickerViewDataSource>
/** 时间选择器 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 工具条 */
@property (nonatomic, strong) UIView *toolBar;
/** 选择的时间 */
@property (nonatomic, strong) NSString *dateStr;
/** 当前的日期 */
@property (nonatomic, strong) NSString *userDate;
/** 性别选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation CZDatePickView

- (void)setupSubViewsAddView:(CZDatePickView *)view selectStr:(NSString *)string
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    [view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
        make.height.equalTo(@(SCR_HEIGHT - 290));
    }];
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = [UIColor colorWithRed:1.00 green:0.62 blue:0.17 alpha:1.00];
    toolBar.transform = CGAffineTransformMakeTranslation(0, 300);
    [view addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(view);
        make.height.equalTo(@35);
    }];
    _toolBar = toolBar;
    
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setBackgroundImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
    [cancle addTarget:view action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancle];
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolBar);
        make.left.equalTo(toolBar).offset(20);
    }];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [confirm addTarget:view action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolBar);
        make.right.equalTo(toolBar).offset(-20);
    }];
    
    if (view.type == CZDatePickViewTypeDate) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        //设置pickDate显示的如期
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        if (string.length > 0) {
            [datePicker setDate:[dateFormat dateFromString:string]];
        }
        datePicker.backgroundColor = CZGlobalLightGray;
        _datePicker = datePicker;
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:view action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:datePicker];
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(toolBar.mas_bottom).offset(0);
            make.left.right.bottom.equalTo(view);
        }];
        _datePicker.transform = CGAffineTransformMakeTranslation(0, 300);
        [self datePickerAction:_datePicker];
    } else {
        view.pickerView = [[UIPickerView alloc] init];
        view.pickerView.backgroundColor = CZGlobalLightGray;
        view.pickerView.delegate = view;
        view.pickerView.dataSource = view;
        [view.pickerView selectRow:[string isEqualToString:@"男"] ? 1 : 0 inComponent:0 animated:NO];
        [view addSubview:view.pickerView];
        [view.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(toolBar.mas_bottom).offset(0);
            make.left.right.bottom.equalTo(view);
        }];
        view.pickerView.transform = CGAffineTransformMakeTranslation(0, 300);
        [self pickerView:view.pickerView didSelectRow:0 inComponent:0];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        view.datePicker.transform = CGAffineTransformMakeTranslation(0, 0);
        view.pickerView.transform = CGAffineTransformMakeTranslation(0, 0);
        toolBar.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

+ (instancetype)datePickWithCurrentDate:(NSString *)dateString type:(CZDatePickViewType)type
{
    CZDatePickView *backView = [[self alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
    backView.type = type;
    [backView setupSubViewsAddView:backView selectStr:dateString];
    
    return backView;
}

- (void)datePickerAction:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    _dateStr = [dateFormat stringFromDate:date];
    NSLog(@"%@", _dateStr);
}

- (void)cancle
{
    [self dismiss];
}

- (void)confirm
{
    [self.delegate datePickView:self selectedDate:_dateStr];
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.transform = CGAffineTransformMakeTranslation(0, 300);
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, 300);
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, 300);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - <UIPickerViewDataSource>
////返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

#pragma mark - <UIPickerViewDelegate>
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [@[@"女", @"男"] objectAtIndex:row];
    return str;
}

//选中行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.dateStr = [@[@"女", @"男"] objectAtIndex:row];
    NSLog(@"pickerViewSelect -- %@", _dateStr);
}

@end
