//
//  SFBookingCarOrderViewController.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingCarOrderViewController.h"

#import "SFCarDemandViewController.h"
#import "SFProvenanceViewController.h"

#import "SFBookingCarOrderCell.h"
#import "SFBookingCarCalendarCell.h"
#import "SFBookingCarFooter.h"

static NSString *BookingCELL_ID = @"BookingCELLID";
static NSString *BookingCalendarCELL_ID = @"BookingCalendarCELL_ID";
static NSString *BookingSectionFooter_ID = @"BookingSectionFooterID";

@interface SFBookingCarOrderViewController () <UITableViewDelegate,UITableViewDataSource,SFBookingCarOrderCellDelegate>

@property (nonatomic, strong) NSMutableArray <SFBookingCarModel *>*dataArray;

@end

@implementation SFBookingCarOrderViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"车辆需求";
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bookingCarRequest {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    SFBookingCarCalendarCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *time;
    if ([cell isKindOfClass:[SFBookingCarCalendarCell class]]) {
        time = cell.calendarTime;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    NSDate *selectedDate = [formatter dateFromString:time];
    [formatter setDateFormat:@"YYY-MM-dd HH:mm"];
    NSString *sendTime = [formatter stringFromDate:selectedDate];
    
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (id model in self.dataArray) {
        [selectedArray addObject:[model mj_JSONObject]];
    }
    
    
    params[@"UserId"] = USER_ID;
    params[@"OrderId"] = self.orderId;
    params[@"ShipmentDate"] = sendTime;
    params[@"OrderRemark"] = cell.remarkStr;
    params[@"Demand"] = [selectedArray mj_JSONString];
    
    [[SFNetworkManage shared] postWithPath:@"CarsBooking/BookingCarOrder"
                                    params:params
                                   success:^(id result)
    {
        [SVProgressHUD dismiss];
        if (result) {
            [[SFTipsView shareView] showSuccessWithTitle:@"预定成功"];
            
            SFProvenanceViewController *provence = [[SFProvenanceViewController alloc] init];
            provence.currentDirection = SFProvenanceDirectionReceive;
            provence.currentProvenanceIndex = 1;
            provence.isPopToRootVc = YES;
            [self.navigationController pushViewController:provence animated:YES];
            
            
        } else {
            [[SFTipsView shareView] showFailureWithTitle:@"预定失败"];
        }
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showFailureWithTitle:err.errDescription];
    }];
    
}

#pragma mark - UIAction
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SFBookingCarOrderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        __weak typeof(indexPath) weakIndexPath = indexPath;
        __weak typeof(self) weakSelf = self;
        SFCarDemandViewController *carDemand = [[SFCarDemandViewController alloc] init];
        carDemand.bookingModel = cell.model ;
        [carDemand setReturnBlock:^(SFBookingCarModel *model) {
            [weakSelf.dataArray replaceObjectAtIndex:weakIndexPath.row withObject:model];
            [_tableView reloadRowsAtIndexPaths:@[weakIndexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        }];
        [self.navigationController pushViewController:carDemand animated:YES];
    }
}

- (void)SFBookingCarOrderCellDidClickDelButton:(SFBookingCarOrderCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
}

/**
 添加车辆需求
 */
- (void)addCarAction {
    __weak typeof(self) weakSelf = self;
    SFCarDemandViewController *carDemand = [[SFCarDemandViewController alloc] init];
    NSMutableSet *carTypeArray = [NSMutableSet set];
    for (SFCarListModel *model in self.carListArray) {
        [carTypeArray addObject:model.car_type];
    }
    carDemand.carTypeArray = carTypeArray.allObjects;
    [carDemand setReturnBlock:^(SFBookingCarModel *model) {
        [weakSelf.dataArray insertObject:model atIndex:0];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    }];
    [self.navigationController pushViewController:carDemand animated:YES];
}


/**
 立即预定
 */
- (void)bookingCarNow {
    
    if (!self.dataArray.count) {
        [[SFTipsView shareView] showFailureWithTitle:@"请添加车辆需求"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否确认要预订？" message:@"注意：未填写的车辆需求，司机将可任意分配车辆" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf bookingCarRequest];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    
    [alert addAction:action2];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - 布局
- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44 - 50) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [_tableView registerClass:[SFBookingCarOrderCell class] forCellReuseIdentifier:BookingCELL_ID];
    [_tableView registerClass:[SFBookingCarCalendarCell class] forCellReuseIdentifier:BookingCalendarCELL_ID];
    [_tableView registerClass:[SFBookingCarFooter class] forHeaderFooterViewReuseIdentifier:BookingSectionFooter_ID];
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
    UIButton *bookingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    bookingButton.backgroundColor = THEMECOLOR;
    [bookingButton setTitle:@"确认预定" forState:(UIControlStateNormal)];
    [bookingButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [bookingButton addTarget:self action:@selector(bookingCarNow) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:bookingButton];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *CurrentCell;
    if (indexPath.section == 0) {
        SFBookingCarOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:BookingCELL_ID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.dataArray[indexPath.row];
        CurrentCell = cell;
    } else {
        SFBookingCarCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:BookingCalendarCELL_ID forIndexPath:indexPath];
        CurrentCell = cell;
    }
    
    return CurrentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else {
        return 140;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        __weak typeof(self) weakSelf = self;
        SFBookingCarFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookingSectionFooter_ID];
        [footer setAddAction:^{
            [weakSelf addCarAction];
        }];
        return footer;
    }
    return nil;
}

#pragma mark - lazyLoad
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
