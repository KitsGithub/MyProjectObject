//
//  AddCarrierDriverController.m
//  SFLIS
//
//  Created by kit on 2017/11/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "AddCarrierDriverController.h"
#import "SFAddCarrierDriverCell.h"


static NSString *SFAddCarrierDriverCellReusedID = @"SFAddCarrierDriverCell";

@interface AddCarrierDriverController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AddCarrierDriverController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupView];
    [self setupNav];
    [self getIdentflyDriver];
}


/**
 获取已认证的司机列表
 */
- (void)getIdentflyDriver {
    [[SFNetworkManage shared] postWithPath:@"Driver/GetPassedDriverList"
                                    params:@{
                                             @"UserId" : USER_ID
                                             }
                                   success:^(id result)
    {
        
        self.dataArray = [SFDriverModel mj_objectArrayWithKeyValuesArray:result];
        [_tableView reloadData];
        
        
    } fault:^(SFNetworkError *err) {
        
    }];
}

- (void)saveDriver {
    
    NSMutableArray *drivers = [NSMutableArray array];
    NSArray *cellArray = _tableView.visibleCells;
    for (SFAddCarrierDriverCell *cell in cellArray) {
        if (cell.selectedDriver) {
            [drivers addObject:cell.driverModel];
        }
    }
    
    if (!drivers.count) {
        [[SFTipsView shareView] showFailureWithTitle:@"请选择至少一个司机"];
        return;
    }
    
    if (self.returnBlock) {
        self.returnBlock(drivers);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    [self setCustomTitle:@"添加司机"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveDriver)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[SFAddCarrierDriverCell class] forCellReuseIdentifier:SFAddCarrierDriverCellReusedID];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFAddCarrierDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:SFAddCarrierDriverCellReusedID forIndexPath:indexPath];
    cell.driverModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
