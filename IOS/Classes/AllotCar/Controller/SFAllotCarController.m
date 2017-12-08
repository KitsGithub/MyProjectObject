//
//  SFAllotCarController.m
//  SFLIS
//
//  Created by kit on 2017/11/14.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAllotCarController.h"

#import "SFAllotCarrierCell.h"
#import "SFCarrierModel.h"
#import "SFAddCarrierCarController.h"

static NSString *AllotCarrierCellID = @"SFAllotCarrierCell";

@interface SFAllotCarController () <UITableViewDelegate,UITableViewDataSource,SFAllotCarrierCellDelegate>

@property (nonatomic, strong) NSMutableArray <SFCarrierModel *>*dataArray;

@end

@implementation SFAllotCarController {
    UITableView *_tableView;
    UIButton *_addCarrier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"匹配车辆/司机";
    [self setupView];
    [self getCarrierList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma mark - Networking
- (void)getCarrierList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OrderId"] = self.orderId;
    [[SFNetworkManage shared] postWithPath:@"Order/GetOrderDriverAndCar"
                                    params:params
                                   success:^(id result)
    {
        [_tableView.mj_header endRefreshing];
        self.dataArray = [SFCarrierModel mj_objectArrayWithKeyValuesArray:result];
        [_tableView reloadData];
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:@"获取分配车辆/司机列表失败"];
    }];
}

- (void)delCarrierWithCell:(SFAllotCarrierCell *)cell {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OrderId"] = self.orderId;
    params[@"CarNo"] = cell.model.carNum;
    
    [[SFNetworkManage shared] postWithPath:@"Order/DeleteDriverAndCarByOrder"
                                    params:params
                                   success:^(id result)
    {
        [[SFTipsView shareView] showSuccessWithTitle:@"删除成功"];
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        [self.dataArray removeObjectAtIndex:indexPath.section];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
        
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:@"删除失败"];
    }];
    
    
}

- (void)setFistCar:(SFAllotCarrierCell *)cell {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OrderId"] = self.orderId;
    params[@"CarNo"] = cell.model.carNum;
    params[@"DriverId"] = cell.model.driver_id;
    [[SFNetworkManage shared] postWithPath:@"/Order/SetFirstCar"
                                    params:params
                                   success:^(id result)
    {
        if (result) {
            [[SFTipsView shareView] showSuccessWithTitle:@"设置成功"];
            
            
            
        } else {
            [[SFTipsView shareView] showFailureWithTitle:@"设置失败"];
        }
        
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
}

#pragma mark - UIAction
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFAllotCarrierCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self eddittingCarrier:cell.model];
}

/**
 跳转到编辑承运人界面
 */
- (void)eddittingCarrier:(SFCarrierModel *)model {
    SFAddCarrierCarController *add = [[SFAddCarrierCarController alloc] init];
    if (model) {
        [add setCustomTitle:@"编辑司机/车辆"];
        add.model = model;
    } else {
        [add setCustomTitle:@"添加司机/车辆"];
    }
    
    __weak typeof(self) weakSelf = self;
    [add setSuccessRetrun:^{
        [weakSelf getCarrierList];
    }];
    add.orderId = self.orderId;
    [self.navigationController pushViewController:add animated:YES];
}


/**
 添加司机/车辆
 */
- (void)addCarrier {
    [self eddittingCarrier:nil];
}

- (void)SFAllotCarrierCell:(SFAllotCarrierCell *)cell didSelectedButtonWithIndex:(NSInteger)index {
    [self eddittingCarrier:cell.model];
}

- (void)SFAllotCarrierCell:(SFAllotCarrierCell *)cell didSelectedOptionsWithIndex:(NSInteger)index {
    if (index == 0) {
        NSLog(@"设置首发车辆");
        [self setFistCar:cell];
    } else {
        NSLog(@"删除车辆");
        [self delCarrierWithCell:cell];
        
    }
}

#pragma mark - layout
- (void)setupView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFAllotCarrierCell class] forCellReuseIdentifier:AllotCarrierCellID];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCarrierList];
    }];
    
    _addCarrier = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    [_addCarrier setBackgroundColor:THEMECOLOR];
    [_addCarrier setTitle:@"➕ 添加车辆/司机" forState:(UIControlStateNormal)];
    [_addCarrier setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    _addCarrier.titleLabel.font = [UIFont systemFontOfSize:18];
    [_addCarrier addTarget:self action:@selector(addCarrier) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_addCarrier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFAllotCarrierCell *cell = [tableView dequeueReusableCellWithIdentifier:AllotCarrierCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    cell.enableEdditting = YES;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}




- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
