//
//  CZAllCriticalController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAllCriticalController.h"

// 工具
#import "GXNetTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

// 视图
#import "CZCommentDetailCell.h"
#import "CZSubOneCommentCell.h" // 纯代码
#import "CZPackUpCommentCell.h" // 按钮
#import "CZNavigationViewFactory.h"
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
/** 保存回复谁 */
@property (nonatomic, strong) NSString *commentName;
/** 当前cell的下标 */
@property (nonatomic, assign) NSInteger currentCellIndex;
/** 原始数据 */
@property (nonatomic, strong) NSMutableArray *originalData;

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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 68 - 49) style:UITableViewStylePlain];
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
       self.nav = [CZNavigationViewFactory navigationViewWithTitle:title rightBtn:nil rightBtnAction:nil delegate:nil];
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
        self.textViewTool.height = 49;
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

#pragma mark - 评论接口
- (void)commentInsert:(NSString *)parentId
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.goodsId) {
        param[@"targetId"] = self.goodsId;
        param[@"type"] = self.type; // 1商品 2评测 3发现
    }
    param[@"content"] = self.textViewTool.textView.text;
    if (parentId) {
        param[@"parentId"] = parentId; // 回复文章
    } else {
        param[@"parentId"] = @(0); // 回复文章
    }
    param[@"toUserId"] = @(0);
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/comment/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if (![param[@"parentId"]  isEqual: @(0)]) {
                // 获取子评论
                NSMutableArray *subComment = self.originalData[self.currentCellIndex][@"children"];
                NSMutableDictionary *comment = [NSMutableDictionary dictionary];
                comment[@"content"] = self.textViewTool.textView.text; 
                comment[@"userNickname"] = JPUSERINFO[@"nickname"]; 
                [subComment addObject:comment];
                // 处理数据
                self.evaluateArr = [self processingDataArray:self.originalData];
                [self.tableView reloadData];
            } else {
                [self getDataSource];
            }
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            self.textViewTool.textView.text = nil;
            self.textViewTool.placeholderLabel.hidden = NO;
        } else {
            [CZProgressHUD showProgressHUDWithText:@"评论失败"];
        }
        [CZProgressHUD hideAfterDelay:1.5];
        
        
    } failure:^(NSError *error) {}];
}

// 获取评价数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.goodsId;
    param[@"type"] = self.type;
    param[@"page"] = @(1);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/comment/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
         if ([result[@"msg"] isEqualToString:@"success"]) {
             // 子数组转化为可变数组
             NSError *error = nil;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result[@"data"] options:NSJSONWritingPrettyPrinted error:&error];
             self.originalData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
             // 处理数据
             self.evaluateArr = [self processingDataArray:self.originalData];
             // 刷新列表
             [self.tableView reloadData];
        }
        [CZProgressHUD hideAfterDelay:0];
     }
    failure:^(NSError *error) {}];
}

#pragma mark - 更多数据
- (void)loadMoredata
{
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"targetId"] = self.goodsId;
    param[@"type"] = self.type;
    param[@"page"] = @(self.page);
    
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/comment/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 子数组转化为可变数组
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result[@"data"] options:NSJSONWritingPrettyPrinted error:&error];
            
            NSMutableArray *mutArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            [self.originalData addObjectsFromArray:mutArr];
            
            // 添加到数组
            [self.evaluateArr addObjectsFromArray:[self processingDataArray:mutArr]];
            // 刷新
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - 处理数据
- (NSMutableArray *)processingDataArray:(NSMutableArray *)mutArr
{
    // 重新组装后的数组
    NSMutableArray *newContentArr = [NSMutableArray array];
    for (int i = 0; i < mutArr.count; i++) {
        // 将每一条第一个item的拿出来
        // 添加标识type, 1代表cell为主评论
        // 添加到新数组中
        NSMutableDictionary *itemDic = mutArr[i];
        itemDic[@"jpType"] = @"1";
        itemDic[@"index"] = @(i);
        [newContentArr addObject:itemDic];
        
        
        // 将item的子评论添加到新数组变为同一级数组
        NSMutableArray *itemDicCommentArr = itemDic[@"children"];
        if (itemDicCommentArr.count > 0) {
            // ? 怎么添加
            itemDicCommentArr = [self processingCommentData:itemDicCommentArr];
            [newContentArr addObjectsFromArray:itemDicCommentArr];
        }
    }
    
    return newContentArr;
}

#pragma mark - 处理子评论数据
- (NSMutableArray *)processingCommentData:(NSMutableArray *)subCommentData
{
    /**
     * 1. 数组中第一个, 加标识isArrow, 1代表有带尖号的图片
     * 2. 大于两条的, 小于等于两条
     */
    
    // 数组中第一条数据
    NSMutableDictionary *commentDic = [subCommentData firstObject];
    commentDic[@"isArrow"] = @"1";
    
    // 重建子评论数组
    NSMutableArray *newSubCommentArr = [NSMutableArray array];
    if (subCommentData.count > 2) { // 大于两条
        [newSubCommentArr addObject:commentDic];
        [newSubCommentArr addObject:subCommentData[1]];
        [newSubCommentArr addObject:[self createPackupDataWithSubComment:subCommentData]]; // 收起按钮
    } else {
        for (NSMutableDictionary *dic in subCommentData) {
            [newSubCommentArr addObject:dic];
        }
    }
    return newSubCommentArr;
}

#pragma mark - 创建收起按钮数据
- (NSMutableDictionary *)createPackupDataWithSubComment:(NSMutableArray *)commentArr
{
    // 在评论数组里面添加一个, 为了收起按钮
    NSMutableDictionary *packupDic = [NSMutableDictionary dictionary];
    packupDic[@"jpType"] = @"2"; // cell类型
    packupDic[@"commentArr"] = commentArr; // 评论的数组
    packupDic[@"showCount"] = @(2); // 默认外面显示两条
    packupDic[@"packUpStatus"] = @"0"; // 默认收起状态
    return packupDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
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
}

- (void)keyboardShow:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.textViewTool.transform = CGAffineTransformMakeTranslation(0, rect.origin.y - SCR_HEIGHT);
}

- (void)setupRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata)];
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
    if ([dataDic[@"jpType"] isEqualToString:@"1"]) { // 评论上部分
        CZCommentDetailCell *cell = [CZCommentDetailCell cellWithTableView:tableView];
        cell.block = ^(NSString *commentId, NSString *commentName, NSInteger subCount, NSInteger index){
            
            // 保存评论的ID
            self.commentId = commentId;
            // 回复谁
            self.commentName = commentName;
            // 当前的cell的位置
            self.currentCellIndex = index;
            self.textViewTool.placeHolderText = [NSString stringWithFormat:@"回复  %@:", commentName];
            [self.textViewTool.textView becomeFirstResponder];
        };
        cell.contentDic = self.evaluateArr[indexPath.row];
        
        self.cellHeightDic[@(indexPath.row)] = [NSString stringWithFormat:@"%f", cell.cellHeight];
        return cell;
    } else if ([dataDic[@"jpType"] isEqualToString:@"2"]) { //评论的内容
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDic = self.evaluateArr[indexPath.row];
    if ([dataDic[@"jpType"]  isEqual: @"2"]) {
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
@end
