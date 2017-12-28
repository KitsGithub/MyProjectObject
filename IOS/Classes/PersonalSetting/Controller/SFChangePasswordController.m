//
//  SFChangePasswordController.m
//  SFLIS
//
//  Created by kit on 2017/11/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChangePasswordController.h"

#import "SFInputViewCell.h"
#import "SFChangePswFooterView.h"

static NSString *CellReusedID = @"SFPasswordInputViewCell";

@interface SFChangePasswordController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <NSString *>*titleArray;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation SFChangePasswordController {
    UITableView *_tableView;
    SFChangePswFooterView *_footerView;
    
    NSString *oldPsw;
    NSString *newPsw1;
    NSString *newPsw2;
    NSString *phoneNum;
    NSString *code;
    
    UIButton *_codeBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomTitle:@"修改密码"];
    phoneNum = SF_USER.mobile;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_timer) {
       dispatch_source_cancel(_timer);
    }
}

//获取验证码
- (void)getCode {
    [self.view endEditing:YES];
    if (![SF_USER.mobile isAvailableMobile]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的手机号码"];
        return;
    }
    
    [self startCountDown];
    
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = USER_ID;
    params[@"Type"] = @"change_password";
    params[@"Mobile"] = SF_USER.mobile;
    [[SFNetworkManage shared] postWithPath:@"Sms/Send"
                                    params:params
                                   success:^(id result)
    {
        [SVProgressHUD dismiss];
        if (result) {
            [[SFTipsView shareView] showSuccessWithTitle:@"发送验证码成功,请注意查收"];
        } else {
            [[SFTipsView shareView] showFailureWithTitle:@"发送验证码失败,请重试"];
        }
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:@"请检查网络"];
    }];
}

//修改密码
- (void)comfirmButtonClick {
    
    if (!oldPsw.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入当前密码"];
        return;
    } else if (!newPsw1.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入新密码"];
        return;
    } else if (![newPsw2 isEqualToString:newPsw1]) {
        [[SFTipsView shareView] showFailureWithTitle:@"新密码不一致"];
        return;
    } else if (!SF_USER.mobile.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入电话号码"];
        return;
    } else if (!code.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入验证码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = USER_ID;
    params[@"Account"] = SF_USER.account;
    params[@"Mobile"] = SF_USER.mobile;
    params[@"VCode"] = code;
    params[@"OldPwd"] = [oldPsw md5String];
    params[@"NewPwd"] = [newPsw1 md5String];
    
    [[SFNetworkManage shared] postWithPath:@"MyCenter/ModifyPwd"
                                    params:params
                                   success:^(id result)
    {
        
        if (result) {
            [[SFTipsView shareView] showSuccessWithTitle:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[SFTipsView shareView] showFailureWithTitle:@"修改失败"];
        }
        
        
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:err.description];
    }];
}


/**
 开始定时器
 */
- (void)startCountDown {
    _codeBtn.backgroundColor = COLOR_LINE_BLACK;
    _codeBtn.userInteractionEnabled = NO;
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
            [_codeBtn setTitle:[NSString stringWithFormat:@"%lds",weakSelf.countDown] forState:(UIControlStateNormal)];
        }
    });
    
    dispatch_source_set_cancel_handler(_timer, ^{
        _codeBtn.userInteractionEnabled = YES;
        [_codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [_codeBtn setBackgroundColor:THEMECOLOR];
        _timer = nil;
    });
    
    dispatch_resume(_timer);
}


- (void)setupView {
    
    //footer
    _footerView = [[SFChangePswFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68)];
    [_footerView setButtonActionWithTarget:self action:@selector(comfirmButtonClick)];
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFInputViewCell class] forCellReuseIdentifier:CellReusedID];
    [self.view addSubview:_tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReusedID];
    if (!cell) {
        cell = [[SFInputViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellReusedID];
    }
    cell.placeHolder = self.titleArray[indexPath.row];
    cell.secureTextEntry = YES;
    if (indexPath.row == 3) {
        SFUserInfo *account = SF_USER;
        cell.secureTextEntry = NO;
        NSString *targetStr = [account.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        [cell setValeWithStr:targetStr edittingEnable:NO];
        [cell setButtonWithTitle:@"获取验证码" target:self action:@selector(getCode)];
        _codeBtn = cell.button;
        
    } else if (indexPath.row == 4) {
        cell.secureTextEntry = NO;
    }
    
    __weak typeof(indexPath) weakIndexPath = indexPath;
    [cell setEndEdittingBlock:^{
        switch (weakIndexPath.row) {
            case 0:
                oldPsw = cell.value;
                break;
            case 1:
                newPsw1 = cell.value;
                break;
            case 2:
                newPsw2 = cell.value;
                break;
            case 3:
                phoneNum = cell.value;
                break;
            case 4:
                code = cell.value;
                break;
            default:
                break;
        }
        
        if (oldPsw.length && newPsw1.length && newPsw2.length && phoneNum.length && code.length) {
            _footerView.buttonTouchEnable = YES;
        } else {
            _footerView.buttonTouchEnable = NO;
        }
        
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}



- (NSMutableArray<NSString *> *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"当前密码",@"新密码",@"确认新密码",@"手机号码",@"验证码", nil];
    }
    return _titleArray;
}


@end
