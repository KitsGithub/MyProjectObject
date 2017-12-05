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

//自定义控件
#import "SFBookingCarCalendarCell.h"
#import "SFBookingGoodsCell.h"
#import "SFBookingGoodsHeaderView.h"

static NSString *BookingGoodsCELL_ID = @"BookingGoodsCELL_ID";
static NSString *BookingCalendarCELL_ID = @"BookingCalendarCELL_ID";
static NSString *BookingGoodsHEADER_ID = @"BookingGoodsHEADER_ID";

@interface SFBookingGoodOrderController () <UITableViewDelegate,UITableViewDataSource,SFBookingGoodsCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

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

#pragma mark - UIAction
- (void)bookingGoodNow {
    SFChooseReleaseTimeController *time = [[SFChooseReleaseTimeController alloc] init];
    [self.navigationController pushViewController:time animated:YES];
}

- (void)SFBookingGoodsCellDidSelectedDel:(SFBookingGoodsCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
}


- (void)selectedCar {
    SFChooseCarrierCarController *addCar = [[SFChooseCarrierCarController alloc] init];
    addCar.typeMode = TypeMode_MoreChooser;
    
    NSMutableArray *carNumArray = [NSMutableArray array];
    for (SFCarListModel *model in self.dataArray) {
        [carNumArray addObject:model.car_no];
    }
    addCar.selectedCarArray = carNumArray;
    __weak typeof(self) weakSelf = self;
    [addCar setResultReturnBlock:^(NSArray<SFCarListModel *> *modelArray) {
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
        cell = [tableView dequeueReusableCellWithIdentifier:BookingCalendarCELL_ID forIndexPath:indexPath];
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
