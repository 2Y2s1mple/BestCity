//
//  CZAllCriticalController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAllCriticalController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "CZCommentDetailCell.h"
#import "CZSubOneCommentCell.h" // 纯代码
#import "CZPackUpCommentCell.h" // 按钮

#import "CZEvaluateToolBar.h"

@interface CZAllCriticalController ()<UITableViewDelegate, UITableViewDataSource>
/** 导航条 */
@property (nonatomic, strong) CZNavigationView *nav;
/** 深色线条 */
@property (nonatomic, strong) UIView *line;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 存储cell高度 */
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic;
/** 文本框 */
@property (nonatomic, strong) CZEvaluateToolBar *textViewTool;

/** 保存评论 */
@property (nonatomic, strong) NSString *commentId;

@end

@implementation CZAllCriticalController

#pragma mark - 懒加载
- (NSMutableArray *)evaluateArr
{
    if (_evaluateArr == nil) {
        _evaluateArr = [NSMutableArray array];
    }
    return _evaluateArr;
}

- (NSMutableDictionary *)cellHeightDic
{
    if (_cellHeightDic == nil) {
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    return _cellHeightDic;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, SCR_HEIGHT - 68 - 49) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tableView.backgroundColor = CZGlobalWhiteBg;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (CZNavigationView *)nav
{
    if (_nav == nil) {
        self.view.backgroundColor = CZGlobalWhiteBg;
        NSString *title = [NSString stringWithFormat:@"所有评论(%@)", self.totalCommentCount];
        self.nav = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:title rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    }
    return _nav;
}

- (UIView *)line
{
    if (_line == nil) {
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 67, SCR_WIDTH, 1)];
        self.line.backgroundColor = CZGlobalLightGray;
    }
    return _line;
}

- (CZEvaluateToolBar *)textViewTool
{
    if(_textViewTool == nil) {
        
        __weak typeof(self) weakSelf = self;
        self.textViewTool = [CZEvaluateToolBar evaluateToolBar];
        self.textViewTool.y = CZGetY(self.tableView);
        self.textViewTool.width = SCR_WIDTH;
        self.textViewTool.block = ^{
            [weakSelf.view endEditing:YES];
            if (weakSelf.textViewTool.textView.text.length > 0) {
                [weakSelf commentInsert:weakSelf.commentId];
                weakSelf.commentId = nil;
            }
        };
    }
    return _textViewTool;
}


// 获取评价数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articId"] = self.goodsId;
    param[@"page"] = @(0);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/comment"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result[@"list"] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSMutableArray *mutArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", mutArr);
    
        // 获取数据
        NSMutableArray *dataSource = mutArr;
        
        // 新数组
        NSMutableArray *newContentArr = [NSMutableArray array];
        
        for (int i = 0; i < dataSource.count; i++) {
            // 第一条数据
            NSMutableDictionary *contentDic = dataSource[i];
            contentDic[@"type"] = @"1"; // 用来判断cell的类型
            
            // 取第一条的数据评论数组
            NSMutableArray *commentArr = contentDic[@"userCommentList"];
            if (commentArr.count != 0) {
                if (commentArr.count > 2) {
                    // 取数组的第一条数据, 为了加个尖
                    NSMutableDictionary *commentArrDic = [commentArr firstObject];
                    commentArrDic[@"isArrow"] = @"1";
                    
                    // 重新建一个数组
                    [newContentArr addObject:contentDic]; // 加入第一条数据
                    [newContentArr addObject:commentArr[0]]; // 加两条
                    [newContentArr addObject:commentArr[1]];
                    
                    // 在评论数组里面添加一个, 为了收起按钮
                    NSMutableDictionary *packupDic = [NSMutableDictionary dictionary];
                    packupDic[@"type"] = @"2"; // 类型
                    packupDic[@"commentArr"] = commentArr; // 评论的数组
                    packupDic[@"showCount"] = @(2); // 外面显示几条
                    packupDic[@"packUpStatus"] = @"0";
                    
                    [newContentArr addObject:packupDic];
                } else if (commentArr.count <= 2) {
                    // 取数组的第一条数据, 为了加个尖
                    NSMutableDictionary *commentArrDic = [commentArr firstObject];
                    commentArrDic[@"isArrow"] = @"1";
                    
                    // 重新建一个数组
                    [newContentArr addObject:contentDic]; // 加入第一条数据
                    for (NSMutableDictionary *dic in commentArr) {
                        [newContentArr addObject:dic];
                    }
                }
            } else {
                [newContentArr addObject:contentDic];
            }
        }

        self.evaluateArr = newContentArr;

        // 创建用户评价
        [self.tableView reloadData];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
        }
    failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取数据
    [self getDataSource];
    // 导航条
    [self.view addSubview:self.nav];
    
    // 灰色线
    [self.view addSubview:self.line];
   
    // 创建表单
    [self.view addSubview:self.tableView];
    
    // 创建刷新控件
    [self setupRefresh];
    
    // 创建文本框
    [self.view addSubview:self.textViewTool];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.textViewTool.transform = CGAffineTransformMakeTranslation(0, rect.origin.y - SCR_HEIGHT);
}

