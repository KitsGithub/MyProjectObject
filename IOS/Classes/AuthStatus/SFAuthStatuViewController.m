//
//  SFAuthStatuViewController.m
//  SFLIS
//
//  Created by kit on 2017/11/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthStatuViewController.h"
#import "SFAuthIdentflyTipsView.h"
#import "SFAuthStatusMessageView.h"
#import "SFAuthCarMessageView.h"
#import "SFAuthStausTipsView.h"
#import "SFAuthStatusShowImageView.h"


@interface SFAuthStatuViewController ()
@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, assign) BOOL edittingEnable;

@end

@implementation SFAuthStatuViewController {
    UIScrollView *_scrollView;
    SFAuthStatusShowImageView *_showImageView;
    SFAuthStatusMessageView *_messageView;
    SFAuthCarMessageView *_carMessageView;
}

- (instancetype)initWithType:(SFAuthType)type Status:(SFAuthStatusModle*)statusModel
{
    if (self  = [super initWithNibName:@"SFAuthStatusViewController" bundle:nil]) {
        _statusModel  = statusModel;
        _type  = type;
        
    }
    return self;
}

- (void)loadView {
    
    self.view = [[UIScrollView alloc] init];
    _scrollView = (UIScrollView *)self.view;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomTitle:@"信誉认证"];
    [self setup];
    [self setNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveIdentflyInfo {
    [self.view endEditing:YES];
    switch (self.type) {
        case SFAuthTypeCarOwnner:
            [self authCarOwner];
            break;
        case SFAuthTypeCar:
            [self authCar];
            break;
        case SFAuthTypeUser:
            [self authUser];
            break;
        default:
            break;
    }
}

#pragma mark - Networking

/**
 车主认证
 */
- (void)authCarOwner {
    NSString *name = _messageView.textField1;
    NSString *phone = _messageView.textField2;
    NSString *cid = _messageView.textField3;
    NSString *carId = _messageView.textField4;
    NSDictionary *imageDic = [_showImageView getImageArray];
    
    NSData *DrivingCardA = imageDic[@"机动车行驶证正面"];
    NSData *DrivingCardB = imageDic[@"机动车行驶证背面"];
    NSData *LifePic = imageDic[@"生活照"];
    
    if (![name length]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入姓名"];
        return;
    }
    if (![NSString validateCellPhoneNumber:phone]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的电话号码"];
        return;
    }
    if (![cid isAvailableCid]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的身份证号码"];
        return;
    }
    if (![carId length]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入驾驶证号"];
        return;
    }
    
    if (!DrivingCardA) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传机动车行驶证正面图片"];
        return;
    }
    if (!DrivingCardB) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传机动车行驶证背面图片"];
        return;
    }
    if (!LifePic) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传生活照图片"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"UserId"] = SF_USER.user_id;
    params[@"DriverId"]  = self.guid;
    params[@"Name"] = name;
    params[@"Mobile"] = phone;
    params[@"IDCard"] = cid;
    params[@"DrivingNo"] = carId;
    
    [SVProgressHUD show];
    [[SFNetworkManage shared] postWithPath:@"/Certificate/AddDriverCertificate" params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:DrivingCardA name:@"DriverCard" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:DrivingCardB name:@"DriverCardBack" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:LifePic name:@"LifePhoto" fileName:@"file" mimeType:@"image/jpeg"];
    } progress:^(double pro) {} success:^(id result) {
        [SVProgressHUD dismiss];
        
        [[SFTipsView shareView] showSuccessWithTitle:@"提交成功，请耐心等待审核"];
        self.isSaved  = YES;
        if (self.returnBlock) {
            self.returnBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
    
}

/**
 车辆认证
 */
- (void)authCar {
    
    NSMutableDictionary *params = [_carMessageView getCarMessageJson];
    NSLog(@"%zd",params.allKeys.count)
    if (!params.allKeys.count) {
        return;
    }
    
    NSDictionary *imageDic = [_showImageView getImageArray];
    
    
    NSData *DrivingCardA = imageDic[@"机动车行驶证正面"];
    NSData *DrivingCardB = imageDic[@"机动车行驶证背面"];
    NSData *CarPicA = imageDic[@"车头照"];
    NSData *CarPicB = imageDic[@"车侧照"];
    NSData *CarPicC = imageDic[@"车尾照"];
    
    
    if (!DrivingCardA) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传机动车行驶证正面图片"];
        return;
    }
    if (!DrivingCardB) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传机动车行驶证背面图片"];
        return;
    }
    if (!CarPicB) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传车侧照图片"];
        return;
    }
    if (!CarPicA) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传车头照图片"];
        return;
    }
    if (!CarPicC) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传车尾照图片"];
        return;
    }
    
    params[@"UserId"] = SF_USER.user_id;
    if (self.guid.length) {
        params[@"CarId"]  = self.guid;
    }
    
    
    [SVProgressHUD show];
    [[SFNetworkManage shared] postWithPath:@"/Certificate/AddCarTeamCertificate" params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:DrivingCardA name:@"DrivingCard" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:DrivingCardB name:@"DrivingCardBack" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:CarPicA name:@"CarAPhoto" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:CarPicB name:@"CarBPhoto" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:CarPicC name:@"CarCPhoto" fileName:@"file" mimeType:@"image/jpeg"];
        
    } progress:^(double pro) {} success:^(id result) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showSuccessWithTitle:@"提交成功，请耐心等待审核"];
        self.isSaved  = YES;
        if (self.returnBlock) {
            self.returnBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
}

/**
 用户认证
 */
