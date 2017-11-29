//
//  SFDriverSignController.m
//  SFLIS
//
//  Created by kit on 2017/11/21.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFIdentflyPhoneController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface SFIdentflyPhoneController ()

@end

@implementation SFIdentflyPhoneController {
    UILabel *_tipsLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupView];
    
    
    
    
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(16, STATUSBAR_HEIGHT + 14, 16, 16)];
    [closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeButton];
    
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44 + 20, SCREEN_WIDTH, 20)];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.text = @"司机签到";
    _tipsLabel.textColor = COLOR_TEXT_COMMON;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:_tipsLabel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
