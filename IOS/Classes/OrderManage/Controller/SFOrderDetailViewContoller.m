//
//  SFOrderDetailViewContoller.m
//  SFLIS
//
//  Created by kit on 2017/12/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderDetailViewContoller.h"

@implementation SFOrderDetailViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)sendMessageToH5 {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"OrderId"] = self.orderID;
    dic[@"UserId"] = USER_ID;
    
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

@end
