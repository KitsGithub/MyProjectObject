//
//  SFTransportLocationController.m
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFTransportDetailController.h"

#import "SFTransportDetailCell.h"
static NSString *TransportDetailCellReusedID = @"TransportDetailCellReusedID";

@interface SFTransportDetailController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <SFSignInfoModel *>*dataArray;

@end

@implementation SFTransportDetailController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomTitle:@"详情"];
    
    [self setupView];
    [self requestDetailWithAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestDetailWithAnimation:(BOOL)animation {
    if (animation) {
        [SFLoaddingView loaddingToView:self.view];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OrderId"] = self.orderId;
    params[@"CarNo"] = self.carNo;
    [[SFNetworkManage shared] postWithPath:@"/Driver/GetDriverTransport"
                                    params:params
                                   success:^(id result)
    {
        NSMutableArray *dataArray = [SFSignInfoModel mj_objectArrayWithKeyValuesArray:result];
        [_tableView.mj_header endRefreshing];
        if (!dataArray.count) {
            [SFLoaddingView showResultWithResuleType:(SFLoaddingResultType_NoMoreData) toView:self.view reloadBlock:nil];
        }
        [SFLoaddingView dismiss];
        self.dataArray = dataArray;
        [_tableView reloadData];
        
    } fault:^(SFNetworkError *err) {
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [_tableView registerClass:[SFTransportDetailCell class] forCellReuseIdentifier:TransportDetailCellReusedID];
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
        [weakSelf requestDetailWithAnimation:NO];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTransportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TransportDetailCellReusedID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.currentLoacted = YES;
    } else {
        cell.currentLoacted = NO;
    }
    
    if (indexPath.row == self.dataArray.count - 1 ) {
        cell.showLineView = NO;
    } else {
        cell.showLineView = YES;
    }
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
