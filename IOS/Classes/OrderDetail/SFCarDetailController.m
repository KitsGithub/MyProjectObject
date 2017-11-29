//
//  SFCarDetailController.m
//  SFLIS
//
//  Created by kit on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarDetailController.h"

@interface SFCarDetailController ()

@end

@implementation SFCarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)sendMessageToH5 {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"Guid"] = self.orderID;
    NSString *htmlMethod = [NSString stringWithFormat:@"SFAppData = %@",[dic mj_JSONString]];
    [self.commandDelegate evalJs:htmlMethod];
    
    NSString *changeType;
    if (self.showType) {
        changeType = [NSString stringWithFormat:@"showType = A"];
    } else {
        changeType = [NSString stringWithFormat:@"showType = B"];
    }
    [self.commandDelegate evalJs:changeType];
    
    
    NSString *htmlMethod3 = [NSString stringWithFormat:@"showData()"];
    [self.commandDelegate evalJs:htmlMethod3];
}


- (instancetype)initWithOrderID:(NSString *)orderID
{
    if(self = [super init]){
        self.startPage = @"carsDetail.html";
        self.title = @"车源详情";
        self.orderID  = orderID;
    }
    return self;
}

@end