- (void)authUser {
    NSString *name = _messageView.textField1;
    NSString *cid = _messageView.textField2;
    NSDictionary *imageDic = [_showImageView getImageArray];
    
    NSData *idCardAImg = imageDic[@"身份证正面"];
    NSData *idCardBImg = imageDic[@"身份证背面"];
    NSData *idCardAndLifeImg = imageDic[@"生活照"];
    NSData *businessImg = imageDic[@"营业执照"];
    NSData *menTou = imageDic[@"门头照"];
    
    
    if (![name length]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入姓名"];
        return;
    }
    if (![cid isAvailableCid]) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的身份证号码"];
        return;
    }
    
    if (!idCardAImg) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传身份证正面图片"];
        return;
    }
    if (!idCardBImg) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传身份证背面图片"];
        return;
    }
    if (!idCardAndLifeImg) {
        [[SFTipsView shareView] showFailureWithTitle:@"请上传生活照图片"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"UserId"] = SF_USER.user_id;
    params[@"Name"]  = name;
    params[@"IDCard"] = cid;
    
    NSString *path = SF_USER.role == SFUserRoleCarownner ? @"ApiCertificate/AddCarCertificate" : @"ApiCertificate/AddGoodsCertificate";
    
    [SVProgressHUD show];
    [[SFNetworkManage shared] postWithPath:path params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:idCardAImg name:@"IdCard" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:idCardBImg name:@"IdCardBack" fileName:@"file" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:idCardAndLifeImg name:@"LifePhoto" fileName:@"file" mimeType:@"image/jpeg"];
      
        if (businessImg) {
            [formData appendPartWithFileData:businessImg name:@"BusinessLicense" fileName:@"file" mimeType:@"image/jpeg"];
        }
        
        if (menTou) {
            [formData appendPartWithFileData:menTou name:@"ShopPhoto" fileName:@"file" mimeType:@"image/jpeg"];
        }
        
    } progress:^(double pro) {} success:^(id result) {
        [SVProgressHUD dismiss];
        
        //审核状态改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:SF_Identifly_StatusChangeN object:nil];
        
        [[SFTipsView shareView] showSuccessWithTitle:@"提交成功，请耐心等待审核"];
        self.isSaved  = YES;
        if (self.returnBlock) {
            self.returnBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];

}


#pragma mark - UIAction

- (void)backAction
{
    NSDictionary *imageDic = [_showImageView getImageArray];
    if (!imageDic.count || !self.edittingEnable) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信息还没有提交，是否确认返回" preferredStyle:(UIAlertControllerStyleAlert)];
    
    
    __weak typeof(self)wself = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"放弃认证" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"返回编辑" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:alert animated:YES completion:^{}];
    });
}



#pragma mark - 布局
- (void)setNav {
    
    if ([self.statusModel.verify_status isEqualToString:@"A"] || [self.statusModel.verify_status isEqualToString:@"C"] || [self.statusModel.verify_status isEqualToString:@""] ||
        !self.statusModel ||
        self.statusModel.verify_status == nil ||
        [self.statusModel.verify_status isEqualToString:@"F"]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveIdentflyInfo)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.navigationItem.backBarButtonItem.action = @selector(backAction);
}

- (void)setup {
    __weak typeof(self) weakSelf = self;
    self.edittingEnable = NO;
    if ([self.statusModel.verify_status isEqualToString:@"C"] || [self.statusModel.verify_status isEqualToString:@"F"] || !self.statusModel || self.statusModel.verify_status == nil ) {
        self.edittingEnable = YES;
    }
    
    CGFloat height = 0;
    if ([self.statusModel.verify_status isEqualToString:@"D"] || [self.statusModel.verify_status isEqualToString:@"C"] || [self.statusModel.verify_status isEqualToString:@""] || !self.statusModel || self.statusModel.verify_status == nil ) {
        height = 0;
    } else {
        height = 54;
    }
    SFAuthIdentflyTipsView *identflyTipsView = [[SFAuthIdentflyTipsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    identflyTipsView.statusModel = self.statusModel;
    [self.view addSubview:identflyTipsView];
    
    
    if (self.type == SFAuthTypeUser) {
        height = 187;
    } else {
        height = 303;
    }
    
    UIView *view = identflyTipsView;
    if (self.type == SFAuthTypeCar) {
        _carMessageView = [[SFAuthCarMessageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(identflyTipsView.frame) + 30, SCREEN_WIDTH, 575)];
        [self.view addSubview:_carMessageView];
        _carMessageView.status = self.statusModel;
        _carMessageView.edittingEnable = self.edittingEnable;
        view = _carMessageView	;
        
    } else {
        _messageView = [[SFAuthStatusMessageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(identflyTipsView.frame) + 30, SCREEN_WIDTH, height) authType:self.type];
        _messageView.status = self.statusModel;
        _messageView.edittingEnable = self.edittingEnable;
        [self.view addSubview:_messageView];
        view = _messageView;
    }
    
    
    
    if (self.type == SFAuthTypeCarOwnner) {
        height = 278;
    } else if (self.type == SFAuthTypeUser) {
        height = 377;
    } else if (self.type == SFAuthTypeCar) {
        height = 377;
    }
    _showImageView = [[SFAuthStatusShowImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) + 30, SCREEN_WIDTH, height) authType:self.type statusModel:self.statusModel];
    _showImageView.wSelfVC = weakSelf;
    _showImageView.edittingEnable = self.edittingEnable;
    [self.view addSubview:_showImageView];
    
    
    SFAuthStausTipsView *tipsView = [SFAuthStausTipsView new];
    tipsView.frame = CGRectMake(0, CGRectGetMaxY(_showImageView.frame) + 30, SCREEN_WIDTH, tipsView.tipsHeight);
    [self.view addSubview:tipsView];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(tipsView.frame) + 30);
}


@end
