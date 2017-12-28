//
//  SFAuthCarMessageView.m
//  SFLIS
//
//  Created by kit on 2017/11/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthCarMessageView.h"
#import "SFSinglePickerView.h"
#import "SFOtherPickerView.h"

#import "SFAddCarView.h"

@interface SFAuthCarMessageView () <SFSinglePickerProtocol>

@property (nonatomic, strong) NSMutableArray <NSString *>*AscriptionArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*LetterArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*CarTypeArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*CarLongArray;

@end

@implementation SFAuthCarMessageView {
    UILabel *_titleView;
    
    SFAddCarView *_carProvince;
    SFAddCarView *_carCity;
    SFAddCarView *_carNum;
    SFAddCarView *_drivingNum;
    
    SFAddCarView *_carType;
    SFAddCarView *_carLong;
    
    SFAddCarView *_carWeight;
    SFAddCarView *_carSize;
    
    UIImageView *_identflyImage;    //认证图片
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _titleView = [UILabel new];
    _titleView.textColor = COLOR_TEXT_COMMON;
    _titleView.text = @"填写身份信息";
    _titleView.font = [UIFont systemFontOfSize:21];
    [self addSubview:_titleView];
    
    
    __weak typeof(self) weakSelf = self;
    _carProvince = [SFAddCarView new];
    _carProvince.viewStyle = ViewStyle_SelectedStyle;
    _carProvince.placeHolder = @"请选择车辆归属地";
    _carProvince.tag = 0;
    [_carProvince setAction:^(SFAddCarView *view) {
        [weakSelf endEditing:YES];
        [view animation];
        SFSinglePickerView *picker = [[SFSinglePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:weakSelf.AscriptionArray];
        picker.delegate = weakSelf;
        picker.title = @"请选择车辆归属地";
        picker.tag = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        [picker showAnimation];
    }];
    [self addSubview:_carProvince];
    
    
    _carCity = [SFAddCarView new];
    _carCity.viewStyle = ViewStyle_SelectedStyle;
    _carCity.placeHolder = @"请选择车牌地区代码";
    _carCity.tag = 1;
    [_carCity setAction:^(SFAddCarView *view) {
        [weakSelf endEditing:YES];
        [view animation];
        SFSinglePickerView *picker = [[SFSinglePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:weakSelf.LetterArray];
        picker.delegate = weakSelf;
        picker.tag = 1;
        picker.title = @"请选择车牌地区代码";
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        [picker showAnimation];
    }];
    [self addSubview:_carCity];


    _carNum = [SFAddCarView new];
    _carNum.viewStyle = ViewStyle_InputViewStyle;
    _carNum.placeHolder = @"请输入车牌号码";
    _carNum.tag = 2;
    [self addSubview:_carNum];
    
    _drivingNum = [SFAddCarView new];
    _drivingNum.viewStyle = ViewStyle_InputViewStyle;
    _drivingNum.placeHolder = @"请输入车辆识别代号";
    _drivingNum.tag = 3;
    [self addSubview:_drivingNum];


    _carType = [SFAddCarView new];
    _carType.viewStyle = ViewStyle_SelectedStyle;
    _carType.placeHolder = @"请选择车辆类型";
    _carType.tag = 4;
    [_carType setAction:^(SFAddCarView *view) {
        [weakSelf endEditing:YES];
        [view animation];
        SFOtherPickerView *picker = [[SFOtherPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:weakSelf.CarTypeArray];
        picker.delegate = weakSelf;
        picker.title = @"请选择车辆类型";
        picker.tag = 4;
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        [picker showAnimation];
    }];
    [self addSubview:_carType];

    
    _carLong = [SFAddCarView new];
    _carLong.viewStyle = ViewStyle_SelectedStyle;
    _carLong.placeHolder = @"请选择车辆长度";
    _carLong.tag = 5;
    [_carLong setAction:^(SFAddCarView *view) {
        [weakSelf endEditing:YES];
        [view animation];
        SFOtherPickerView *picker = [[SFOtherPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withResourceArray:weakSelf.CarLongArray];
        picker.delegate = weakSelf;
        picker.title = @"请选择车辆长度";
        picker.tag = 5;
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        [picker showAnimation];
    }];
    [self addSubview:_carLong];


    _carWeight = [SFAddCarView new];
    _carWeight.viewStyle = ViewStyle_InputViewStyle;
    _carWeight.placeHolder = @"请输入车辆载重(吨)";
    [self addSubview:_carWeight];


    _carSize = [SFAddCarView new];
    _carSize.viewStyle = ViewStyle_InputViewStyle;
    _carSize.placeHolder = @"请输入车辆承重体积(方)";
    [self addSubview:_carSize];
    
    
    _identflyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"认证章"]];
    _identflyImage.hidden = YES;
    [self addSubview:_identflyImage];
    
}

- (void)setEdittingEnable:(BOOL)edittingEnable {
    _edittingEnable = edittingEnable;
    self.userInteractionEnabled = edittingEnable;
    
    if (edittingEnable) {
        _titleView.text = @"填写车辆信息";
    } else {
        _titleView.text = @"车辆信息";
    }
    
}

- (void)setStatus:(SFAuthStatusModle *)status {
    _status = status;
    
    NSString *carNum = status.car_no;
    if (carNum.length > 2) {
        [_carProvince setTitleWithStr:[carNum substringToIndex:1]];
        [_carCity setTitleWithStr:[carNum substringWithRange:NSMakeRange(1, 1)]];
        _carNum.inputViewStr = [carNum substringFromIndex:2];
    }
    
    _drivingNum.inputViewStr = status.driving_license;
    
    if (status.car_type.length ) {
        [_carType setTitleWithStr:status.car_type];
    }
    
    if (status.car_long.length) {
        [_carLong setTitleWithStr:status.car_long];
    }
    
    if (status) {
        if (status.car_weight.length) {
            _carWeight.inputViewStr = status.car_weight;
        } else {
            _carWeight.placeHolder = @"未填写车辆载重";
        }
        
        if (status.car_size.length) {
            _carSize.inputViewStr = status.car_size;
        } else {
            _carSize.placeHolder = @"未填写承重体积";
        }
    }
    
    
    
    
    
    if ([status.verify_status isEqualToString:@"D"]) {
        _identflyImage.hidden = NO;
    }
}

- (NSMutableDictionary *)getCarMessageJson {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (!_carProvince.inputStr.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请选择车辆归属地"];
        return params;
    }
    if (!_carCity.inputStr.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请选择车辆地区代码"];
        return params;
    }
    if (!_carNum.inputStr.length) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入车牌号码"];
        return params;
    } else if (_carNum.inputStr.length != 5) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的车牌号码"];
        return params;
    }
    
    if (!_drivingNum.inputStr) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入车辆识别代号"];
        return params;
    } else if (_drivingNum.inputStr.length != 17) {
        [[SFTipsView shareView] showFailureWithTitle:@"请输入正确的车辆识别代号"];
        return params;
    }
    
    if (!_carType.inputStr) {
        [[SFTipsView shareView] showFailureWithTitle:@"请选择车辆类型"];
        return params;
    }
    if (!_carLong.inputStr) {
        [[SFTipsView shareView] showFailureWithTitle:@"请选择车辆长度"];
        return params;
    }
    
    
    NSString *carNum = [_carProvince.inputStr stringByAppendingString:[NSString stringWithFormat:@"%@%@",_carCity.inputStr,_carNum.inputStr]];
    
    params[@"CarNo"] = carNum;
    params[@"DrivingNo"] = _drivingNum.inputStr;
    params[@"CarType"] = _carType.inputStr;
    params[@"CarLong"] = _carLong.inputStr;
    params[@"CarSize"] = @([_carWeight.inputStr intValue]);
    params[@"DeadWeight"] = @([_carSize.inputStr intValue]);
    
    return params;
}


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
    for (SFAddCarView *view in self.subviews) {
        if ([view isKindOfClass:[SFAddCarView class]]) {
            if (view.tag == tag) {
                return view;
                break;
            }
        }
    }
    return nil;
}


