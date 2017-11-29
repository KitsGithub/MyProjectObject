//
//  SFReleaseViewController.m
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFReleaseViewController.h"
#import "CDVUIWebViewEngine.h"
#import "SFNetworkManage.h"
#import "SFNetworkingPlugin.h"

@interface SFReleaseViewController ()

@end

@implementation SFReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"发货";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    void(^block)(BOOL) = self.completion;
    [SFNetworkingPlugin registWithId:@"publishCompletion" block:^(id result){
        if (block) {
            block([result boolValue]);
        }
    }];
    
    
    UIBarButtonItem *tiem = [[UIBarButtonItem alloc] initWithTitle:@"暂存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveOrder)];
    self.navigationItem.rightBarButtonItem = tiem;
    
    [self addNotification];
    
}

/**
 暂存方法
 */
- (void)saveOrder {
    NSString *htmlMethod3 = [NSString stringWithFormat:@"saveOrder()"];
    [self.commandDelegate evalJs:htmlMethod3];
}

- (void)sendMessageToH5 {
    if (self.orderId.length) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"Guid"] = self.orderId;
        dic[@"UserId"] = USER_ID;
        NSString *htmlMethod = [NSString stringWithFormat:@"SFAppData = %@",[dic mj_JSONString]];
        [self.commandDelegate evalJs:htmlMethod];
        
        NSString *method = [NSString stringWithFormat:@"requestOrderDetail()"];
        [self.commandDelegate evalJs:method];
    }
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
    
    NSString *js = [NSString stringWithFormat:@"orderId=\"%@\"",self.orderId];
    [self.commandDelegate evalJs:js];
    
    [self sendMessageToH5];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //统一设置返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 22, 44)];
    _baseCustomBackButton = backBtn;
    //    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"Nav_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *spaceL = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceL.width = -10;
    self.navigationItem.leftBarButtonItems = @[spaceL , leftBarButtonItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    if (!self.orderId) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
