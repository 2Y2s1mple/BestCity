//
//  CZBaseEvaluationController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZBaseEvaluationController.h"

@interface CZBaseEvaluationController ()

@end

@implementation CZBaseEvaluationController
@synthesize  noDataView = _noDataView;
#pragma mark - 视图
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        _noDataView = [CZNoDataView noDataView];
        _noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *line = [[UIView alloc] init];
    line.y = 0;
    line.width = SCR_WIDTH;
    line.height = 1;
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
}

@end