#pragma mark - Layout
- (void)layoutSubviews {
    CGFloat padding = 20;
    CGFloat weight = SCREEN_WIDTH - padding * 2;
    CGFloat height = 48;
    _titleView.frame = CGRectMake(padding, 0, weight, 21);
    
    _identflyImage.frame = CGRectMake(SCREEN_WIDTH - 100 - 30, CGRectGetMinY(_titleView.frame), 100, 88);
    
    _carProvince.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame) + 30, weight, height);
    
    _carCity.frame = CGRectMake(0, CGRectGetMaxY(_carProvince.frame) + 20, weight, height);
    
    _carNum.frame = CGRectMake(0, CGRectGetMaxY(_carCity.frame) + 20, weight, height);
    
    _drivingNum.frame = CGRectMake(0, CGRectGetMaxY(_carNum.frame) + 20, weight, height);
    
    _carType.frame = CGRectMake(0, CGRectGetMaxY(_drivingNum.frame) + 20, weight, height);
    
    _carLong.frame = CGRectMake(0, CGRectGetMaxY(_carType.frame) + 20, weight, height);
    
    _carWeight.frame = CGRectMake(0, CGRectGetMaxY(_carLong.frame) + 20, weight, height);
    
    _carSize.frame = CGRectMake(0, CGRectGetMaxY(_carWeight.frame) + 20, weight, height);
}

#pragma mark - LazyLoad
- (NSMutableArray<NSString *> *)AscriptionArray {
    if (!_AscriptionArray) {
        _AscriptionArray = [NSMutableArray arrayWithObjects:@"京", @"津", @"冀", @"晋", @"蒙", @"辽", @"吉", @"黑", @"沪", @"浙", @"皖", @"闽",@"赣", @"鲁", @"豫", @"鄂", @"湘", @"粤", @"桂", @"琼", @"川", @"贵", @"云", @"渝", @"藏", @"陕",@"甘", @"青", @"宁", @"新", @"港", @"澳", @"台", nil];
    }
    return _AscriptionArray;
}

- (NSMutableArray<NSString *> *)LetterArray {
    if (!_LetterArray) {
        _LetterArray = [NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L",@"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
    return _LetterArray;
}


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
