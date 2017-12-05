//
//  SFChooseCarrierCarController.m
//  SFLIS
//
//  Created by kit on 2017/11/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFChooseCarrierCarController.h"
#import "SFChooseCarCell.h"

static NSString *ChooseCarCellReusedID = @"ChooseCarCellReusedID";

@interface SFChooseCarrierCarController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFChooseCarrierCarController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self getIdentflyCarList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getIdentflyCarList {
    [[SFNetworkManage shared] postWithPath:@"Cars/GetCarNoList"
                                    params:@{
                                             @"UserId" : USER_ID
                                             }
                                   success:^(id result)
    {
        NSMutableArray *dataArray = [SFCarListModel mj_objectArrayWithKeyValuesArray:result];
        
        self.dataArray = [self screenDataFromArray:dataArray];
        
        [_tableView reloadData];
        
        
    } fault:^(SFNetworkError *err) {
        
    }];
}


/**
 筛选数据
 */
- (NSMutableArray *)screenDataFromArray:(NSArray *)dataArray {
    NSMutableArray *targetArray = [NSMutableArray array];
    for (SFCarListModel *model in dataArray) {
        BOOL isEqure = NO;
        if (!self.selectedCarArray.count) {
            [targetArray addObjectsFromArray:dataArray];
            break;
        }
        for (NSString *carNum in self.selectedCarArray) {
            if ([model.car_no isEqualToString:carNum]) {
                isEqure = YES;
                break;
            }
        }
        if (!isEqure) {
            [targetArray addObject:model];
        }
    }
    return targetArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeMode == TypeMode_SingleChooser) {
        NSArray *cellArray = tableView.visibleCells;
        for (SFChooseCarCell *cell in cellArray) {
            [cell showTickImage:NO];
        }
        
        SFChooseCarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell showTickImage:YES];
        [cell setTickChoose];
        if (self.resultReturnBlock) {
            self.resultReturnBlock(@[cell.model]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        SFChooseCarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setTickChoose];
        
    }
    
}

- (void)comfirmButtonClick {
    if (self.resultReturnBlock) {
        NSArray *cellArray = _tableView.visibleCells;
        NSMutableArray *selectedArray = [NSMutableArray array];
        for (SFChooseCarCell *cell in cellArray) {
            if (cell.SFSelected) {
                [selectedArray addObject:cell.model];
            }
        }
        self.resultReturnBlock([self screenDataFromArray:selectedArray]);
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView {
    
    self.title = @"选择车辆";
    if (self.typeMode != TypeMode_SingleChooser) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(comfirmButtonClick)];
        
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[SFChooseCarCell class] forCellReuseIdentifier:ChooseCarCellReusedID];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFChooseCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseCarCellReusedID forIndexPath:indexPath];
    cell.type = self.typeMode;
    SFCarListModel *model = self.dataArray[indexPath.row];
    for (NSString *targetStr in self.selectedCarArray) {
        if ([targetStr isEqualToString:model.car_no]) {
            [cell showTickImage:YES];
            [cell setTickChoose];
        }
    }
    
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


#pragma mark - lazyLoad
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedCarArray {
    if (!_selectedCarArray) {
        _selectedCarArray = [NSMutableArray array];
    }
    return _selectedCarArray;
}

@end
