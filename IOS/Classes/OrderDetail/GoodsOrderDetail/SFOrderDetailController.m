//
//  SFOrderDetailController.m
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderDetailController.h"

#import "SFBookingGoodOrderController.h"

#import "SFCarDetailHeaderView.h"
#import "SFCarDetailFooterView.h"
#import "SFOrderDetailCell.h"

static NSString *SFOrderDetailCELL_ID = @"SFOrderDetailCELL_ID";

@interface SFOrderDetailController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) SFCarOrderDetailModel *detailModel;

@end

@implementation SFOrderDetailController {
    UITableView *_tableView;
    SFCarDetailHeaderView *_header;
    SFCarDetailFooterView *_footerView;
}

+ (void)pushFromViewController:(UIViewController *)vc orderID:(NSString *)orderId
{
    SFOrderDetailController *ovc = [[SFOrderDetailController alloc] initWithOrderID:orderId];
    ovc.hidesBottomBarWhenPushed  = YES;
    [vc.navigationController pushViewController:ovc animated:YES];
}


- (instancetype)initWithOrderID:(NSString *)orderID
{
    if(self = [super init]){
        self.title = @"货源详情";
        self.orderID  = orderID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self getOrderDetail];
}

- (void)getOrderDetail {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Guid"] = self.orderID;
    [[SFNetworkManage shared] postWithPath:@"Goods/GetGoodsDetails"
                                    params:params
                                   success:^(id result)
    {
        [SVProgressHUD dismiss];
        SFCarOrderDetailModel *model = [SFCarOrderDetailModel mj_objectWithKeyValues:result];
        self.detailModel = model;
        
        _header.model = model;
        _footerView.remark = model.attention_remark;
        
        [_tableView reloadData];
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:@"请检查网络"];
    }];
    
    
}

#pragma mark - UIAction
- (void)BookingGoodOrder {
    SFBookingGoodOrderController *bookingGoods = [[SFBookingGoodOrderController alloc] init];
    bookingGoods.orderId = self.orderID;
    [self.navigationController pushViewController:bookingGoods animated:YES];
}

#pragma mark - 布局
- (void)setupView {
    CGFloat footerHeight;
    if (self.showType) {
        footerHeight = 0;
    } else {
        footerHeight = 50;
        
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44 - footerHeight) style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFOrderDetailCell class] forCellReuseIdentifier:SFOrderDetailCELL_ID];
    
    _header = [[SFCarDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    _tableView.tableHeaderView = _header;
    
    _footerView = [[SFCarDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
    _tableView.tableFooterView = _footerView;
    
    
    if (footerHeight) {
        UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, footerHeight)];
        [footer setTitle:@"接单" forState:(UIControlStateNormal)];
        [footer setBackgroundColor:THEMECOLOR];
        [footer setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
        [footer addTarget:self action:@selector(BookingGoodOrder) forControlEvents:(UIControlEventTouchUpInside)];
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
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SFOrderDetailCELL_ID forIndexPath:indexPath];
    cell.titleStr = self.titleArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


#pragma mark - LazyLoad
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"货物详情",@"车辆需求",@"意向价格",@"收货人信息", nil];
    }
    return _titleArray;
}


@end
