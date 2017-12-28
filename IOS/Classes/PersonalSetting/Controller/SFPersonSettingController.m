//
//  SFPersonSettingController.m
//  SFLIS
//
//  Created by kit on 2017/11/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFPersonSettingController.h"

//跳转
#import "SFChangeNickNameController.h"
#import "SFChangePasswordController.h"

//自定义view
#import "SFPersonalSettingHeaderView.h"
#import "PersonalSettingCell.h"

static NSString *PersonalSettingCellReusedID = @"PersonalSettingCellReusedID";
static NSString *PersonalSettingHeaderId = @"PersonalSettingHeaderId";
@interface SFPersonSettingController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray <NSArray *>*titleArray;
@property (nonatomic, strong) NSMutableArray <NSArray *>*detailArray;

@end

@implementation SFPersonSettingController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoChange) name:SF_USER_MESSAGECHANGE_N object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UserInfoChange {
    [_tableView reloadData];
}


- (void)changeUserIcon {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择相片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍摄", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        return;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [UploadResouce_URL stringByAppendingString:@"/PersonalData/AddHeadPic"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = USER_ID;
    [manager POST:url parameters:params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"HeadPic" fileName:@"file" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if ([result[@"Code"] intValue] == 0) {
            NSString *smallHead = result[@"Data"][@"small_head_src"];
            
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"UserId"] = USER_ID;
            params[@"HeadSrc"] = smallHead;
            
            [[SFNetworkManage shared] postWithPath:@"MyCenter/ModifyProfile"
                                            params:params
                                           success:^(id result)
             {
                 if (result) {
                     [[SFTipsView shareView] showSuccessWithTitle:@"修改头像成功"];
                     
                     //保存新的用户信息
                     SFUserInfo *account = SF_USER;
                     if (smallHead.length) {
                         account.small_head_src = smallHead;
                         [account saveUserInfo];
                     }
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:SF_USER_MESSAGECHANGE_N object:nil];
                     
                     
                 } else {
                     [[SFTipsView shareView] showFailureWithTitle:@"修改昵称失败"];
                 }
                 
                 
             } fault:^(SFNetworkError *err) {
                 [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
             }];
            
            
            
            
        } else {
            [[SFTipsView shareView] showFailureWithTitle:@"修改头像失败"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[SFTipsView shareView] showFailureWithTitle:@"修改头像失败"];
        [SVProgressHUD dismiss];
        
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseViewController *vc;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                NSLog(@"修改头像");
                [self changeUserIcon];
                return;
            case 1: {
                NSLog(@"修改昵称");
                SFUserInfo *account = SF_USER;
                vc = [[SFChangeNickNameController alloc] initWithNickName:[NSString stringWithFormat:@"%@",account.name]];
                break;
            }
            default:
                break;
        }
    } else {
        if (indexPath.row == 2) {
            NSLog(@"修改密码");
            vc = [[SFChangePasswordController alloc] init];
        }
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)setNav {
    [self setCustomTitle:@"个人资料"];
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[PersonalSettingCell class] forCellReuseIdentifier:PersonalSettingCellReusedID];
    [_tableView registerClass:[SFPersonalSettingHeaderView class] forHeaderFooterViewReuseIdentifier:PersonalSettingHeaderId];
    [self.view addSubview:_tableView];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *titleArray = self.titleArray[section];
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalSettingCellReusedID forIndexPath:indexPath];
    NSArray *titleArray = self.titleArray[indexPath.section];
    NSArray *detailArray = self.detailArray[indexPath.section];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.showHeaderView = YES;
        cell.imageURL = detailArray[0];
    } else if (indexPath.section == 1) {
        cell.showArrowImage = NO;
    }
    cell.detailStr = detailArray[indexPath.row];
    cell.titleStr = titleArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SFPersonalSettingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PersonalSettingHeaderId];
    if (section == 0) {
        headerView.title = @"个人资料";
    } else if (section == 1) {
        headerView.title = @"账户管理";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .001;
}

- (NSMutableArray<NSArray *> *)titleArray {
    if (!_titleArray) {
        NSArray *arr1 = @[@"头像",@"昵称"];
        NSArray *arr2 = @[@"我的账户",@"绑定手机",@"修改密码"];
        _titleArray = [NSMutableArray arrayWithObjects:arr1,arr2, nil];
    }
    return _titleArray;
}

- (NSMutableArray<NSArray *> *)detailArray {
    SFUserInfo *account = SF_USER;
    NSArray *arr1 = @[[NSString stringWithFormat:@"%@%@",Resource_URL,account.small_head_src],account.name];
    NSArray *arr2 = @[account.account,account.mobile,@""];
    _detailArray = [NSMutableArray arrayWithObjects:arr1,arr2, nil];
    return _detailArray;
}

@end
