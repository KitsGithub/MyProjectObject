//
//  SFDriverTransportDetailController.m
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDriverTransportDetailController.h"
#import "SFSegmentView.h"
#import "SFDriverSignAlerView.h"
#import "SFTransportCell.h"

#import "SFTransportDetailController.h"

static NSString *TransportDetailCellReusedID = @"TransportDetailCellReusedID";

@interface SFDriverTransportDetailController () <UITableViewDelegate,UITableViewDataSource,SFTransportCellDelegate>

@property (nonatomic, assign) DataType dataType;

@end

@implementation SFDriverTransportDetailController {
    UITableView *_tableView;
    SFSegmentView *_segment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self setNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAction
- (void)SFTransportCell:(SFTransportCell *)cell didSelectedButtonAtIndex:(NSInteger)index {
    if (index == 0) {
        NSLog(@"详情");
        [self jumpToTransportDetail:cell];
    } else if (index == 1) {
        NSLog(@"送达");
    } else if (index == 2) {
        NSLog(@"签到");
        [self showSignAlertView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTransportCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self jumpToTransportDetail:cell];
}

- (void)showSignAlertView {
    [[[SFDriverSignAlerView alloc] init] showAnimation];
}

- (void)jumpToTransportDetail:(SFTransportCell *)cell {
    SFTransportDetailController *detail = [[SFTransportDetailController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setup
- (void)setNav {
    self.dataType = DataType_Transprot;
    
    __weak typeof(self) wself = self;
    __weak typeof(_tableView) wTableView = _tableView;
    _segment   = [[SFSegmentView alloc] initWithFrame:CGRectMake(0, 0, 30 + 64 + 64 + 15*2, 44) items:@[@"待运输",@"已到货"] font:[UIFont systemFontOfSize:16]];
    _segment.lineWidth  = 80;
    _segment.selectedBlock = ^(NSInteger index) {
        wself.dataType = index;
        [wTableView reloadData];
    };
    self.navigationItem.titleView  = _segment;
    
    self.navigationItem.backBarButtonItem.action = @selector(backAction);
}

- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SFTransportCell class] forCellReuseIdentifier:TransportDetailCellReusedID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
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
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTransportCell *cell = [tableView dequeueReusableCellWithIdentifier:TransportDetailCellReusedID forIndexPath:indexPath];
    cell.dataType = self.dataType;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.dataType) {
        case DataType_Transprot:
            return 296;
        case DataType_Finished:
            return 222;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


@end
