//
//  SFOrderDetailController.m
//  SFLIS
//
//  Created by kit on 2017/10/11.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFOrderDetailController.h"

#import "SFBookingGoodOrderController.h"
#import "SFAuthStatuViewController.h"

#import "SFCarDetailHeaderView.h"
#import "SFCarDetailFooterView.h"
#import "SFOrderDetailCell.h"
#import "SFGoodsDetailModel.h"

static NSString *SFOrderDetailCELL_ID = @"SFOrderDetailCELL_ID";

@interface SFOrderDetailController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <NSString *>*titleArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*messageArray;

@property (nonatomic, strong) SFGoodsDetailModel *detailModel;

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
    [SFLoaddingView loaddingToView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Guid"] = self.orderID;
    [[SFNetworkManage shared] postWithPath:@"Goods/GetGoodsDetails"
                                    params:params
                                   success:^(id result)
    {
        [SFLoaddingView dismiss];
        SFGoodsDetailModel *model = [SFGoodsDetailModel mj_objectWithKeyValues:result];
        self.detailModel = model;
        
        _header.model = model;
        _footerView.remark = model.attention_remark;
        
        NSString *weight = @"";
        if (![model.goods_size isEqualToNumber:[NSNumber numberWithInt:0]]) {
            weight = [NSString stringWithFormat:@"%@吨",model.goods_weight];
        }
        
        NSString *size = @"";
        if (![model.goods_size isEqualToNumber:[NSNumber numberWithInt:0]]) {
            size = [NSString stringWithFormat:@"%@方",model.goods_size];
        }
        
        
        NSString *orderDetail = [NSString stringWithFormat:@"%@ %@ %@ %@ ",model.goods_type,model.goods_name,weight,size];
        
        NSString *carDemand = @"任意车辆";
        if (model.car_type.length && model.car_long.length && ![model.car_count isEqualToNumber:[NSNumber numberWithInt:0]]) {
            carDemand = [NSString stringWithFormat:@"%@ %@ %@辆",model.car_type,model.car_long,model.car_count];
        }
        
        
        NSString *price = @"面议";
        if (model.price.length) {
            price = [NSString stringWithFormat:@"%@元/车",model.price];
        }
        
        NSString *message = @"暂无收货人信息";
        if (model.delivery_by.length && model.delivery_mobile.length) {
            message = [NSString stringWithFormat:@"%@ %@",model.delivery_by,model.delivery_mobile];
        }
        
        
        [self.messageArray addObjectsFromArray:@[orderDetail,carDemand,price,message]];
        
        [_tableView reloadData];
        
    } fault:^(SFNetworkError *err) {
        [[SFTipsView shareView] showFailureWithTitle:@"请检查网络"];
        __weak typeof(self) weakSelf = self;
        [SFLoaddingView showResultWithResuleType:(SFLoaddingResultType_LoaddingFail) toView:self.view reloadBlock:^{
            [weakSelf getOrderDetail];
        }];
    }];
}

#pragma mark - UIAction
- (void)BookingGoodOrder {
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
    SFBookingGoodOrderController *bookingGoods = [[SFBookingGoodOrderController alloc] init];
    bookingGoods.carType = self.detailModel.car_type;
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
    if (self.messageArray.count) {
        cell.messageStr = self.messageArray[indexPath.row];
    }
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

- (NSMutableArray<NSString *> *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
@end
