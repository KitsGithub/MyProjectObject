//
//  SFCarListViewController.m
//  SFLIS
//
//  Created by kit on 2017/10/30.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarListViewController.h"
#import "SFCarListCell.h"

#import "SFAuthStatuViewController.h"

static NSString *CarListCellReusedID = @"CarListCellReusedID";

@interface SFCarListViewController () <UITableViewDelegate,UITableViewDataSource,SFCarListCellDelegate,FMDB_Manager_DataSource>

@property (nonatomic, strong) NSMutableArray <SFCarListModel *>*dataArray;

@end

@implementation SFCarListViewController{
    UITableView *_tableView;
    
    UIButton *_addCarDriver;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self CreatDB];
    [self setNav];
    [self setupView];
    [self requestCarList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCarList {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"UserId"] = [SFAccount currentAccount].user_id;
    [[SFNetworkManage shared] postWithPath:@"CarTeam/GetMyCarList"
                                    params:params
                                   success:^(id result)
    {
        for (NSMutableDictionary *dic in result) {
            SFCarListModel *model = [SFCarListModel mj_objectWithKeyValues:dic];
            SFAuthStatusModle *status = [SFAuthStatusModle mj_objectWithKeyValues:dic];
            model.authStatus = status;
            [self.dataArray addObject:model];
        }
        
        [_tableView reloadData];
        
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
}

- (void)deletedCar:(SFCarListModel *)model withIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"Guid"] = model.car_id;
    [[SFNetworkManage shared] postWithPath:@"CarTeam/DeleteCar"
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

#pragma mark - DB Operation
- (void)CreatDB {
    FMDB_Manager *manager = [FMDB_Manager shareManager];
    manager.dataSource = self;
    [manager creatTableIfNotExistWithModelClass:[SFCarListModel class] callBack:^(BOOL success) {
        if (success) {
            NSLog(@"创建成功");
        }
    }];
}

- (NSString *)tableNameWithModelClass:(id)Class {
    return @"SFWL_MyCarListTable";
}

- (void)saveListToDB {
    
}

#pragma mark - UIAction
- (void)addCar {
//    SFAuthStatusModle *statusModel = [SFAccount currentAccount].authStatus;
//    if (![statusModel.verify_status isEqualToString:@"B"]) { //审核中
//        [[[UIAlertView alloc] initWithTitle:@"您的认证信息正在审核中，请耐心等候。" message:@"注意：只有认证后的用户才可进行添加车辆！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
//        return;
//    } else if ([statusModel.verify_status isEqualToString:@"F"]) {  //审核失败
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的认证信息未通过，请前往重新提交" message:@"注意：只有认证后的用户才可进行添加车辆！" preferredStyle:(UIAlertControllerStyleAlert)];
//
//        __weak typeof(self)wself = self;
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//            SFAuthStatuViewController *authView  = [[SFAuthStatuViewController alloc] initWithType:SFAuthTypeUser Status:[SFAccount currentAccount].authStatus];
//            [wself.navigationController pushViewController:authView animated:YES];
//
//        }];
//
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
//
//        [alert addAction:action1];
//        [alert addAction:action2];
//        [self.navigationController presentViewController:alert animated:YES completion:^{}];
//        return;
//    } else if ([statusModel.verify_status isEqualToString:@"C"]) {  //未审核
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的认证信息尚未提交，请前往审核" message:@"注意：只有认证后的用户才可进行添加车辆！" preferredStyle:(UIAlertControllerStyleAlert)];
//
//        __weak typeof(self)wself = self;
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//            SFAuthStatuViewController *authView  = [[SFAuthStatuViewController alloc] initWithType:SFAuthTypeUser Status:[SFAccount currentAccount].authStatus];
//            [wself.navigationController pushViewController:authView animated:YES];
//
//        }];
//
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
//
//        [alert addAction:action1];
//        [alert addAction:action2];
//        [self.navigationController presentViewController:alert animated:YES completion:^{}];
//        return;
//    }
    
    [self jumpToSFAuth:nil];
    
//    SFAddCarsViewController *addCar = [[SFAddCarsViewController alloc] init];
//    [self.navigationController pushViewController:addCar animated:YES];
}

- (void)SFCarListCell:(SFCarListCell *)cell didSelectedOptionsWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (index == 0) {
        [self deletedCar:cell.model withIndexPath:indexPath];
    } else {
        if ([cell.model.verify_status isEqualToString:@"D"]) {
            //认证成功
            [self jumpToSFAuth:cell.model];
            
        } else if ([cell.model.verify_status isEqualToString:@"C"] || [cell.model.verify_status isEqualToString:@""]) {
            //等待认证
            if (index == 0) {
//                [self deletedDirver:cell.model withIndexPath:indexPath];
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
}

//跳转到认证页面
- (void)jumpToSFAuth:(SFCarListModel *)model {
    __weak typeof(self) weakSelf = self;
    SFAuthStatuViewController *authView  = [[SFAuthStatuViewController alloc]initWithType:(SFAuthTypeCarOwnner) Status:model.authStatus];
    authView.type = SFAuthTypeCar;
    authView.guid  = model.car_id;
    [authView setReturnBlock:^{
        [weakSelf requestCarList];
    }];
    [self.navigationController pushViewController:authView animated:YES];
}


#pragma mark - 布局
- (void)setNav {
    [super setCustomTitle:@"我的车辆"];
    BaseNavigationController *nav = (BaseNavigationController *)self.navigationController;
    [nav SetBottomLineViewHiden:NO];
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - 50) style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFCarListCell class] forCellReuseIdentifier:CarListCellReusedID];
    
    _addCarDriver = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    [_addCarDriver setBackgroundColor:THEMECOLOR];
    [_addCarDriver setTitle:@"➕ 添加车辆" forState:(UIControlStateNormal)];
    [_addCarDriver setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    _addCarDriver.titleLabel.font = [UIFont systemFontOfSize:18];
    [_addCarDriver addTarget:self action:@selector(addCar) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_addCarDriver];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:CarListCellReusedID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
}

- (NSMutableArray<SFCarListModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
