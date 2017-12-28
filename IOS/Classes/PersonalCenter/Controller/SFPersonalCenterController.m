//
//  SFPersonalCenterController.m
//  SFLIS
//
//  Created by kit on 2017/9/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFPersonalCenterController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

//跳转
#import "SFMyDriverListController.h"
#import "SFCarListViewController.h"
#import "SFPersonSettingController.h"
#import "MessageCenterController.h"

//自定义控件
#import "SFPersonalNavBar.h"
#import "SFPersonalCenterHeaderView.h"
#import "SFPersonCenterCell.h"
#import "SFProvenanceViewController.h"

#import "SFAuthStatusModle.h"
#import "SFAuthStatuViewController.h"

static NSString *PersonalCenterCellReusedID = @"PersonalCenterCellReusedID";
static CGFloat maxDistance = 200;

@interface SFPersonalCenterController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,SFPersonalNavBarDelegate>

@property (nonatomic, weak)SFPersonalNavBar *navBar;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic,strong) SFAuthStatusModle *authStatus;
@end

@implementation SFPersonalCenterController {
    UIImageView *_bjView;
    UITableView *_tableView;
    
    //认证备注
    NSString *_verify_remark;
    SFPersonalCenterHeaderView *_headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupNav];
    
    [self addNotification];
    [self getCertificationInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestUnreadMessage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
}

- (void)addNotification {
    //认证状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(identiflyStatusChange:) name:SF_Identifly_StatusChangeN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoChange) name:SF_USER_MESSAGECHANGE_N object:nil];
}



