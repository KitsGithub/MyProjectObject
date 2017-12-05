//
//  SFDriverSignController.m
//  SFLIS
//
//  Created by kit on 2017/11/21.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFIdentflyPhoneController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "SFDriverTransportDetailController.h"
#import "SFForgetPswViewController.h"
@interface SFIdentflyPhoneController ()

@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation SFIdentflyPhoneController {
    UITextField *_phone;
    UITextField *_code;
    UIButton *_getCodeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    self.countDown = 60;
    [self setupView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)jumpToDriver {
    SFDriverTransportDetailController *transport = [[SFDriverTransportDetailController alloc] init];
    [self.navigationController pushViewController:transport animated:YES];
}

- (void)jumpToUser {
    SFForgetPswViewController *forget = [[SFForgetPswViewController alloc] init];
    forget.phone = _phone.text;
    forget.vCode = _code.text;
    [self.navigationController pushViewController:forget animated:YES];
}

- (void)requestAction {
    switch (self.identiflyType) {
        case IdentiflyType_Driver:
            [self jumpToDriver];
            break;
        case IdentiflyType_User:
            [self jumpToUser];
            break;
        default:
            break;
    }
}


/**
 获取验证码
 */
- (void)getMobileCode {
    [self.view endEditing:YES];
    
    NSString *Type = @"";
    switch (self.identiflyType) {
        case IdentiflyType_User:
            Type = @"change_password";
            break;
        case IdentiflyType_Driver:
            Type = @"login";
            break;
        default:
            break;
    }

    if (!Type.length) {
        return;
    }
    
    NSString *phoneNum = _phone.text;
    
    if (!phoneNum.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入手机号码"];
        
        if ([_phone canBecomeFocused]) {
            [_phone becomeFirstResponder];
        }
        
        
        return;
    }
    if (![phoneNum isAvailableMobile]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的手机号码"];
        return;
    }
    
    [self startCountDown];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = Type;
    params[@"Mobile"] = phoneNum;
    if (self.identiflyType == IdentiflyType_User) {
        params[@"UserId"] = USER_ID;
    }
    [[SFNetworkManage shared] postWithPath:@"Sms/Send"
                                    params:params
                                   success:^(id result)
     {

         if (result) {
             [[SFTipsView shareView] showSuccessWithTitle:@"发送验证码成功,请注意查收"];
             dispatch_resume(_timer);
         } else {
             [[SFTipsView shareView] showFailureWithTitle:@"发送验证码失败,请重试"];
             dispatch_source_cancel(_timer);
         }

     } fault:^(SFNetworkError *err) {

     }];
    
}


/**
 开始定时器
 */
- (void)startCountDown {
    _getCodeButton.backgroundColor = COLOR_LINE_BLACK;
    _getCodeButton.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    
    if (self.timer) {
        return;
    }
    
    self.countDown = 60;
    
    //1.创建类型为 定时器类型的 Dispatch Source
    //1.1将定时器设置在主线程
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        self.countDown--;
        if (self.countDown < 50) {
            dispatch_source_cancel(_timer);
        } else {
            [_getCodeButton setTitle:[NSString stringWithFormat:@"%lds",weakSelf.countDown] forState:(UIControlStateNormal)];
        }
    });
    
    dispatch_source_set_cancel_handler(_timer, ^{
        _getCodeButton.userInteractionEnabled = YES;
        [_getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [_getCodeButton setBackgroundColor:THEMECOLOR];
        _timer = nil;
    });
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT - 2, 48, 48)];
    [closeButton setImage:[UIImage imageNamed:@"Nav_Close"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeButton];
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44 + 20, SCREEN_WIDTH, 20)];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = self.titleStr;
    tipsLabel.textColor = COLOR_TEXT_COMMON;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:tipsLabel];
    
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(tipsLabel.frame) + 53, SCREEN_WIDTH - 40, 48)];
    phoneView.userInteractionEnabled = YES;
    phoneView.image = [UIImage imageNamed:@"InputViewBG"];
    [self.view addSubview:phoneView];
    _phone = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(phoneView.frame) - 20, CGRectGetHeight(phoneView.frame))];
    _phone.placeholder = @"请输入手机号";
    _phone.textColor = [UIColor colorWithHexString:@"666666"];
    _phone.font = FONT_COMMON_16;
    [phoneView addSubview:_phone];
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(phoneView.frame) + 20, SCREEN_WIDTH - 40, 48)];
    [self.view addSubview:codeView];
    _getCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(codeView.frame) - 120, 0, 120, 48)];
    [_getCodeButton setBackgroundColor:THEMECOLOR];
    [_getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [_getCodeButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [_getCodeButton addTarget:self action:@selector(getMobileCode) forControlEvents:(UIControlEventTouchUpInside)];
    _getCodeButton.titleLabel.font = FONT_COMMON_16;
    _getCodeButton.layer.cornerRadius = 4;
    _getCodeButton.clipsToBounds = YES;
    [codeView addSubview:_getCodeButton];
    
    UIImageView *codeContentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(codeView.frame) - CGRectGetWidth(_getCodeButton.frame) - 10, 48)];
    codeContentView.userInteractionEnabled = YES;
    codeContentView.image = [UIImage imageNamed:@"InputViewBG"];
    [codeView addSubview:codeContentView];
    
    _code = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(codeContentView.frame) - 20, 48)];
    _code.placeholder = @"请输入手机验证码";
    _code.textColor = [UIColor colorWithHexString:@"666666"];
    _code.font = FONT_COMMON_16;
    [codeContentView addSubview:_code];
    
    UIButton *requestButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(codeView.frame) + 20, SCREEN_WIDTH - 40, 48)];
    [self.view addSubview:requestButton];
    [requestButton setBackgroundColor:THEMECOLOR];
    if (self.identiflyType == IdentiflyType_Driver) {
        [requestButton setTitle:@"登录" forState:(UIControlStateNormal)];
    } else if (self.identiflyType == IdentiflyType_User) {
        [requestButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    }
    
    [requestButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [requestButton addTarget:self action:@selector(requestAction) forControlEvents:(UIControlEventTouchUpInside)];
    requestButton.layer.cornerRadius = 4;
    requestButton.clipsToBounds = YES;
    requestButton.titleLabel.font = FONT_COMMON_16;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
