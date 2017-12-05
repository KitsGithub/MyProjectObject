//
//  SFEvalViewController.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFEvalViewController.h"
#import "SFCustomTextView.h"
#import "SFRatingView.h"
#import "SFOrderManage.h"

@interface SFEvalViewController ()

@property (nonatomic,strong)SFRatingView *ratingView;

@property (nonatomic,strong)SFCustomTextView *textView;

@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)UIView *line2;

@property (nonatomic,strong)UIView *startBgView;

@end

@implementation SFEvalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价本次服务";

    self.view.backgroundColor  = COLOR_BG;
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame     = CGRectMake(0, 0, 44, 44);
    [btn setTitle:@"发布" forState:(UIControlStateNormal)];
    btn.titleLabel.font  = FONT_COMMON_16;
    [btn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(publishAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

- (void)publishAction:(UIButton *)sender
{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger start = self.ratingView.startValue;
    
    if (!start) {
        [[SFTipsView shareView] showFailureWithTitle:@"请先对本次服务评星"];
        return;
    }
    if (!text.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"评价内容不能为空"];
        return;
    }
    
    [SVProgressHUD show];
    [SFOrderManage evalWithOrderId:self.orderId Start:start content:text Success:^{
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showSuccessWithTitle:@"评价成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription]; 
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor  = COLOR_LINE_DARK;
        [self.view addSubview:line];
        self.line  = line;
        
        self.startBgView = [[UIView alloc] initWithFrame:CGRectZero];
        self.startBgView.backgroundColor  = [UIColor whiteColor];
        [self.view addSubview:self.startBgView];
        _ratingView  = [[SFRatingView alloc] initWithFrame:CGRectZero];
        [self.startBgView addSubview:_ratingView];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectZero];
        line2.backgroundColor  = COLOR_LINE_DARK;
        [self.view addSubview:line2];
        self.line2  = line2;
        _textView  = [[SFCustomTextView alloc] initWithFrame:CGRectZero];
        _textView.placeholder  = @"评价一下本次服务吧";
        [self.view addSubview:_textView];
        
    });
}




- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat  navMaxY =  [UIApplication sharedApplication].statusBarFrame.size.height + 44 ;
    
    self.line.frame  = CGRectMake(0, navMaxY, [UIScreen mainScreen].bounds.size.width, 1);
    self.startBgView.frame  = CGRectMake(0, CGRectGetMaxY(self.line.frame), [UIScreen mainScreen].bounds.size.width, 44);
    self.ratingView.frame   = CGRectMake(10, 0, 150, 44);
    self.line2.frame  = CGRectMake(0, CGRectGetMaxY(self.startBgView.frame), [UIScreen mainScreen].bounds.size.width, 1);
    self.textView.frame = CGRectMake(0, CGRectGetMaxY(self.line2.frame), [UIScreen mainScreen].bounds.size.width, 172);
    
    
}

@end
