//
//  SFDriverTransportDetailController.m
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDriverTransportDetailController.h"
#import <CoreLocation/CoreLocation.h>

#import "SFSegmentView.h"
#import "SFDriverSignAlerView.h"
#import "SFTransportCell.h"

#import "SFTransportDetailController.h"

static NSString *TransportDetailCellReusedID = @"TransportDetailCellReusedID";

typedef enum : NSUInteger {
    OptionType_DriverSign,
    OptionType_DriverArrived,
} OptionType;

@interface SFDriverTransportDetailController ()  <UITableViewDelegate,UITableViewDataSource,SFTransportCellDelegate,CLLocationManagerDelegate>

@property (nonatomic, assign) DataType dataType;
@property (nonatomic, strong) NSMutableArray <SFTransportModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;


//定位功能
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) CLGeocoder *geocoder;

@property (nonatomic, assign) OptionType optionType;
@property (nonatomic, copy) NSString *orderId;

@end

@implementation SFDriverTransportDetailController {
    UITableView *_tableView;
    SFSegmentView *_segment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    [self setupView];
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDataWithType:self.dataType page:self.page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 网络
- (void)requestDataWithType:(DataType)dataType page:(NSInteger)page {
    [SFLoaddingView loaddingToView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"DriverId"] = self.driverId;
    if (dataType == DataType_Transprot) {
        params[@"OrderStatus"] = @"S";
    } else {
        params[@"OrderStatus"] = @"A";
    }
    
    params[@"PageIndex"] = @(page);
    params[@"PageSize"] = @(20);
    [[SFNetworkManage shared] postWithPath:@"Driver/GetDriverOrder"
                                    params:params
                                   success:^(id result)
    {
        
        NSMutableArray *dataArray = [SFTransportModel mj_objectArrayWithKeyValuesArray:result];
        if (dataArray.count) {
            [SFLoaddingView dismiss];
            self.dataArray = dataArray;
            [_tableView reloadData];
        } else {
            [SFLoaddingView showResultWithResuleType:(SFLoaddingResultType_NoMoreData) toView:self.view reloadBlock:nil];
        }
        
        [_tableView reloadData];
        
        
    } fault:^(SFNetworkError *err) {
        __weak typeof(self) weakSelf = self;
        [SFLoaddingView showResultWithResuleType:(SFLoaddingResultType_LoaddingFail) toView:self.view reloadBlock:^{
            [weakSelf requestDataWithType:dataType page:page];
        }];
    }];
}

#pragma mark 到达
- (void)driverArrivedWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude loactionStr:(NSString *)currentLoaction {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"DriverId"] = self.driverId;
    params[@"OrderId"] = self.orderId;
    params[@"Latitude"] = [NSString stringWithFormat:@"%f",latitude];
    params[@"Longitude"] = [NSString stringWithFormat:@"%f",longitude];
    params[@"Location"] = currentLoaction;
    
    [[SFNetworkManage shared] postWithPath:@"/Driver/DriverArrive"
                                    params:params
                                   success:^(id result)
     {
         [SVProgressHUD dismiss];
         if (result) {
             [[SFTipsView shareView] showSuccessWithTitle:[NSString stringWithFormat:@"您已到达%@",currentLoaction]];
             for (NSInteger index = 0; index < self.dataArray.count; index++) {
                 SFTransportModel *model = self.dataArray[index];
                 if ([model.order_id isEqualToString:self.orderId]) {
                     [self.dataArray removeObject:model];
                     [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:(UITableViewRowAnimationFade)];
                     break;
                 }
             }
         }
         
     } fault:^(SFNetworkError *err) {
         [SVProgressHUD dismiss];
         [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
     }];
}

#pragma mark 签到
- (void)driverSignWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude loactionStr:(NSString *)currentLoaction {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"DriverId"] = self.driverId;
    params[@"OrderId"] = self.orderId;
    params[@"Latitude"] = [NSString stringWithFormat:@"%f",latitude];
    params[@"Longitude"] = [NSString stringWithFormat:@"%f",longitude];
    params[@"Location"] = currentLoaction;
    
    [[SFNetworkManage shared] postWithPath:@"Driver/DriverSign"
                                    params:params
                                   success:^(id result)
     {
         self.orderId = @"";
         [SVProgressHUD dismiss];
         SFDriverSignAlerView *driver = [[SFDriverSignAlerView alloc] init];
         driver.loactionStr = currentLoaction;
         [driver showAnimation];
         
     } fault:^(SFNetworkError *err) {
         self.orderId = @"";
         [SVProgressHUD dismiss];
         [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
     }];
}

#pragma mark - UIAction
- (void)SFTransportCell:(SFTransportCell *)cell didSelectedButtonAtIndex:(NSInteger)index {
    if (index == 0) {
        NSLog(@"详情");
        [self jumpToTransportDetail:cell];
    } else if (index == 1) {
        NSLog(@"送达");
        if (self.orderId.length) {
            return;
        }
        self.optionType = OptionType_DriverArrived;
        self.orderId = cell.model.order_id;
        
        [self startLoacted];
    } else if (index == 2) {
        NSLog(@"签到");
        if (self.orderId.length) {
            return;
        }
        self.optionType = OptionType_DriverSign;
        self.orderId = cell.model.order_id;
        [self startLoacted];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTransportCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self jumpToTransportDetail:cell];
}

- (void)startLoacted {
    [SVProgressHUD show];
    //获取用户定位信息授权状态
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.manager requestWhenInUseAuthorization];
    }
    [self.manager startUpdatingLocation];
    
}

