//
//  SFMyDriverListController.m
//  SFLIS
//
//  Created by kit on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFMyDriverListController.h"

//跳转
#import "SFAuthStatuViewController.h"

//自定义控件
#import "SFDriverListCell.h"

static NSString *DrivierListCellReusedID = @"DrivierListCellReusedID";

@interface SFMyDriverListController () <UITableViewDelegate,UITableViewDataSource,SFDriverListCellDelegate>


@property (nonatomic, strong) NSMutableArray <SFDriverModel *>*dataArray;

@end

@implementation SFMyDriverListController {
    UITableView *_tableView;
    
    UIButton *_addCarDriver;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav];
    [self setupView];
    [self requestDriverList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求司机列表
- (void)requestDriverList {
    SFUserInfo *account = SF_USER;
    [[SFNetworkManage shared]postWithPath:@"Driver/GetMyDriverList"
                                   params:@{
                                            @"UserId" : account.user_id
                                            }
                                  success:^(id result)
    {
        for (NSMutableDictionary *dic in result) {
            SFDriverModel *model = [SFDriverModel mj_objectWithKeyValues:dic];
            SFAuthStatusModle *status = [SFAuthStatusModle mj_objectWithKeyValues:dic];
            model.authStatus = status;
            [self.dataArray addObject:model];
        }
        
        [_tableView reloadData];
        
    } fault:^(SFNetworkError *err) {
        
    }];
}

//删除司机
- (void)deletedDirver:(SFDriverModel *)model withIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"Guid"] = model.driver_id;
    [[SFNetworkManage shared] postWithPath:@"Driver/DeleteDriver"
                                    params:params
                                   success:^(id result)
    {
        [[[SFTipsView alloc] init] showSuccessWithTitle:@"删除成功"];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        
    } fault:^(SFNetworkError *err) {
        [[[SFTipsView alloc] init] showSuccessWithTitle:@"删除失败"];
    }];
}

#pragma mark - UIAction
- (void)addDriver {
    
    SFAuthStatusModle *statusModel = SF_USER.authStatus;
    
    if ([statusModel.verify_status isEqualToString:@"B"]) {
        [[[UIAlertView alloc] initWithTitle:@"您的认证信息正在审核中，请耐心等候。" message:@"注意：只有认证后的用户才可进行添加司机！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
        return;
    } else if ([statusModel.verify_status isEqualToString:@"C"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的认证信息尚未提交，请前往审核" message:@"注意：只有认证后的用户才可进行添加司机！" preferredStyle:(UIAlertControllerStyleAlert)];
        
        __weak typeof(self)wself = self;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            SFAuthStatuViewController *authView  = [[SFAuthStatuViewController alloc] initWithType:SFAuthTypeUser Status:SF_USER.authStatus];
            [wself.navigationController pushViewController:authView animated:YES];
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:^{}];
        return;
    } else if ([statusModel.verify_status isEqualToString:@"F"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的认证信息未通过，请前往重新提交" message:@"注意：只有认证后的用户才可进行添加司机！" preferredStyle:(UIAlertControllerStyleAlert)];
        
        __weak typeof(self)wself = self;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            SFAuthStatuViewController *authView  = [[SFAuthStatuViewController alloc] initWithType:SFAuthTypeUser Status:SF_USER.authStatus];
            [wself.navigationController pushViewController:authView animated:YES];
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:^{}];
        return;
    }
    
    [self jumpToSFAuth:nil];
}

- (void)jumpToUserIdentfly {
    
}

- (void)SFDriverListCell:(SFDriverListCell *)cell didSelectedOptionsAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if ([cell.model.verify_status isEqualToString:@"D"]) {
        //认证成功
        [self jumpToSFAuth:cell.model];
        
    } else if ([cell.model.verify_status isEqualToString:@"C"] || [cell.model.verify_status isEqualToString:@""]) {
        //等待认证
        if (index == 0) {
            [self deletedDirver:cell.model withIndexPath:indexPath];
        } else {
            [self jumpToSFAuth:cell.model];
        }
        
    } else if ([cell.model.verify_status isEqualToString:@"B"]) {
        //审核中
        [self jumpToSFAuth:cell.model];
        
    } else {
        //认证失败
        [self jumpToSFAuth:cell.model];
    }
}

//跳转到认证页面
- (void)jumpToSFAuth:(SFDriverModel *)model {
    SFAuthStatuViewController *authView  = [[SFAuthStatuViewController alloc] initWithType:SFAuthTypeCarOwnner Status:model.authStatus];
    authView.guid = model.driver_id;
    [self.navigationController pushViewController:authView animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
/*    隐藏编辑司机
    SFAddDirvierController *driver = [[SFAddDirvierController alloc] init];
    driver.driverModel = self.dataArray[indexPath.row];

    __weak typeof(indexPath) copyIndexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    [driver setReturnBlock:^(SFDriverModel *newDriver) {
        [weakSelf.dataArray replaceObjectAtIndex:copyIndexPath.row withObject:newDriver];
        [_tableView reloadRowsAtIndexPaths:@[copyIndexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }];
    [self.navigationController pushViewController:driver animated:YES];
 */
}

#pragma mark - 布局
- (void)setNav {
    [super setCustomTitle:@"我的司机"];
    BaseNavigationController *nav = (BaseNavigationController *)self.navigationController;
    [nav SetBottomLineViewHiden:NO];
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - 50) style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFDriverListCell class] forCellReuseIdentifier:DrivierListCellReusedID];
    
    _addCarDriver = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    [_addCarDriver setBackgroundColor:THEMECOLOR];
    [_addCarDriver setTitle:@"➕ 添加司机" forState:(UIControlStateNormal)];
    [_addCarDriver setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    _addCarDriver.titleLabel.font = [UIFont systemFontOfSize:18];
    [_addCarDriver addTarget:self action:@selector(addDriver) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_addCarDriver];
    
}



#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFDriverListCell *cell = [tableView dequeueReusableCellWithIdentifier:DrivierListCellReusedID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSMutableArray<SFDriverModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
