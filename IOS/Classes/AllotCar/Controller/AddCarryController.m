//
//  AddCarryDriverController.m
//  SFLIS
//
//  Created by kit on 2017/11/16.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "AddCarryController.h"

#import "AddCarrierDriverController.h"
#import "DelCarrierDriverViewController.h"

static NSString *AddCarrierDriverCellReusedID = @"AddCarrierDriverCellReusedID";

@interface AddCarryController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSString *drivers;

@property (nonatomic, strong) NSMutableArray *driverIds;

@end

@implementation AddCarryController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self setCustomTitle:@"匹配司机"];
    [self setupView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *driver = @"";
    for (NSString *str in self.driverArray) {
        driver = [driver stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
        if (![str isEqualToString:self.driverArray.lastObject]) {
            driver = [driver stringByAppendingString:@","];
        }
    }
    self.drivers = driver;
}

- (void)addDriver {
    __weak typeof(self) weakSelf = self;
    AddCarrierDriverController *add = [[AddCarrierDriverController alloc] init];
    [add setReturnBlock:^(NSMutableArray <SFDriverModel *>*drivers) {
        NSMutableArray *driverArray = [NSMutableArray array];
        NSMutableArray *driverIds = [NSMutableArray array];
        NSString *driverStr = @"";
        for (SFDriverModel *model in drivers) {
            [driverArray addObject:model.driver_by];
            [driverIds addObject:model.guid];
            driverStr = [driverStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.driver_by]];
        }
        weakSelf.driverIds = driverIds;
        weakSelf.drivers = driverStr;
        weakSelf.driverArray = driverArray;
        
        [[SFTipsView shareView] showSuccessWithTitle:@"新增司机成功"];
        [_tableView reloadData];
        
    }];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)delDriver {
    DelCarrierDriverViewController *del = [[DelCarrierDriverViewController alloc] init];
    [self.navigationController pushViewController:del animated:YES];
}

- (void)backAction {
    if (self.block) {
        self.block(self.drivers,self.driverIds);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView {
    self.title = @"匹配司机";
//    self.navigationController.navigationItem.backBarButtonItem.action = @selector(backAction);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AddCarrierDriverCellReusedID];
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomView];
    UIButton *addDriver = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 50)];
    [addDriver addTarget:self action:@selector(addDriver) forControlEvents:(UIControlEventTouchUpInside)];
    [addDriver setTitle:@"添加/删除司机" forState:(UIControlStateNormal)];
    [addDriver setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    addDriver.titleLabel.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:addDriver];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, 14, 1, 22)];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
//    [bottomView addSubview:lineView];
//
//    UIButton *delDriver = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, 0, SCREEN_WIDTH * 0.5, 50)];
//    [delDriver addTarget:self action:@selector(delDriver) forControlEvents:(UIControlEventTouchUpInside)];
//    [delDriver setTitle:@"删除司机" forState:(UIControlStateNormal)];
//    [delDriver setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
//    delDriver.titleLabel.font = [UIFont systemFontOfSize:18];
//    [bottomView addSubview:delDriver];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.driverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCarrierDriverCellReusedID forIndexPath:indexPath];
    
    cell.textLabel.font = FONT_COMMON_16;
    cell.textLabel.text = self.driverArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = COLOR_TEXT_COMMON;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (NSMutableArray *)driverIds {
    if (!_driverIds) {
        _driverIds = [NSMutableArray array];
    }
    return _driverIds;
}

@end