- (void)jumpToTransportDetail:(SFTransportCell *)cell {
    SFTransportDetailController *detail = [[SFTransportDetailController alloc] init];
    detail.orderId = cell.model.order_id;
    detail.carNo = cell.model.car_no;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 定位功能
//授权状态发生改变的时候调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"用户拒绝");
        [[SFTipsView shareView] showFailureWithTitle:@"无法获取定位，请在设置中打开定位服务"];
    } else if(status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        NSLog(@"授权成功");
        [self.manager startUpdatingLocation];
    }
}

//当更新到用户位置信息的时候调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.manager stopUpdatingLocation];
    //最新用户位置数组的最后一个元素
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D corrdinate = location.coordinate;
    NSLog(@"经度%f  纬度%f",corrdinate.longitude,corrdinate.latitude);
    [self getAddressByLatitude:corrdinate.latitude longitude:corrdinate.longitude];
}

- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSString * _provinceName = placemark.addressDictionary[@"City"];
        NSString * _areaName = placemark.addressDictionary[@"SubLocality"];
        if (_provinceName.length && _areaName.length) {
            
            NSString *currentLoaction = [NSString stringWithFormat:@"%@%@%@%@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"],_areaName,placemark.thoroughfare];
            
            switch (self.optionType) {
                case OptionType_DriverSign:
                    [self driverSignWithLatitude:latitude longitude:longitude loactionStr:currentLoaction];
                    break;
                case OptionType_DriverArrived:
                    [self driverArrivedWithLatitude:latitude longitude:longitude loactionStr:currentLoaction];
                default:
                    break;
            }
            
            
        }
    }];
}

#pragma mark - setup
- (void)setNav {
    self.dataType = DataType_Transprot;
    
    __weak typeof(self) wself = self;
    __weak typeof(_tableView) wTableView = _tableView;
    _segment   = [[SFSegmentView alloc] initWithFrame:CGRectMake(0, 0, 30 + 64 + 64 + 15*2, 44) items:@[@"待运输",@"已到货"] font:FONT_COMMON_16];
    _segment.lineWidth  = 80;
    _segment.selectedBlock = ^(NSInteger index) {
        if (wself.dataType == index) {
            return ;
        }
        wself.dataType = index;
        wself.page = 1;
        wself.dataArray = [NSMutableArray array];
        [wTableView reloadData];
        [wself requestDataWithType:wself.dataType page:1];
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
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFTransportCell *cell = [tableView dequeueReusableCellWithIdentifier:TransportDetailCellReusedID forIndexPath:indexPath];
    cell.dataType = self.dataType;
    cell.model = self.dataArray[indexPath.section];
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

- (NSMutableArray<SFTransportModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _manager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

@end
