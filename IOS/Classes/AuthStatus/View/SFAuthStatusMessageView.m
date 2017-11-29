//
//  SFAuthStatusMessageView.m
//  SFLIS
//
//  Created by kit on 2017/11/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthStatusMessageView.h"

@interface SFAuthStatusMessageView () <UITextFieldDelegate>

//@property (nonatomic, strong) NSMutableArray *

@end

@implementation SFAuthStatusMessageView {
    UILabel *_titleView;
    UITextField *_name;     //名字
    UIView *_nameView;
    
    UITextField *_phone;    //电话
    UIView *_phoneView;
    
    UITextField *_idNum;    //身份证
    UIView *_idNumView;
    
    UITextField *_carId;    //驾驶证
    UIView *_carIdView;
    
    UITextField *_sex;      //性别
    UIImageView *_identflyImage;    //认证图片
    
    UIView *_lineView;
}


- (instancetype)initWithFrame:(CGRect)frame authType:(SFAuthType)type{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        self.type = type;
    }
    return self;
}

- (void)setEdittingEnable:(BOOL)edittingEnable {
    _edittingEnable = edittingEnable;
    _name.userInteractionEnabled = _phone.userInteractionEnabled = _idNum.userInteractionEnabled = _carId.userInteractionEnabled = edittingEnable;
    
    if (edittingEnable) {
        _nameView.backgroundColor = _phoneView.backgroundColor = _idNumView.backgroundColor = _carIdView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f3"];
        _titleView.text = @"填写身份信息";
    } else {
        _nameView.backgroundColor = _phoneView.backgroundColor = _idNumView.backgroundColor = _carIdView.backgroundColor = [UIColor whiteColor];
        _titleView.text = @"身份信息";
    }
    
}

- (void)setType:(SFAuthType)type {
    _type = type;
    switch (type) {
        case SFAuthTypeUser:
            [self User];
            break;
        case SFAuthTypeCar:
            [self Car];
            break;
        case SFAuthTypeCarOwnner:
            [self carOwner];
            break;
        default:
            break;
    }
}

- (void)setStatus:(SFAuthStatusModle *)status {
    _status = status;
    
    if (self.type == SFAuthTypeCarOwnner) {
        _name.text = _textField1 = status.driver_by;
        _phone.text = _textField2 = status.driver_mobile;
        _idNum.text = _textField3 = status.idno;
        _carId.text = _textField4 = status.driverno;
        
    } else if (self.type == SFAuthTypeCar) {
        _name.text = _textField1 = status.car_no;
        _phone.text = _textField2 = status.driving_license;
        _idNum.text = _textField3 = status.car_type;
        _carId.text = _textField4 = status.car_long;
        
        _idNum.userInteractionEnabled = _carId.userInteractionEnabled = NO;
        
    } else if (self.type == SFAuthTypeUser) {
        _name.text = _textField1 = status.name;
        _phone.text = _textField2 = status.idno;
    }
    
    if ([status.verify_status isEqualToString:@"D"]) {
        _identflyImage.hidden = NO;
    }
}


- (void)User {
    _phone.placeholder = @"请输入身份号码";
    _idNumView.hidden = YES;
    _carIdView.hidden = YES;
    _sex.hidden = YES;
}

- (void)Car {
    _name.placeholder = @"请输入车牌号码";
    _phone.placeholder = @"请输入车辆识别代号";
    _idNum.placeholder = @"车辆类型";
    _carId.placeholder = @"车辆长度";
}

- (void)carOwner {
    _phone.placeholder = @"请输入司机的电话号码";
    _idNum.placeholder = @"请输入身份证号码";
    _carId.placeholder = @"请输入驾驶证号";
}

