//
//  SFCarDemandViewController.m
//  SFLIS
//
//  Created by kit on 2017/12/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFCarDemandViewController.h"

#import "SFAddCarView.h"
#import "SFMessageInputView.h"
#import "SFOtherPickerView.h"

@interface SFCarDemandViewController () <SFSinglePickerProtocol>
@property (nonatomic, strong) NSMutableArray <NSString *>*CarTypeArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*CarLongArray;
@end

@implementation SFCarDemandViewController {
    UIScrollView *_scrollView;
    
    SFAddCarView *_carType;
    SFAddCarView *_carLong;
    SFMessageInputView *_carCount;
    SFMessageInputView *_goodWeight;
    SFMessageInputView *_goodSize;
    SFMessageInputView *_price;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你有操作未保存，是否保存" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *comfireAction = [UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self comfirmButtonClick];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续退出" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [alert addAction:comfireAction];
    
    if (_carType.inputStr.length || _carLong.inputStr.length || _carCount.inputStr.length || _carCount.inputStr.length || _goodWeight.inputStr.length || _goodSize.inputStr.length || _price.inputStr.length) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

- (void)comfirmButtonClick {
    [self.view endEditing:YES];
    
    
    NSString *carType;
    if (_carType.inputStr.length) {
        carType = _carType.inputStr;
    } else {
        carType = @"任意车型";
    }
    
    NSString *carLong;
    if (_carLong.inputStr.length) {
        carLong = _carLong.inputStr;
    } else {
        carLong = @"任意车长";
    }
    
    NSString *carCount;
    if (_carCount.inputStr.length) {
        carCount = _carCount.inputStr;
    } else {
        carCount = @"任意数量";
    }
    NSString *carWight;
    if (_goodWeight.inputStr.length) {
        carWight = _goodWeight.inputStr;
    } else {
        carWight = @"0";
    }
    NSString *carSize;
    if (_goodSize.inputStr.length) {
        carSize = _goodSize.inputStr;
    } else {
        carSize = @"0";
    }
    NSString *price = _price.inputStr;
    
    
    if (!price.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请填写报价"];
        return;
    }
    
    SFBookingCarModel *model = [SFBookingCarModel new];
    model.car_Type = carType;
    model.car_Long = carLong;
    model.car_Count = carCount;
    model.good_weight = carWight;
    model.good_size = carSize;
    model.price = price;
    
    if (self.returnBlock) {
        self.returnBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAction
- (void)pickerView:(id)pickerView commitDidSelected:(NSInteger)index resourceArray:(NSArray *)resouceArray {
    UIView *picker = (UIView *)pickerView;
    
    NSString *targetStr = resouceArray[index];
    
    SFAddCarView *view = [self FindViewWithTag:picker.tag];
    if (view) {
        [view setTitleWithStr:targetStr];
        [view animation];
    }
}

- (void)pickerViewDidSelectedCancel:(id)pickerView {
    UIView *picker = (UIView *)pickerView;
    SFAddCarView *view = [self FindViewWithTag:picker.tag];
    if (view) {
        [view animation];
    }
}


- (SFAddCarView *)FindViewWithTag:(NSInteger)tag {
    for (SFAddCarView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[SFAddCarView class]]) {
            if (view.tag == tag) {
                return view;
                break;
            }
        }
    }
    return nil;
}


#pragma mark - 布局
- (void)setupView {
    self.title = @"车辆需求";
    self.navigationItem.backBarButtonItem.action = @selector(backAction);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - 50)];
    [self.view addSubview:_scrollView];

    __weak typeof(self) weakSelf = self;
    
    _carType = [[SFAddCarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 64)];
    _carType.viewStyle = ViewStyle_SelectedStyle;
    _carType.placeHolder = @"选择车辆类型";
    _carType.showLineView = NO;
    _carType.tag = 1;
    [_carType setAction:^(SFAddCarView *view) {
        [weakSelf.view endEditing:YES];
        [view animation];
        SFOtherPickerView *picker = [[SFOtherPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:weakSelf.CarTypeArray];
        picker.delegate = weakSelf;
        picker.title = @"请选择车辆类型";
        picker.tag = 1;
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        [picker showAnimation];
    }];
    [_scrollView addSubview:_carType];
    
    _carLong = [[SFAddCarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_carType.frame), SCREEN_WIDTH - 40, 64)];
    _carLong.viewStyle = ViewStyle_SelectedStyle;
    _carLong.placeHolder = @"选择车辆长度";
    _carLong.tag = 2;
    [_carLong setAction:^(SFAddCarView *view) {
        [weakSelf.view endEditing:YES];
        [view animation];
        SFOtherPickerView *picker = [[SFOtherPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:weakSelf.CarLongArray];
        picker.delegate = weakSelf;
        picker.title = @"选择车辆长度";
        picker.tag = 2;
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        [picker showAnimation];
    }];
    [_scrollView addSubview:_carLong];
    
    
    _carCount = [[SFMessageInputView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_carLong.frame) + 30, SCREEN_WIDTH - 40, 48)];
    _carCount.keyBoardType = MessageKeyBoardType_NumberOnly;
    _carCount.placeHolder = @"填写所需车数量";
    _carCount.tipsStr = @"辆";
    [_scrollView addSubview:_carCount];
    
    _goodWeight = [[SFMessageInputView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_carCount.frame) + 20, SCREEN_WIDTH - 40, 48)];
    _goodWeight.keyBoardType = MessageKeyBoardType_FloatOnly;
    _goodWeight.placeHolder = @"填写货物重量";
    _goodWeight.tipsStr = @"吨";
    [_scrollView addSubview:_goodWeight];
    
    _goodSize = [[SFMessageInputView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_goodWeight.frame) + 10, SCREEN_WIDTH - 40, 48)];
    _goodSize.keyBoardType = MessageKeyBoardType_FloatOnly;
    _goodSize.placeHolder = @"填写货物体积";
    _goodSize.tipsStr = @"方";
    [_scrollView addSubview:_goodSize];
    
    _price = [[SFMessageInputView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_goodSize.frame) + 20, SCREEN_WIDTH - 40, 48)];
    _price.keyBoardType = MessageKeyBoardType_FloatOnly;
    _price.placeHolder = @"填写报价";
    _price.tipsStr = @"元/车";
    [_scrollView addSubview:_price];
    
    
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_price.frame));
    
    UIButton *comfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    comfirmButton.backgroundColor = THEMECOLOR;
    [comfirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [comfirmButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [comfirmButton addTarget:self action:@selector(comfirmButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:comfirmButton];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray<NSString *> *)CarTypeArray {
    if (!_CarTypeArray) {
        _CarTypeArray  = [NSMutableArray arrayWithObjects:@"保温车",@"平板车",@"飞翼车",@"半封闭车", @"危险品车",@"集装车",@"敞篷车",@"金杯车",@"自卸货车",@"高低板车",@"高栏车",@"冷藏车",@"厢式车", nil];
    }
    return _CarTypeArray;
}

- (NSMutableArray<NSString *> *)CarLongArray {
    if (!_CarLongArray) {
        _CarLongArray = [NSMutableArray arrayWithObjects:@"4.2米",@"4.8米",@"5.2米",@"5.8米", @"6.2米",@"3.8米",@"7.2米",@"7.8米",@"8.6米",@"9.6米",@"12.0米",@"12.5米",@"13.5米",@"16.0米",@"17.5米", nil];
    }
    return _CarLongArray;
}


@end