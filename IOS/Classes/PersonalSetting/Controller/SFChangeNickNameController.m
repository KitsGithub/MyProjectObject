//
//  SFChangeNickNameController.m
//  SFLIS
//
//  Created by kit on 2017/11/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChangeNickNameController.h"

@interface SFChangeNickNameController ()

@end

@implementation SFChangeNickNameController {
    UITextField *_nickTextField;
}

- (instancetype)initWithNickName:(NSString *)nickName {
    if (self = [super init]) {
        self.nickName = nickName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomTitle:@"修改昵称"];
    
    
    UIView *conterView = [[UIView alloc] initWithFrame:CGRectMake(20, STATUSBAR_HEIGHT + 44 + 10, SCREEN_WIDTH - 40, 48)];
    conterView.backgroundColor = [UIColor colorWithHexString:@"f1f1f3"];
    conterView.layer.cornerRadius = 10;
    conterView.clipsToBounds = YES;
    [self.view addSubview:conterView];
    
    _nickTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, conterView.frame.size.width - 20, 48)];
    [conterView addSubview:_nickTextField];
    _nickTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickTextField.textColor = COLOR_TEXT_COMMON;
    _nickTextField.clearsOnBeginEditing = YES;
    if (self.nickName.length) {
        _nickTextField.placeholder = self.nickName;
    } else {
        _nickTextField.placeholder = @"请输入新的昵称";
    }
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveNickName)];
    self.navigationItem.rightBarButtonItem = item;
    
}

//修改昵称
- (void)saveNickName {
    NSLog(@"修改昵称");
    if (!_nickTextField.text.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入名称"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = USER_ID;
    params[@"Name"] = _nickTextField.text;
    
    [[SFNetworkManage shared] postWithPath:@"MyCenter/ModifyProfile"
                                    params:params
                                   success:^(id result)
    {
        if (result) {
            [[SFTipsView shareView] showSuccessWithTitle:@"修改昵称成功"];
            
            //保存新的用户信息
            SFUserInfo *account = SF_USER;
            account.name = result[@"name"];
            [account saveUserInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SF_USER_MESSAGECHANGE_N object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];

            
        } else {
            [[SFTipsView shareView] showFailureWithTitle:@"修改昵称失败"];
        }
        
        
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