//- (void)keyboardHide:(NSNotification *)notification
//{
//    self.textViewTool.transform = CGAffineTransformMakeTranslation(0, 0);
//}

- (void)setupRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata)];
}

#pragma mark - 评论接口
- (void)commentInsert:(NSString *)parentId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.goodsId) {
        param[@"articId"] = self.goodsId;
        param[@"status"] = @"1"; // 1商品 2评测 3发现
    }
    param[@"content"] = self.textViewTool.textView.text;
    if (parentId) {
        param[@"parentId"] = parentId; // 回复文章
    } else {
        param[@"parentId"] = @(0); // 回复文章
    }
    //获取详情数据
    [GXNetTool PostNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/commentInsert"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"添加成功"]) {
            NSLog(@"%@", result);
            [CZProgressHUD showProgressHUDWithText:@"评论成功"];
            // 获取数据
            [self getDataSource];
            
        } else {
            [CZProgressHUD showProgressHUDWithText:@"评论失败"];
        }
        [CZProgressHUD hideAfterDelay:1];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 更多数据
- (void)loadMoredata
{
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articId"] = self.goodsId;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/comment"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result[@"list"] options:NSJSONWritingPrettyPrinted error:&error];
            
            NSMutableArray *mutArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            NSLog(@"%@", mutArr);
            
            // 获取数据
            NSMutableArray *dataSource = mutArr;
            
            NSMutableArray *newContentArr = [NSMutableArray array];
            
            for (int i = 0; i < dataSource.count; i++) {
                // 第一条数据
                NSMutableDictionary *contentDic = dataSource[i];
                contentDic[@"type"] = @"1"; // 用来判断cell的类型
                
                // 取第一条的数据评论数组
                NSMutableArray *commentArr = contentDic[@"userCommentList"];
                if (commentArr.count != 0) {
                    if (commentArr.count > 2) {
                        // 取数组的第一条数据, 为了加个尖
                        NSMutableDictionary *commentArrDic = [commentArr firstObject];
                        commentArrDic[@"isArrow"] = @"1";
                        
                        // 重新建一个数组
                        [newContentArr addObject:contentDic]; // 加入第一条数据
                        [newContentArr addObject:commentArr[0]]; // 加两条
                        [newContentArr addObject:commentArr[1]];
                        
                        // 在评论数组里面添加一个收起按钮
                        NSMutableDictionary *packupDic = [NSMutableDictionary dictionary];
                        packupDic[@"type"] = @"2"; // 类型
                        packupDic[@"commentArr"] = commentArr; // 评论的数组
                        packupDic[@"showCount"] = @(2); // 外面显示几条
                        packupDic[@"packUpStatus"] = @"0";
                        
                        [newContentArr addObject:packupDic];
                    } else if (commentArr.count <= 2) {
                        // 取数组的第一条数据, 为了加个尖
                        NSMutableDictionary *commentArrDic = [commentArr firstObject];
                        commentArrDic[@"isArrow"] = @"1";
                        
                        // 重新建一个数组
                        [newContentArr addObject:contentDic]; // 加入第一条数据
                        for (NSMutableDictionary *dic in commentArr) {
                            [newContentArr addObject:dic];
                        }
                    }
                } else {
                    [newContentArr addObject:contentDic];
                }
            }
            
            [self.evaluateArr addObjectsFromArray:newContentArr];

            // 创建用户评价
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.evaluateArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = self.evaluateArr[indexPath.row];
    if ([dataDic[@"type"] isEqualToString:@"1"]) { // 评论上部分
        CZCommentDetailCell *cell = [CZCommentDetailCell cellWithTableView:tableView];
        cell.block = ^(NSString *commentId){
            NSLog(@"%@", commentId);
            // 保存评论的ID
            self.commentId = commentId;
            [self.textViewTool.textView becomeFirstResponder];
        };
        cell.contentDic = self.evaluateArr[indexPath.row];
        
        self.cellHeightDic[@(indexPath.row)] = [NSString stringWithFormat:@"%f", cell.cellHeight];
        return cell;
    } else if ([dataDic[@"type"] isEqualToString:@"2"]) { //评论的内容
        CZPackUpCommentCell *cell = [CZPackUpCommentCell cellWithTableView:tableView];
        cell.contentDic = self.evaluateArr[indexPath.row];
        self.cellHeightDic[@(indexPath.row)] = [NSString stringWithFormat:@"%f", cell.cellHeight];
        return cell;
    } else { // 下面的按钮
        CZSubOneCommentCell *cell = [CZSubOneCommentCell cellWithTableView:tableView];
        cell.contentDic = self.evaluateArr[indexPath.row];
        self.cellHeightDic[@(indexPath.row)] = [NSString stringWithFormat:@"%f", cell.cellHeight];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *height = [NSString stringWithFormat:@"%@", self.cellHeightDic[@(indexPath.row)]];
    return [height floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDic = self.evaluateArr[indexPath.row];
    if ([dataDic[@"type"]  isEqual: @"2"]) {
        NSMutableArray *insetArr = dataDic[@"commentArr"];
        if ([dataDic[@"packUpStatus"]  isEqual: @"2"]) { // 收起
            NSInteger index = [dataDic[@"commentArr"] count] - 2;
            [self.evaluateArr removeObjectsInRange:NSMakeRange(indexPath.row - index, index)];
            dataDic[@"packUpStatus"] =  @"0";
            dataDic[@"showCount"] = @(2);
            [self.tableView reloadData];
            
        } else {
            // 添加
            // 第一次8条, 或者全部
            if ([dataDic[@"showCount"]  isEqual: @(2)]) { // 如果是第一次
                NSInteger commentCount = insetArr.count;
                if (commentCount >= 10) {
                    commentCount = 8;
                } else {
                    commentCount -= 2;
                }
                for (int i = 0; i < commentCount; i++) {
                    [self.evaluateArr insertObject:insetArr[i + 2] atIndex:indexPath.row + i];
                }
                // 外边显示了多少条
                dataDic[@"showCount"] =  @(commentCount + 2);
                
            } else {
                // 第二次...
                if ((dataDic[@"packUpStatus"] =  @"1")) { //如果还是更多
                    // 外边显示了多少条
                    NSInteger showCount = [dataDic[@"showCount"] integerValue];
                    
                    // 还能显示多少条
                    NSInteger canShowConut = [dataDic[@"canShowConut"] integerValue];
                    for (int i = 0; i < canShowConut; i++) {
                        [self.evaluateArr insertObject:insetArr[i + showCount] atIndex:indexPath.row + i];
                    }
                    // 外边显示了多少条
                    dataDic[@"showCount"] = @(showCount + canShowConut);
                }
            }
            dataDic[@"packUpStatus"] =  @"1"; // 显示更多按钮
            [self.tableView reloadData];
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
