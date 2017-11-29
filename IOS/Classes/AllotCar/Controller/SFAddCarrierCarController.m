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

#import "AddCarryController.h"
#import "SFChooseCarrierCarController.h"

static NSString *AddCarrierCellReusedID = @"AddCarrierCellReusedID";

@interface SFAddCarrierCarController () <UITableViewDelegate,UITableViewDataSource,SFAllotCarrierCellDelegate>

@property (nonatomic, strong) NSMutableArray <NSString *>*carNumArray;

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
    
    [self getUserIdentiflyCar];
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

/**
 获取所有认证车辆
 */
- (void)getUserIdentiflyCar {
    [[SFNetworkManage shared] postWithPath:@"cars/GetCarNoList"
                                    params:@{@"UserId" : USER_ID}
                                   success:^(id result)
     {
         NSArray *objecArray = result;
         if (objecArray.count) {
             for (NSMutableDictionary *dic in objecArray) {
                 [self.carNumArray addObject:dic[@"car_no"]];
             }
         }
         
     } fault:^(SFNetworkError *err) {
         
     }];
}

#pragma mark - UIAction
- (void)saveCarrier {
    
    [[SFNetworkManage shared] post:@"Order/GetOrderDriverAndCar"
                            params:@{}
                           success:^(id result)
    {
        
        
    } fault:^(SFNetworkError *err) {
        
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
    [driver setBlock:^(NSString *driverStr) {
        weakSelf.model.driver_by = driverStr;
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:driver animated:YES];
}

/**
 编辑 or 新增车辆
 */
- (void)chooseCarNum {
    SFChooseCarrierCarController *car = [[SFChooseCarrierCarController alloc] init];
    car.selectedNum = self.model.carNum;
    [car setResultReturnBlock:^(NSString *carId, NSString *carNum) {
        if (!self.model) {
            self.model = [SFCarrierModel new];
            self.model.car_no = carNum;
        } else {
            self.model.car_no = carNum;
        }
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

- (NSMutableArray<NSString *> *)carNumArray {
    if (!_carNumArray) {
        _carNumArray = [NSMutableArray array];
    }
    return _carNumArray;
}

@end
