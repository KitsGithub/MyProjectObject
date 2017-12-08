//
//  SFAddCarrierCarController.m
//  SFLIS
//
//  Created by kit on 2017/11/15.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAddCarrierCarController.h"
#import "SFAllotCarrierCell.h"

#import "SFCarrierModel.h"
#import "SFCarListModel.h"

#import "AddCarryController.h"
#import "SFChooseCarrierCarController.h"

static NSString *AddCarrierCellReusedID = @"AddCarrierCellReusedID";

@interface SFAddCarrierCarController () <UITableViewDelegate,UITableViewDataSource,SFAllotCarrierCellDelegate>

@property (nonatomic, strong) NSMutableArray <NSString *>*driverIds;
@end

@implementation SFAddCarrierCarController {
    UITableView *_tableView;
    BOOL _isChange;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveCarrier)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.backBarButtonItem.action = @selector(backAction);
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    if (_isChange) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你有修改操作，需要保存吗？" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确认保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"保存");
            [weakSelf saveCarrier];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续退出" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:saveAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIAction
- (void)saveCarrier {
    if (!self.model.carNum) {
        [[SFTipsView shareView] showFailureWithTitle:@"请选择车牌"];
        return;
    }
    
    if (!self.driverIds.count) {
        [[SFTipsView shareView] showFailureWithTitle:@"请分配司机"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OrderId"] = self.orderId;
    params[@"CarNo"] = self.model.carNum;
    params[@"DriverIds"] = self.driverIds;
    [[SFNetworkManage shared] postWithPath:@"Order/AddDriverAndCarByOrder"
                                    params:params
                                   success:^(id reslut)
    {
        [[SFTipsView shareView] showSuccessWithTitle:@"分配成功"];
        if (self.successRetrun) {
            self.successRetrun();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:@"分配成功"];
    }];
    
}

- (void)SFAllotCarrierCell:(SFAllotCarrierCell *)cell didSelectedButtonWithIndex:(NSInteger)index {
    if (index == 1) {
        [self chooseCarNum];
    } else {
        [self addDriver];
    }
}


/**
 新增司机
 */
- (void)addDriver {
    __weak typeof(self) weakSelf = self;
    AddCarryController *driver = [[AddCarryController alloc] init];
    driver.driverArray = self.model.driverNameArray;
    [driver setBlock:^(NSString *driverStr,NSMutableArray *driverIds) {
        _isChange = YES;
        weakSelf.model.driver_by = driverStr;
        weakSelf.driverIds = driverIds;
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:driver animated:YES];
}

/**
 编辑 or 新增车辆
 */
- (void)chooseCarNum {
    SFChooseCarrierCarController *car = [[SFChooseCarrierCarController alloc] init];
    if (self.model) {
        car.selectedCarArray = [NSMutableArray arrayWithObjects:self.model.carNum, nil];
    }
    __weak typeof(self) weakSelf = self;
    [car setResultReturnBlock:^(NSArray<SFCarListModel *> *modelArray) {
        SFCarListModel *model = modelArray.firstObject;
        NSDictionary *modelDic = [model mj_keyValues];
        SFCarrierModel *carrier = [SFCarrierModel mj_objectWithKeyValues:modelDic];
        weakSelf.model = carrier;
        _isChange = YES;
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:car animated:YES];
}


#pragma mark - 布局
- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[SFAllotCarrierCell class] forCellReuseIdentifier:AddCarrierCellReusedID];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFAllotCarrierCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCarrierCellReusedID forIndexPath:indexPath];
    cell.enableEdditting = NO;
    cell.delegate = self;
    if (self.model) {
        cell.model = self.model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model) {
        return 300;
    }
    return 152;
}

- (NSMutableArray<NSString *> *)driverIds {
    if (!_driverIds) {
        _driverIds = [NSMutableArray array];
    }
    return _driverIds;
}
@end
