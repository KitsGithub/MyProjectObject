//
//  SFBookingGoodOrderController.m
//  SFLIS
//
//  Created by kit on 2017/12/4.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingGoodOrderController.h"

//跳转
#import "SFChooseCarrierCarController.h"
#import "SFChooseReleaseTimeController.h"
#import "SFProvenanceViewController.h"

//自定义控件
#import "SFBookingCarCalendarCell.h"
#import "SFBookingGoodsCell.h"
#import "SFBookingGoodsHeaderView.h"

static NSString *BookingGoodsCELL_ID = @"BookingGoodsCELL_ID";
static NSString *BookingCalendarCELL_ID = @"BookingCalendarCELL_ID";
static NSString *BookingGoodsHEADER_ID = @"BookingGoodsHEADER_ID";

@interface SFBookingGoodOrderController () <UITableViewDelegate,UITableViewDataSource,SFBookingGoodsCellDelegate>

@property (nonatomic, strong) NSMutableArray <SFCarListModel *>*dataArray;

@end

@implementation SFBookingGoodOrderController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择接单车辆";
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bookGoodRequset {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableArray *selectedCarJsonArray = [NSMutableArray array];
    for (SFCarListModel *model in self.dataArray) {
        [selectedCarJsonArray addObject:[model mj_JSONObject]];
    }
    
    SFBookingCarCalendarCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *time;
    if ([cell isKindOfClass:[SFBookingCarCalendarCell class]]) {
        time = cell.calendarTime;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    NSDate *selectedDate = [formatter dateFromString:time];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *sendTime = [formatter stringFromDate:selectedDate];
    
    params[@"Cars"] = [selectedCarJsonArray mj_JSONString];
    params[@"Time"] = sendTime;
    params[@"OrderRemark"] = cell.remarkStr;
    params[@"OrderId"] = self.orderId;
    params[@"UserId"] = USER_ID;
    
    [[SFNetworkManage shared] postWithPath:@"GoodsOrder/AddGoodsOrder"
                                    params:params
                                   success:^(id result)
    {
        [SVProgressHUD dismiss];
        if (result) {
            [[SFTipsView shareView] showSuccessWithTitle:@"预订成功"];
            
            SFProvenanceViewController *provence = [[SFProvenanceViewController alloc] init];
            provence.currentDirection = SFProvenanceDirectionReceive;
            provence.currentProvenanceIndex = 1;
            provence.isPopToRootVc = YES;
            [self.navigationController pushViewController:provence animated:YES];
            
            
        } else {
            [[SFTipsView shareView] showSuccessWithTitle:@"预订失败"];
        }
        
    } fault:^(SFNetworkError *err) {
        [SVProgressHUD dismiss];
        [[SFTipsView shareView] showSuccessWithTitle:err.errDescription];
    }];
    
}

#pragma mark - UIAction
- (void)bookingGoodNow {
    
    if (!self.dataArray.count) {
        [[SFTipsView shareView] showFailureWithTitle:@"请选择接单车辆"];
        return;
    }
    
    for (SFCarListModel *carModel in self.dataArray) {
        if ([carModel.order_fee isEqualToString:@""]) {
            [[SFTipsView shareView] showFailureWithTitle:@"请输入车辆价格"];
            return;
        }
    }
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否确认接单" message:@"请仔细检查您的发车时间，一旦接单将无法修改" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf bookGoodRequset];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)SFBookingGoodsCellDidSelectedDel:(SFBookingGoodsCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
}


- (void)selectedCar {
    SFChooseCarrierCarController *addCar = [[SFChooseCarrierCarController alloc] init];
    addCar.typeMode = TypeMode_MoreChooser;
    if (![self.carType isEqualToString:@"任意车型"]) {
        addCar.carType = self.carType;
    }
    
    NSMutableArray *carNumArray = [NSMutableArray array];
    for (SFCarListModel *model in self.dataArray) {
        [carNumArray addObject:model.car_no];
    }
    addCar.selectedCarArray = carNumArray;
    
    __weak typeof(self) weakSelf = self;
    [addCar setResultReturnBlock:^(NSArray<SFCarListModel *> *modelArray) {
        for (SFCarListModel *model in modelArray) {
            model.order_fee = @"";
        }
        [weakSelf.dataArray addObjectsFromArray:modelArray];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:addCar animated:YES];
}

#pragma mark - 布局
- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44 - 50) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SFBookingGoodsCell class] forCellReuseIdentifier:BookingGoodsCELL_ID];
    [_tableView registerClass:[SFBookingCarCalendarCell class] forCellReuseIdentifier:BookingCalendarCELL_ID];
    [_tableView registerClass:[SFBookingGoodsHeaderView class] forHeaderFooterViewReuseIdentifier:BookingGoodsHEADER_ID];
    
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
    [bookingButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [bookingButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [bookingButton addTarget:self action:@selector(bookingGoodNow) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:bookingButton];
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 171;
    } else {
        return 140;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 75;
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        SFBookingGoodsHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookingGoodsHEADER_ID];
        [header setActionSelector:@selector(selectedCar) withTarget:self];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:BookingGoodsCELL_ID forIndexPath:indexPath];
        SFBookingGoodsCell *goodsCell = (SFBookingGoodsCell *)cell;
        goodsCell.model = self.dataArray[indexPath.row];
        goodsCell.delegate = self;
    } else {
        
        /*在IOS8.3系统下,使用 @sel(dequeueReusableCellWithIdentifier:forIndexPath:)获取注册cell发生了崩溃，因此使用最初的cell注册方法*/
        SFBookingCarCalendarCell *otherCell = [tableView dequeueReusableCellWithIdentifier:BookingCalendarCELL_ID];
        if (!otherCell) {
            otherCell = [[SFBookingCarCalendarCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:BookingCalendarCELL_ID];
        }
        
        cell = otherCell;
    }
    
    return cell;
}


#pragma mark - lazyLoad
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
