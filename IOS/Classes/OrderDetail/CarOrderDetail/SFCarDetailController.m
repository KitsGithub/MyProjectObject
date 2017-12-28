//
//  SFCarDetailController.m
//  SFLIS
//
//  Created by kit on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarDetailController.h"

//跳转
#import "SFBookingCarOrderViewController.h"
#import "SFAuthStatuViewController.h"

//自定义控件
#import "SFCarDetailHeaderView.h"
#import "SFCarDetailFooterView.h"
#import "SFCarDetailCell.h"

static NSString *CARDETAILCELL_ID = @"CARDETAILCELLID";

@interface SFCarDetailController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SFCarOrderDetailModel *carDetailModel;

@property (nonatomic, strong) NSMutableArray <SFCarListModel *>*dataArray;

@end

@implementation SFCarDetailController {
    UITableView *_tableView;
    SFCarDetailHeaderView *_headerView;
    SFCarDetailFooterView *_footerView;
}

- (instancetype)initWithOrderID:(NSString *)orderID {
    if (self = [super init]) {
        _orderID = orderID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    [self setupView];
    [self requestCarOrderDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCarOrderDetail {
    if (self.orderID.length) {
        [SFLoaddingView loaddingToView:self.view];
        [[SFNetworkManage shared] postWithPath:@"Cars/GetCarDetails"
                                        params:@{
                                                 @"Guid" : self.orderID
                                                 }
                                       success:^(id result)
         {
             [SFLoaddingView dismiss];
             SFCarOrderDetailModel *model = [SFCarOrderDetailModel mj_objectWithKeyValues:result];
             self.carDetailModel = model;
             
             self.dataArray = model.car_info;
             
             _headerView.model = model;
             _footerView.remark = model.car_remark;
             
             [_tableView reloadData];
         } fault:^(SFNetworkError *err) {
             [[SFTipsView shareView] showFailureWithTitle:@"请检查网络"];
             __weak typeof(self) weakSelf = self;
             [SFLoaddingView showResultWithResuleType:(SFLoaddingResultType_LoaddingFail) toView:self.view reloadBlock:^{
                 [weakSelf requestCarOrderDetail];
             }];
         }];
    }
}


- (void)BookingCarOrder {
    __weak typeof(self) weasSelf = self;
    if (![SF_USER.verify_status isEqualToString:@"D"]) {
        UIAlertController *alertVc;
        UIAlertAction *action1;
        UIAlertAction *action2;
        if ([SF_USER.verify_status isEqualToString:@"B"]) {
            alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您提交的认证资料正在审核，请耐心等待" preferredStyle:(UIAlertControllerStyleAlert)];
            action1 = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        } else {
            alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未进行身份认证，请先去认证" preferredStyle:(UIAlertControllerStyleAlert)];
            action1 = [UIAlertAction actionWithTitle:@"下次再说" style:(UIAlertActionStyleCancel) handler:nil];
            action2 = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                SFAuthStatuViewController *auth = [[SFAuthStatuViewController alloc] initWithType:(SFAuthTypeUser) Status:SF_USER.authStatus];
                auth.hidesBottomBarWhenPushed = YES;
                [weasSelf.navigationController pushViewController:auth animated:YES];
            }];
        }
        
        [alertVc addAction:action1];
        if (action2) {
            [alertVc addAction:action2];
        }
        
        
        [self presentViewController:alertVc animated:YES completion:nil];
        return;
    }
    SFBookingCarOrderViewController *booking = [[SFBookingCarOrderViewController alloc] init];
    booking.orderId = self.orderID;
    booking.carListArray = [self.dataArray copy];
    [self.navigationController pushViewController:booking animated:YES];
}

#pragma mark - 布局
- (void)setupNav {
    self.title = @"车源详情";
}
- (void)setupView {
    CGFloat buttonHeight = 0;
    if (!self.showType) {
        buttonHeight = 50;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44 - buttonHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFCarDetailCell class] forCellReuseIdentifier:CARDETAILCELL_ID];
    [self.view addSubview:_tableView];
    
    _headerView = [[SFCarDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    _tableView.tableHeaderView = _headerView;
    
    
    _footerView = [[SFCarDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
    _tableView.tableFooterView = _footerView;
    
    if (buttonHeight) {
        UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        [footer setTitle:@"预定" forState:(UIControlStateNormal)];
        [footer setBackgroundColor:THEMECOLOR];
        [footer setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
        [footer addTarget:self action:@selector(BookingCarOrder) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:footer];
    }
    
    
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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCarListModel *model = self.dataArray[indexPath.row];
    SFCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CARDETAILCELL_ID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}


- (NSMutableArray<SFCarListModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
