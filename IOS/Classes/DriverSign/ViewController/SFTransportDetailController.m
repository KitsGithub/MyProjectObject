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

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFTransportDetailController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomTitle:@"详情"];
    
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (NSInteger index = 0; index < 10; index++) {
            [_dataArray addObject:@(index)];
        }
    }
    return _dataArray;
}

@end
