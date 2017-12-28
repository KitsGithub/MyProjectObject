//
//  LoginViewController.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/10.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "LoginViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "LoginRequest.h"
#import "SFInnerShadowableView.h"
#import "AuthcodeView.h"

#import "SFIdentflyPhoneController.h"

@interface LoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTop;

@property (nonatomic,assign)SFUserRole currentRole;

@property (nonatomic,assign,getter=isRegistNameCorrent)BOOL registNameCorrent;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginSegmentBtn;

@property (weak, nonatomic) IBOutlet UIButton *registSegmentBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetSegmentBtn;

@property (weak, nonatomic) IBOutlet UIView *segmentLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineCenterX;

@property (weak, nonatomic) IBOutlet UIScrollView *switchScrollView;



// login info
@property (weak, nonatomic) IBOutlet UITextField *loginUserNameTestfiled;

@property (weak, nonatomic) IBOutlet UITextField *loginPwdTestfiled;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginPwdSecretBtn;


// regist info
@property (weak, nonatomic) IBOutlet UITextField *registNameTextFile;

@property (weak, nonatomic) IBOutlet UITextField *registPwdTestfiled;

@property (weak, nonatomic) IBOutlet UILabel *registPwdTipLable;

@property (weak, nonatomic) IBOutlet UITextField *registMobilTestfiled;

@property (weak, nonatomic) IBOutlet UITextField *registCodeTestfiled;

@property (weak, nonatomic) IBOutlet UILabel *registNameTipLabel;

@property (weak, nonatomic) IBOutlet UIImageView *registCodeImageView;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (weak, nonatomic) IBOutlet UIButton *registSecretBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registPwdTipHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registNameTipHeight;

@property (weak, nonatomic) IBOutlet UIButton *registNameAvailableBtn;

@property (weak, nonatomic) IBOutlet UIView *chooseRoleView;

@property (nonatomic,strong)UIButton *regitAuthView;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation LoginViewController


- (instancetype)init
{
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
    return self;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.switchScrollView.contentOffset = CGPointMake(0, 0);
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.switchScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    self.switchScrollView.delegate  = self;
    self.switchScrollView.showsHorizontalScrollIndicator = NO;
    self.switchScrollView.scrollEnabled = NO;
    self.registNameTextFile.delegate  = self;
    
    
    self.regitAuthView = [[UIButton alloc] initWithFrame:self.registCodeImageView.superview.bounds];
    self.regitAuthView.backgroundColor = THEMECOLOR;
    [self.regitAuthView setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.regitAuthView addTarget:self action:@selector(getRegestCode) forControlEvents:(UIControlEventTouchUpInside)];
    [self.regitAuthView setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    self.regitAuthView.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.registCodeImageView.superview addSubview:self.regitAuthView];
    
    [self.registCodeTestfiled setValue:@4 forKey:@"limit"];
    [self.registMobilTestfiled setValue:@11 forKey:@"limit"];
    
    
    self.navTop.constant  = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.loginBtn.backgroundColor = THEMECOLOR;
}

- (IBAction)backAction:(id)sender {
    
    [self completeWithAccount:nil];
}

- (void)completeWithAccount:(SFUserInfo *)account
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SF_LOGIN_SUCCESS_N object:nil];
    
    __block typeof(self.completeBlock) block  = self.completeBlock;
    [self dismissViewControllerAnimated:YES completion:^{
        if (block) {
            block(account);
        }
    }];
}

- (IBAction)segmentBtnClick:(UIButton *)sender {
    
    [self changeScrollViewIsLogin:sender == self.loginSegmentBtn isAnimotion:NO];
    [self changeSegmentIsLogin:sender == self.loginSegmentBtn isAnimotion:NO];
}

- (IBAction)restPasswordAction:(UIButton *)sender {
    NSLog(@"忘记密码");
    
    SFIdentflyPhoneController *identflyPhone = [[SFIdentflyPhoneController alloc] init];
    identflyPhone.identiflyType = IdentiflyType_User;
    identflyPhone.titleStr = @"忘记密码";
    [self.navigationController pushViewController:identflyPhone animated:YES];
    
}