- (void)identiflyStatusChange:(NSNotification *)notification {
    _verify_remark = @"审核中";
    if (SF_USER.role == SFUserRoleCarownner) {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
    } else if (SF_USER.role == SFUserRoleGoodsownner) {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}

- (void)UserInfoChange {
    [_headerView reloadData];
}




/**
 登出
 */

- (void)logout {
    [SF_USER clearUserInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SF_LOGOUT_SUCCESS_N object:nil];
    
    [[[SFTipsView alloc] init] showSuccessWithTitle:@"退出成功"];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 请求未读消息
 */
- (void)requestUnreadMessage {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = USER_ID;
    [[SFNetworkManage shared] postWithPath:@"Account/GetVerfiyInfo"
                                    params:params
                                   success:^(id result)
    {
        if (result) {
            NSNumber *unreadCount = result[@"msg_count"];
            if (![unreadCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [_navBar setUnreadMessage];
            }
            
            SFUserInfo *info = SF_USER;
            NSString *verfiy_status = result[@"verfiy_status"];
            if (verfiy_status.length) {
                info.verify_status = verfiy_status;
            }
            
            
            NSNumber *accept_count = result[@"accept_count"];
            info.accept_count = accept_count;
            
            [info saveUserInfo];
            [_headerView reloadData];
            
        }
        
        
    } fault:^(SFNetworkError *err) {
        
    }];
}


/**
 更新用户认证状态
 */
- (void)getCertificationInfo {
    _verify_remark = SF_USER.authStatus.verify_remark;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"UserId"] = USER_ID;
    [[SFNetworkManage shared] postWithPath:@"Certificate/GetCertificateInfo"
                                    params:params
                                   success:^(id result)
    {
        SFAuthStatusModle *auth = [SFAuthStatusModle mj_objectWithKeyValues:result];
        
        SFUserInfo *info = SF_USER;
        info.authStatus = auth;
        info.verify_status = auth.verify_status;
        [info saveUserInfo];
        
        _verify_remark = auth.statusDesc;
        self.authStatus  = auth;
        if (SF_USER.role == SFUserRoleCarownner) {
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
        } else if (SF_USER.role == SFUserRoleGoodsownner) {
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
        }
        
        [_headerView reloadData];

    } fault:^(SFNetworkError *err) {

    }];
    
    
}



#pragma mark - 布局
- (void)setupView {
    self.fd_prefersNavigationBarHidden = YES;
    _bjView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.5)];
    _bjView.clipsToBounds = YES;
    _bjView.contentMode = UIViewContentModeScaleToFill;
    [_bjView setImage:[UIImage imageNamed:@"Personal_BJ"]];
    [self.view addSubview:_bjView];
    
    CGFloat scale = 335.0 / 191.0;
    CGFloat contentHeight = (SCREEN_WIDTH - 40) / scale;
    _headerView = [[SFPersonalCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, contentHeight + 64 + 30 + STATUSBAR_HEIGHT)];
    _headerView.backgroundColor = [UIColor clearColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#endif
    
    [_tableView registerClass:[SFPersonCenterCell class] forCellReuseIdentifier:PersonalCenterCellReusedID];
}

- (void)setupNav {
    SFPersonalNavBar *bar = [[SFPersonalNavBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 + STATUSBAR_HEIGHT)];
    [bar setNavBarStyle:(BarStyle_White)];
    bar.delegate = self;
    self.navBar = bar;
    [self.view addSubview:bar];
}

#pragma mark - bar Action
- (void)SFPersonalNavBar:(SFPersonalNavBar *)navBar didClickBlackButton:(UIButton *)backButton {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)SFPersonalNavBar:(SFPersonalNavBar *)navBar didClickSettingButton:(UIButton *)settingButton {
    NSLog(@"设置按钮");
    SFPersonSettingController *set = [[SFPersonSettingController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

- (void)SFPersonalNavBar:(SFPersonalNavBar *)navBar didClickMessageButton:(UIButton *)messageButton {
    MessageCenterController *message = [[MessageCenterController alloc] init];
    [self.navigationController pushViewController:message animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseViewController *vc;
    
    if (SF_USER.role == SFUserRoleCarownner) {
        switch (indexPath.row) {
            case 0 :{
                NSLog(@"我的物源");
                vc = [[SFProvenanceViewController alloc] init];
                break;
            }
            case 1:
                NSLog(@"我的司机");
                vc = [[SFMyDriverListController alloc] init];
                break;
            case 2:
                NSLog(@"我的车辆");
                vc = [[SFCarListViewController alloc] init];
                break;
            case 3:
                NSLog(@"信誉认证");
                [self toAuthVc];
                return;
                break;
            case 4:
                NSLog(@"个人资料");
                vc = [[SFPersonSettingController alloc] init];
                break;
            case 5:
                NSLog(@"退出");
                [self logout];
                return;
            default:
                return;
        }
    } else {
        switch (indexPath.row) {
            case 0 :{
                NSLog(@"我的物源");
                vc = [[SFProvenanceViewController alloc] init];
                break;
            }
            case 1:
                NSLog(@"信誉认证");
                [self toAuthVc];
                return;
                break;
            case 2:
                NSLog(@"个人资料");
                vc = [[SFPersonSettingController alloc] init];
                break;
            case 3:
                NSLog(@"退出");
                [self logout];
                return;
            default:
                return;
        }
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[[SFTipsView alloc] init] showFailureWithTitle:@"功能暂未开放"];
    }
    
}

- (void)toAuthVc {
    if (!self.authStatus.status || self.authStatus.status  == SFAuthStatusRefuse) { // status = waiting | refuse or status = nil
        SFAuthStatuViewController *vc = [[SFAuthStatuViewController alloc] initWithType:SFAuthTypeUser Status:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SFAuthStatuViewController *vc = [[SFAuthStatuViewController alloc] initWithType:SFAuthTypeUser Status:self.authStatus];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFPersonCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalCenterCellReusedID];
    if (indexPath.row == 3 && SF_USER.role == SFUserRoleCarownner) {
        [cell setTitleStr:self.titleArray[indexPath.row] andSubTitleStr:_verify_remark];

    } else if (indexPath.row == 1 && SF_USER.role == SFUserRoleGoodsownner) {
        [cell setTitleStr:self.titleArray[indexPath.row] andSubTitleStr:_verify_remark];

    } else {
            [cell setTitleStr:self.titleArray[indexPath.row] andSubTitleStr:@""];
        }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y <= 50) {
        [self.navBar setNavBarStyle:(BarStyle_White)];
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:NO];
    } else {
        [self.navBar setNavBarStyle:(BarStyle_Black)];
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:NO];
    }
    
    if (y < maxDistance) {
        CGFloat alpha = y / maxDistance;
        alpha = alpha < 0 ? 0 : alpha;
        self.navBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
        [self.navBar setLineViewHidden:YES];
    } else {
        self.navBar.backgroundColor = [UIColor whiteColor];
        [self.navBar setLineViewHidden:NO];
    }
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        if (SF_USER.role == SFUserRoleCarownner) {
            _titleArray = [NSMutableArray mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"CarownerList" ofType:@"plist"]];
        } else {
            _titleArray = [NSMutableArray mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"GoodsownerList" ofType:@"plist"]];
        }
    }
    return _titleArray;
}

@end
