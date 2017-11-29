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
    
    [self setTitle:@"选择车辆"];
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
        
        self.dataArray = [SFCarListModel mj_objectArrayWithKeyValuesArray:result];
        [_tableView reloadData];
        
        
    } fault:^(SFNetworkError *err) {
        
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *cellArray = tableView.visibleCells;
    for (SFChooseCarCell *cell in cellArray) {
        [cell showTickImage:YES];
    }
    
    SFChooseCarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell showTickImage:NO];
    
    if (self.resultReturnBlock) {
        self.resultReturnBlock(cell.model.car_id,cell.model.car_no);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView {
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
    SFCarListModel *model = self.dataArray[indexPath.row];
    if ([self.selectedNum isEqualToString:model.car_no]) {
        [cell showTickImage:NO];
    }
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
