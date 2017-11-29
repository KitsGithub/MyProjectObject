//
//  BaseViewController.m
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifdef __IPHONE_11_0
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version compare:@"11.0"] != NSOrderedAscending) { // iOS系统版本 >= 11.0,不等于升序,就是等于和降序
        UIImage *backImg = [UIImage imageNamed:@"Nav_Back"];
        CGFloat leftPadding = 5.0;
        CGSize adjustSizeForBetterHorizontalAlignment = CGSizeMake(backImg.size.width + leftPadding, backImg.size.height);
        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0);
        [backImg drawAtPoint:CGPointMake(leftPadding, 0)];
        backImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.navigationController.navigationBar.backIndicatorImage = backImg;
        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backImg;
        UIBarButtonItem *backBtn1 = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:self.navigationController action:@selector(popViewControllerAnimated:)];
        self.navigationItem.backBarButtonItem = backBtn1;
    }else{
        //统一设置返回按钮
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 32, 44)];
        _baseCustomBackButton = backBtn;
        //    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backBtn setImage:[UIImage imageNamed:@"Nav_Back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        UIBarButtonItem *spaceL = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self.navigationController action:@selector(popViewControllerAnimated:)];
        spaceL.width = -20;
        //在基础页面不需要返回按钮
        if (self.navigationController.viewControllers.count > 1) {
            self.navigationItem.leftBarButtonItems = @[spaceL , leftBarButtonItem];
        }
    }
#else
    //统一设置返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 22, 44)];
    _baseCustomBackButton = backBtn;
    //    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"Nav_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *spaceL = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self.navigationController action:@selector(popViewControllerAnimated:)];
    spaceL.width = -10;
    //在基础页面不需要返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItems = @[spaceL , leftBarButtonItem];
    }
#endif
    
    
    
    
}

- (BOOL)willPopByNavigationController
{
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
}

- (void)setCustomTitle:(NSString *)customTitle {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    _titleLabel = titleLabel;
    titleLabel.text = customTitle;
    titleLabel.textColor = BLACKCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = titleLabel;
    
}


- (void)backAction {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ 销毁了",NSStringFromClass(self.class));
}

@end
