//
//  SFBookingCarOrderViewController.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFBookingCarOrderViewController.h"

#import "SFCarDemandViewController.h"

#import "SFBookingCarOrderCell.h"
#import "SFBookingCarCalendarCell.h"
#import "SFBookingCarFooter.h"

static NSString *BookingCELL_ID = @"BookingCELLID";
static NSString *BookingCalendarCELL_ID = @"BookingCalendarCELL_ID";
static NSString *BookingSectionFooter_ID = @"BookingSectionFooterID";

@interface SFBookingCarOrderViewController () <UITableViewDelegate,UITableViewDataSource,SFBookingCarOrderCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SFBookingCarOrderViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"填写车辆需求";
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAction
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    [[SFTipsView shareView] showSuccessWithTitle:@"预定成功"];
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
    [bookingButton setTitle:@"立即预定" forState:(UIControlStateNormal)];
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