- (void)setupView {
    _titleView = [UILabel new];
    _titleView.textColor = COLOR_TEXT_COMMON;
    _titleView.text = @"填写身份信息";
    _titleView.font = [UIFont systemFontOfSize:21];
    [self addSubview:_titleView];
    
    _nameView = [UIView new];
    [self addSubview:_nameView];
    
    _name = [UITextField new];
    _name.font = [UIFont systemFontOfSize:16];
    _name.placeholder = @"姓名与身份证保持一致";
    _name.textColor = COLOR_TEXT_COMMON;
    _name.tag = 1;
    _name.delegate = self;
    [_nameView addSubview:_name];
    
    _phoneView = [UIView new];
    [self addSubview:_phoneView];
    _phone = [UITextField new];
    _phone.font = [UIFont systemFontOfSize:16];
    _phone.textColor = COLOR_TEXT_COMMON;
    _phone.tag = 2;
    _phone.delegate = self;
    [_phoneView addSubview:_phone];
    
    
    _idNumView = [UIView new];
    [self addSubview:_idNumView];
    _idNum = [UITextField new];
    _idNum.font = [UIFont systemFontOfSize:16];
    _idNum.textColor = COLOR_TEXT_COMMON;
    _idNum.tag = 3;
    _idNum.delegate = self;
    [_idNumView addSubview:_idNum];
    
    
    _carIdView = [UIView new];
    [self addSubview:_carIdView];
    _carId = [UITextField new];
    _carId.font = [UIFont systemFontOfSize:16];
    _carId.textColor = COLOR_TEXT_COMMON;
    _carId.tag = 4;
    _carId.delegate = self;
    [_carIdView addSubview:_carId];
    
    _identflyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"认证章"]];
    _identflyImage.hidden = YES;
    [self addSubview:_identflyImage];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
    
    
    
    _nameView.layer.cornerRadius = _phoneView.layer.cornerRadius = _idNumView.layer.cornerRadius = _carIdView.layer.cornerRadius = 10;
    _nameView.clipsToBounds = _phoneView.clipsToBounds = _idNumView.clipsToBounds = _carIdView.clipsToBounds = YES;
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            _textField1 = textField.text;
            break;
        case 2:
            _textField2 = textField.text;
            break;
        case 3:
            _textField3 = textField.text;
            break;
        case 4:
            _textField4 = textField.text;
            break;
        default:
            break;
    }
    return YES;
}


- (void)layoutSubviews {
    _titleView.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, 21);
    
    CGFloat viewX = 20;
    CGFloat viewWidth = SCREEN_WIDTH - viewX * 2;
    CGFloat viewHeight = 48;
    
    _identflyImage.frame = CGRectMake(SCREEN_WIDTH - 100 - 30, CGRectGetMinY(_titleView.frame), 100, 88);
    
    _nameView.frame = CGRectMake(viewX, CGRectGetMaxY(_titleView.frame) + 30, viewWidth, viewHeight);
    _phoneView.frame = CGRectMake(viewX, CGRectGetMaxY(_nameView.frame) + 10, viewWidth, viewHeight);
    _idNumView.frame = CGRectMake(viewX, CGRectGetMaxY(_phoneView.frame) + 10, viewWidth, viewHeight);
    _carIdView.frame = CGRectMake(viewX, CGRectGetMaxY(_idNumView.frame) + 10, viewWidth, viewHeight);
    
    _name.frame = _phone.frame = _idNum.frame = _carId.frame = CGRectMake(10, 0, viewWidth - 20, viewHeight);
    
    CGRect myFrame = self.frame;
    switch (self.type) {
        case SFAuthTypeUser:
            myFrame.size.height = CGRectGetMaxY(_phoneView.frame) + 30;
            break;
        case SFAuthTypeCar:
        case SFAuthTypeCarOwnner:
            myFrame.size.height = CGRectGetMaxY(_carIdView.frame) + 30;
        default:
            break;
    }
    self.frame = myFrame;
    
    _lineView.frame = CGRectMake(viewX, CGRectGetHeight(self.frame) - 1, viewWidth, 1);
}

@end
