//
//  SFDriverSignAlerView.m
//  SFLIS
//
//  Created by kit on 2017/11/22.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFDriverSignAlerView.h"
#import <CoreLocation/CoreLocation.h>

@interface SFDriverSignAlerView ()
//定位功能
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) CLGeocoder *geocoder;

@end

@implementation SFDriverSignAlerView {
    UIButton *_bjView;
    UIView *_contentView;
    
    UIImageView *_tipsView;
    UILabel *_tipsLabe;
    UILabel *_locationLabel;
    
    UIButton *_comfirmButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self getCurrentLoaction];
        [self setupView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)getCurrentLoaction {
    //定位
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.manager requestWhenInUseAuthorization];
    }
    [self.manager startUpdatingLocation];
}

- (void)setupView {
    self.alpha = 0.0f;
    
    _bjView = [UIButton new];
    _bjView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [_bjView addTarget:self action:@selector(dismissAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_bjView];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _tipsView = [[UIImageView alloc] init];
    _tipsView.image = [UIImage imageNamed:@"Loaction_Tips"];
    [_contentView addSubview:_tipsView];
    
    _tipsLabe = [UILabel new];
    _tipsLabe.font = [UIFont boldSystemFontOfSize:20];
    _tipsLabe.textColor = COLOR_TEXT_COMMON;
    _tipsLabe.textAlignment = NSTextAlignmentCenter;
    _tipsLabe.text = @"签到成功";
    [_contentView addSubview:_tipsLabe];
    
    _locationLabel = [UILabel new];
    _locationLabel.numberOfLines = 2;
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.font = FONT_COMMON_16;
    _locationLabel.textColor = COLOR_TEXT_COMMON;
    _locationLabel.text = @"完成此次签到，您已到达 保定市";
    [_contentView addSubview:_locationLabel];
    
    
    _comfirmButton = [UIButton new];
    [_contentView addSubview:_comfirmButton];
    [_comfirmButton addTarget:self action:@selector(hiddenAnimation) forControlEvents:(UIControlEventTouchUpInside)];
    [_comfirmButton setBackgroundColor:THEMECOLOR];
    [_comfirmButton setTitleColor:COLOR_TEXT_COMMON forState:(UIControlStateNormal)];
    [_comfirmButton setTitle:@"完成" forState:(UIControlStateNormal)];
    _comfirmButton.titleLabel.font = FONT_COMMON_16;
    
    
}

#pragma mark - UIAction
- (void)dismissAction {
    [self hiddenAnimation];
}

- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0f;
    }];
}
- (void)hiddenAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 定位功能
//授权状态发生改变的时候调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"用户拒绝");
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
        CLPlacemark *placemark=[placemarks firstObject];
        NSString * _provinceName = placemark.addressDictionary[@"City"];
        NSString * _areaName = placemark.addressDictionary[@"SubLocality"];
        if (_provinceName.length && _areaName.length) {
            NSString * currentLoaction = [NSString stringWithFormat:@"%@ %@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"]];
            NSLog(@"位置信息 ---->  %@",currentLoaction);
        }
    }];
}


#pragma mark - layout
- (void)layoutSubviews {
    _bjView.frame = self.bounds;
    
    CGFloat scale = 300 / 450.0;
    CGFloat contentW = SCREEN_WIDTH - 38*2;
    CGFloat contentH = contentW / scale;
    _contentView.frame = CGRectMake(38, (SCREEN_HEIGHT - contentH) * 0.5, contentW, contentH);
    
    
    CGFloat imageScale = 200 / 450.0f;
    CGFloat tipsH = contentH * imageScale;
    _tipsView.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), tipsH);
    
    CGFloat paddingY = contentH * (50 / 450.0f);
    _tipsLabe.frame = CGRectMake(0, CGRectGetMaxY(_tipsView.frame) + paddingY, contentW, 20);
    
    CGFloat loactionX = contentW * (30 / 300.0f);
    CGFloat loactionY = CGRectGetMaxY(_tipsLabe.frame) + (contentH * (30 / 450.0f));
    CGSize locationSize = [_locationLabel.text sizeWithFont:FONT_COMMON_16 maxSize:CGSizeMake(contentW - loactionX * 2, MAXFLOAT)];
    _locationLabel.frame = CGRectMake(loactionX, loactionY, locationSize.width, locationSize.height);
    
    CGFloat comfirmX = contentW * (20 / 300.0f);
    _comfirmButton.frame = CGRectMake(comfirmX, CGRectGetHeight(_contentView.frame) - 40 - 44, contentW - comfirmX * 2, 44);
}


#pragma mark - lazyLoad
- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
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
