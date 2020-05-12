//
//  CZShareViewController.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/16.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZShareViewController.h"
#import "CZUMConfigure.h"

@interface CZShareViewController ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;

/** <#注释#> */
@property (nonatomic, strong) void (^block)(NSInteger);

@end

@implementation CZShareViewController

- (instancetype)initWithBlock:(void (^)(NSInteger index))block
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.y = SCR_HEIGHT - 34;
    bottomView.width = SCR_WIDTH;
    bottomView.height = 34;
    [self.view addSubview:bottomView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];

    [self.imageView1 addGestureRecognizer:tap1];
    [self.imageView2 addGestureRecognizer:tap2];
    [self.imageView3 addGestureRecognizer:tap3];
}

- (void)action:(UITapGestureRecognizer *)tap
{
    self.block(tap.view.tag - 100);
}

- (IBAction)pop:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
