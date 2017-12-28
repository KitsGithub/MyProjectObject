//
//  SFForgetPswViewController.m
//  SFLIS
//
//  Created by kit on 2017/11/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFForgetPswViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface SFForgetPswViewController ()

@end

@implementation SFForgetPswViewController {
    UITextField *_newCode;
    UITextField *_newCode2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestAction {
    [self.view endEditing:YES];
    NSString *pasword1 = _newCode.text;
    NSString *pasword2 = _newCode2.text;
    
    if (!pasword1.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入新密码"];
        if ([_newCode canBecomeFocused]) {
            [_newCode becomeFirstResponder];
        }
        return;
    }
    if (!pasword2.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请再次输入新密码"];
        if ([_newCode2 canBecomeFocused]) {
            [_newCode2 becomeFirstResponder];
        }
        return;
    }
    if (![pasword1 isEqualToString:pasword2]) {
        [[SFTipsView shareView] showFailureWithTitle:@"两次密码不一致"];
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Mobile"] = self.phone;
    params[@"NewPwd"] = [pasword1 md5String];
    [[SFNetworkManage shared] postWithPath:@"MyCenter/ResetPassword"
                                    params:params
                                   success:^(id result)
     {
         [SVProgressHUD dismiss];
         if (result) {
             [[SFTipsView shareView] showSuccessWithTitle:@"修改密码成功"];
             [self backAction];
             
         }
         
     } fault:^(SFNetworkError *err) {
         [SVProgressHUD dismiss];
         [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
     }];
    
    
    
}

- (void)setupView {
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT - 2, 48, 48)];
    [closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeButton];
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44 + 20, SCREEN_WIDTH, 20)];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = @"重置密码";
    tipsLabel.textColor = COLOR_TEXT_COMMON;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:tipsLabel];
    
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(tipsLabel.frame) + 53, SCREEN_WIDTH - 40, 48)];
    phoneView.userInteractionEnabled = YES;
    phoneView.image = [UIImage imageNamed:@"InputViewBG"];
    [self.view addSubview:phoneView];
    _newCode = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(phoneView.frame) - 20, CGRectGetHeight(phoneView.frame))];
    _newCode.placeholder = @"请输入新密码";
    _newCode.secureTextEntry = YES;
    _newCode.textColor = [UIColor colorWithHexString:@"666666"];
    _newCode.font = FONT_COMMON_16;
    [phoneView addSubview:_newCode];
    
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(phoneView.frame) + 20, SCREEN_WIDTH - 40, 48)];
    codeView.image = [UIImage imageNamed:@"InputViewBG"];
    codeView.userInteractionEnabled = YES;
    [self.view addSubview:codeView];
    
    _newCode2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(codeView.frame) - 20, 48)];
    _newCode2.placeholder = @"确认新密码";
    _newCode2.secureTextEntry = YES;
    _newCode2.textColor = [UIColor colorWithHexString:@"666666"];
    _newCode2.font = FONT_COMMON_16;
    [codeView addSubview:_newCode2];
    
    UIButton *requestButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(codeView.frame) + 20, SCREEN_WIDTH - 40, 48)];
    [self.view addSubview:requestButton];
    [requestButton setBackgroundColor:THEMECOLOR];
    [requestButton setTitle:@"确认" forState:(UIControlStateNormal)];
    
    
    [requestButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [requestButton addTarget:self action:@selector(requestAction) forControlEvents:(UIControlEventTouchUpInside)];
    requestButton.layer.cornerRadius = 4;
    requestButton.clipsToBounds = YES;
    requestButton.titleLabel.font = FONT_COMMON_16;
    
    
}

@end