- (void)getRegestCode {
    
    //获取注册验证码
    NSString *mobile = [self.registMobilTestfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![mobile isAvailableMobile]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的手机号码"];
        return;
    }
    
    [self startCountDown];
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Type"] = @"register";
    params[@"Mobile"] = mobile;
    
    [[SFNetworkManage shared] postWithPath:@"Sms/Send"
                                    params:params
                                   success:^(id result)
    {
        [SVProgressHUD dismiss];
        if (result) {
            [[SFTipsView shareView] showSuccessWithTitle:@"发送验证码成功,请注意查收"];
        } else {
            [[SFTipsView shareView] showFailureWithTitle:@"发送验证码失败,请重试"];
            dispatch_source_cancel(_timer);
        }
        
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
    
}

/**
 开始定时器
 */
- (void)startCountDown {
    self.regitAuthView.backgroundColor = COLOR_LINE_BLACK;
    self.regitAuthView.userInteractionEnabled = NO;
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
        if (self.countDown < 0) {
            dispatch_source_cancel(_timer);
        } else {
            [self.regitAuthView setTitle:[NSString stringWithFormat:@"%lds",weakSelf.countDown] forState:(UIControlStateNormal)];
        }
    });
    
    dispatch_source_set_cancel_handler(_timer, ^{
        self.regitAuthView.userInteractionEnabled = YES;
        [self.regitAuthView setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [self.regitAuthView setBackgroundColor:THEMECOLOR];
        _timer = nil;
    });
    
    dispatch_resume(_timer);
}

- (void)changeSegmentIsLogin:(BOOL)isLogin isAnimotion:(BOOL)animotion
{
    [self.segmentLineView.superview removeConstraint:self.lineCenterX];
    UIButton *sender = isLogin  ? self.loginSegmentBtn : self.registSegmentBtn;
    if (isLogin) {
        [self.loginSegmentBtn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
        [self.registSegmentBtn setTitleColor:COLOR_TEXT_DARK forState:(UIControlStateNormal)];
    } else {
        [self.loginSegmentBtn setTitleColor:COLOR_TEXT_DARK forState:(UIControlStateNormal)];
        [self.registSegmentBtn setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    }
    NSLayoutConstraint *cons = [NSLayoutConstraint constraintWithItem:self.segmentLineView attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:sender attribute:(NSLayoutAttributeCenterX) multiplier:1.0 constant:0];
    self.lineCenterX  = cons;
    [self.segmentLineView.superview addConstraint:self.lineCenterX];
    [UIView animateWithDuration:(animotion ? 0.3 : 0.0) animations:^{
        [self.segmentLineView.superview updateConstraints];
        [self.segmentLineView.superview layoutIfNeeded];
    }];
}

- (void)changeScrollViewIsLogin:(BOOL)isLogin isAnimotion:(BOOL)animotion
{
    CGFloat offX = isLogin ? 0 : self.switchScrollView.bounds.size.width;
    if (self.switchScrollView.contentOffset.x != offX) {
        [self.switchScrollView setContentOffset:CGPointMake(offX, 0) animated:animotion];
    }
}


- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    [SVProgressHUD show];
    NSString *userName = [self.loginUserNameTestfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd    = [self.loginPwdTestfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![userName length]) {
        [self alertInputError:@"请输入账号"];
        return;
    }
    
    if (![pwd length]) {
        [self alertInputError:@"请输入密码"];
        return;
    }
    
    [LoginRequest loginWithAccount:userName pwd:pwd succuss:^(SFUserInfo *account) {
        
        [[SFTipsView shareView] showSuccessWithTitle:@"登陆成功"];
        
        [account saveUserInfo];
        
        [self requestUserIndentfly:account];
        [self completeWithAccount:account];
        
        
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
    
}

/**
 请求当前用户的认证信息
 */
- (void)requestUserIndentfly:(SFUserInfo *)account {
    [[SFNetworkManage shared] postWithPath:@"Certificate/GetCertificateInfo"
                                    params:@{
                                             @"UserId" : account.user_id
                                             }
                                   success:^(id result)
     {
         [SVProgressHUD dismiss];
         SFAuthStatusModle *auth = [SFAuthStatusModle mj_objectWithKeyValues:result];
         
         SFUserInfo *info = [SFUserInfo defaultInfo];
         info.authStatus = auth;
//         [info saveUserInfo];
         
     } fault:^(SFNetworkError *err) {
         
     }];
}


- (IBAction)registAction:(id)sender {
    
    NSString *userName = [self.registNameTextFile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd    = [self.registPwdTestfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *mobile = [self.registMobilTestfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *code  = [self.registCodeTestfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![userName length]) {
        self.registNameCorrent = NO;
        return;
    }
    
    if ([pwd isAvailablePwd]) {
        [self showPwdTextfiledError:NO];
    }else{
        [self showPwdTextfiledError:YES];
        return;
    }
    
    if (![mobile isAvailableMobile]) {
        [self alertInputError:@"请输入正确的手机号"];
        return;
    }
    [SVProgressHUD show];
    [LoginRequest registWithAccount:userName pwd:pwd mobile:mobile  role:self.currentRole code:code succuss:^(SFUserInfo *account) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showSuccessWithTitle:@"注册成功"];
        
        [self completeWithAccount:account];
        self.loginUserNameTestfiled.text  = userName;
        self.loginPwdTestfiled.text = nil;
        [self changeScrollViewIsLogin:YES isAnimotion:YES];
        [self changeSegmentIsLogin:YES isAnimotion:YES];
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
    
}

- (IBAction)loginShowPwdAction:(UIButton *)sender {
    sender.selected  = !sender.isSelected;
    self.loginPwdTestfiled.secureTextEntry  = !sender.isSelected;
}

- (IBAction)registShowPwdAction:(UIButton *)sender {
    sender.selected  =  !sender.isSelected;
    self.registPwdTestfiled.secureTextEntry  = !sender.selected;
}

- (IBAction)tobeGoodsOwner:(id)sender {
    self.currentRole  = SFUserRoleGoodsownner;
    self.chooseRoleView.hidden  = YES;
    [self.chooseRoleView removeFromSuperview];
}


- (IBAction)tobeCarOwner:(id)sender {
    self.currentRole  = SFUserRoleCarownner;
    self.chooseRoleView.hidden  = YES;
    [self.chooseRoleView removeFromSuperview];
}

#pragma mark   UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= [UIScreen mainScreen].bounds.size.width) {
        [self changeSegmentIsLogin:NO isAnimotion:YES];
    }else{
        [self changeSegmentIsLogin:YES isAnimotion:YES];
    }
}

#pragma mark  UITextfiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.loginUserNameTestfiled) {
        [self.loginPwdTestfiled becomeFirstResponder];
    }
    if (textField == self.loginPwdTestfiled) {
        [self loginAction:self.loginBtn];
    }
    
    if (textField == self.registNameTextFile) {
        [self.registPwdTestfiled becomeFirstResponder];
    }
    
    if (textField == self.registPwdTestfiled) {
        if (![[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isAvailablePwd]) {
            [self showPwdTextfiledError:YES];
            return NO;
        }else{
            [self showPwdTextfiledError:NO];
            [self.registMobilTestfiled becomeFirstResponder];
        }
    }
    
    if (textField  == self.registMobilTestfiled) {
        [self.registCodeTestfiled becomeFirstResponder];
    }
    
    if (textField == self.registCodeTestfiled) {
        [self registAction:self.registBtn];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField == self.registPwdTestfiled) {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([[result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isAvailablePwd]) {
            [self showPwdTextfiledError:NO];
        }
    }
    
    if (textField == self.registNameTextFile) {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([[result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) {
            [self showRegistUserNameError:NO messsage:nil];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.registNameTextFile) {
        [LoginRequest checkUserName:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] Succuss:^(BOOL isAvailable) {
            self.registNameCorrent  = isAvailable;
        } fault:^(SFNetworkError *err) {
            self.registNameCorrent  = NO;
        }];
    }
    
    if (textField  == self.registPwdTestfiled) {
        if (![[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isAvailablePwd]) {
            [self showPwdTextfiledError:YES];
        }else{
            [self showPwdTextfiledError:NO];
        }
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.registNameTextFile) {
        self.registNameAvailableBtn.hidden  = YES;
    }
}

#pragma mark  私有方法
- (void)alertInputError:(NSString *)errDesc
{
    [[SFTipsView shareView] showFailureWithTitle:errDesc];
}

- (void)showPwdTextfiledError:(BOOL)isShow
{
    [self showInlineError:isShow textFiled:self.registPwdTestfiled tipLable:self.registPwdTipLable tipHeight:self.registPwdTipHeight];
}

- (void)showRegistUserNameError:(BOOL)isShow messsage:(NSString *)mesage
{
    if (isShow && mesage) {
        self.registNameTipLabel.text  = mesage;
    }
    [self showInlineError:isShow textFiled:self.registNameTextFile tipLable:self.registNameTipLabel tipHeight:self.registNameTipHeight];
}

- (void)setRegistNameCorrent:(BOOL)registNameCorrent
{
    _registNameCorrent  = registNameCorrent;
    if (registNameCorrent) {
        [self showRegistUserNameError:NO messsage:nil];
        self.registNameAvailableBtn.hidden  = NO;
    }else{
        [self showRegistUserNameError:YES messsage:self.registNameTextFile.text.length ?  @"该用户名已经被使用" : @"用户名不能为空"];
        self.registNameAvailableBtn.hidden  = YES;
    }
}

- (void)showInlineError:(BOOL)isError textFiled:(UITextField *)textfiled tipLable:(UILabel *)tipLable tipHeight:(NSLayoutConstraint *)tipHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        tipHeight.constant  =  isError ? 22 : 0;
        [tipLable.superview updateConstraints];
        [tipLable.superview layoutIfNeeded];
        [textfiled superview].layer.borderColor  = isError ? [UIColor colorWithHexString:@"#e65c5c"].CGColor : [UIColor colorWithHexString:@"#c7d1e4"].CGColor;
    }];
}



@end
