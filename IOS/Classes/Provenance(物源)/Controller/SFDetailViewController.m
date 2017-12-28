//
//  SFDetailViewController.m
//  SFLIS
//
//  Created by kit on 2017/11/7.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDetailViewController.h"

@interface SFDetailViewController ()

@end

@implementation SFDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNotification];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Nav_Back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
}

- (void)backAction {
    UIWebView *webView = (UIWebView *)self.webViewEngine.engineWebView;
    if (webView.canGoBack) {
        [webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD show];
}

- (void)sendMessageToH5 {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (!self.isBooking) {
        if (SF_USER.role == SFUserRoleCarownner) {
            dic[@"CarId"] = self.orderID;
        } else {
            dic[@"GoodsId"] = self.orderID;
        }
    } else {
        if (SF_USER.role == SFUserRoleCarownner) {
            dic[@"GoodsId"] = self.orderID;
        } else {
            dic[@"CarId"] = self.orderID;
        }
    }
    
    if (self.BatchId) {
        dic[@"BatchId"] = self.BatchId;
    }
    
    dic[@"ismyCarOrd"] = @(self.ismyCarOrd);
    dic[@"UserId"] = USER_ID;
    dic[@"isCloseHistory"] = @(!self.isCloseHistory);
    NSString *htmlMethod = [NSString stringWithFormat:@"SFAppData = %@",[dic mj_JSONString]];
    [self.commandDelegate evalJs:htmlMethod];
    
    NSString *htmlMethod3 = [NSString stringWithFormat:@"showData()"];
    [self.commandDelegate evalJs:htmlMethod3];
    
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotification:)
                                                 name:CDVPluginResetNotification  // 开始加载
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotificationed:)
                                                 name:CDVPageDidLoadNotification  // 加载完成
                                               object:nil];
}


- (void)onNotification:(NSNotification *)text{
    NSLog(@"－－－－－开始等待------");
}


- (void)onNotificationed:(NSNotification *)text{
    NSLog(@"－－－－－结束等待------");
    NSLog(@"h5加载完成");
    [SVProgressHUD dismiss];
    [self sendMessageToH5];
}

- (instancetype)initWithOrderID:(NSString *)orderID
{
    if(self = [super init]){
        self.startPage = @"orderdetail.html";
        self.title = @"货源详情";
        self.orderID  = orderID;
    }
    return self;
}

@end
