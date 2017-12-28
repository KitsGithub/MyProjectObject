//
//  SFPersonalCenterHeaderView.m
//  SFLIS
//
//  Created by kit on 2017/10/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFPersonalCenterHeaderView.h"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//IPHONE5 屏幕尺寸适配
static UIFont *BodyFont;
static UIFont *NormalFont;

static CGFloat UserIconWH;
static CGFloat IconTopPadding;
static CGFloat IconLeftPadding;
static CGFloat IdentflyTopPadding;


@implementation SFPersonalCenterHeaderView {
    UIView *_contentView;
    UIView *_coverView;
    
    UIImageView *_userIcon;
    UILabel *_userName;
    UIImageView *_userIdentfly;
    UILabel *_phone;
    UILabel *_count;
    
    
    UIButton *_IDCard;              //身份证
    UIButton *_BusinessLicense;     //营业执照
    UIButton *_BusinessCard;        //名片照
    UIButton *_MenTou;              //门头照

    
    BOOL hasSubView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    if (iPhone5) {
        BodyFont = [UIFont boldSystemFontOfSize:14];
        NormalFont = [UIFont systemFontOfSize:14];
        
        UserIconWH  = 64;
        IconTopPadding = 23;
        IconLeftPadding = 18;
        IdentflyTopPadding = 23;
    } else {
        BodyFont = [UIFont boldSystemFontOfSize:16];
        NormalFont = FONT_COMMON_16;
        
        UserIconWH  = 74;
        IconTopPadding = 33;
        IconLeftPadding = 23;
        IdentflyTopPadding = 28;
    }
    
    
    SFUserInfo *account = SF_USER;
    
    
    _coverView = [UIView new];
    _coverView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_coverView];
    
    CGFloat scale = 335.0 / 191.0;
    CGFloat contentHeight = (SCREEN_WIDTH - 40) / scale;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(20, STATUSBAR_HEIGHT + 44 + 20, SCREEN_WIDTH - 40, contentHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 10;
    //contentView的阴影
    _contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_contentView.layer.bounds].CGPath;
    _contentView.layer.shadowColor = [[UIColor blackColor] CGColor];//阴影的颜色
    _contentView.layer.shadowOpacity = .1f;   // 阴影透明度
    _contentView.layer.shadowOffset = CGSizeMake(0.0,3.0f); // 阴影的范围
    _contentView.layer.shadowRadius = 5;  // 阴影扩散的范围控制
    [self addSubview:_contentView];
    
    
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(IconLeftPadding, IconTopPadding, UserIconWH, UserIconWH)];
    _userIcon.layer.cornerRadius = UserIconWH * 0.5;
    _userIcon.clipsToBounds = YES;
    [_contentView addSubview:_userIcon];
    
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Resource_URL,account.small_head_src]] placeholderImage:[UIImage imageNamed:@"Default_Head"]];
    
    //头像的阴影
    CALayer *layer = [[CALayer alloc]init];
    layer.position = _userIcon.layer.position;
    layer.bounds = _userIcon.bounds;
    layer.cornerRadius = _userIcon.layer.cornerRadius;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor blackColor].CGColor;  //设置阴影的颜色
    layer.shadowRadius = 2;                           //设置阴影的宽度
    layer.shadowOffset = CGSizeMake(0, 0);            //设置偏移
    layer.shadowOpacity = .2f;
    [_contentView.layer addSublayer:layer];
    [_contentView bringSubviewToFront:_userIcon];
    
    NSString *role;
    if (account.role == SFUserRoleCarownner) {
        role = @"车主";
    } else {
        role = @"货主";
    }
    
    _userName = [UILabel new];
    _userName.text = [account.name stringByAppendingString:[NSString stringWithFormat:@" %@",role]];
    _userName.textColor = BLACKCOLOR;
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.font = BodyFont;
    [_contentView addSubview:_userName];
    
    /**
     用户验证状态
     A 普通用户
     B 用户状态 审核中
     D 认证成功
     F 认证失败
     */
//    User_Unidentification
//    User_Identification
    _userIdentfly = [UIImageView new];
    if ([account.verify_status isEqualToString:@"D"]) {
        //已认证
        _userIdentfly.image = [UIImage imageNamed:@"User_Identification"];
    } else {
        //未认证
        _userIdentfly.image = [UIImage imageNamed:@"User_Unidentification"];
    }
    [_contentView addSubview:_userIdentfly];
    
    _phone = [UILabel new];
    _phone.text = account.mobile;
    _phone.textAlignment = NSTextAlignmentLeft;
    _phone.font = NormalFont;
    _phone.textColor = BLACKCOLOR;
    [_contentView addSubview:_phone];
    
    
    _count = [UILabel new];
    _count.textColor = BLACKCOLOR;
    _count.font = BodyFont;
    _count.text = [NSString stringWithFormat:@"接单数：%@",account.accept_count];
    [_contentView addSubview:_count];
    
    BOOL IconSelected = NO;
    if ([account.verify_status isEqualToString:@"D"]) {
        IconSelected = YES;
    }
    //认证状态
    _IDCard = [UIButton new];
    _IDCard.selected = IconSelected;
    [_IDCard setImage:[UIImage imageNamed:@"Personal_IDCard_Normal"] forState:(UIControlStateNormal)];
    [_IDCard setImage:[UIImage imageNamed:@"Personal_IDCard_Selected"] forState:(UIControlStateSelected)];
    [_IDCard addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:_IDCard];
    
    
    _BusinessLicense = [UIButton new];
    _BusinessLicense.selected = IconSelected;
    [_BusinessLicense setImage:[UIImage imageNamed:@"Personal_BusinessLicense_Normal"] forState:(UIControlStateNormal)];
    [_BusinessLicense setImage:[UIImage imageNamed:@"Personal_BusinessLicense_Selected"] forState:(UIControlStateSelected)];
    [_BusinessLicense addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:_BusinessLicense];
    
    _BusinessCard = [UIButton new];
//    _BusinessCard.selected = IconSelected;
    [_BusinessCard setImage:[UIImage imageNamed:@"Personal_BusinessCard_Normal"] forState:(UIControlStateNormal)];
    [_BusinessCard setImage:[UIImage imageNamed:@"Personal_BusinessCard_Selected"] forState:(UIControlStateSelected)];
    [_BusinessCard addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:_BusinessCard];
    
    _MenTou = [UIButton new];
    _MenTou.selected = IconSelected;
    [_MenTou setImage:[UIImage imageNamed:@"Personal_Mentou_Normal"] forState:(UIControlStateNormal)];
    [_MenTou setImage:[UIImage imageNamed:@"Personal_Mentou_Selected"] forState:(UIControlStateSelected)];
    [_MenTou addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:_MenTou];
    
    hasSubView = YES;
}

- (void)buttonAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
    
}

- (void)reloadData {
    SFUserInfo *account = SF_USER;
    NSString *role;
    if (account.role == SFUserRoleCarownner) {
        role = @"车主";
    } else {
        role = @"货主";
    }
    
    _userName.text = [account.name stringByAppendingString:[NSString stringWithFormat:@" %@",role]];
    
    _count.text = [NSString stringWithFormat:@"接单数：%@",account.accept_count];
    
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Resource_URL,account.small_head_src]] placeholderImage:[UIImage imageNamed:@"Default_Head"]];
    
    _phone.text = account.mobile;
    
    BOOL IconSelected = NO;
    if ([account.verify_status isEqualToString:@"D"]) {
        IconSelected = YES;
    }
    
    _IDCard.selected = IconSelected;
    _BusinessLicense.selected = IconSelected;
    _MenTou.selected = IconSelected;
    
    if ([account.verify_status isEqualToString:@"D"]) {
        //已认证
        _userIdentfly.image = [UIImage imageNamed:@"User_Identification"];
    } else if ([account.verify_status isEqualToString:@"B"]) {
        //认证中
        _userIdentfly.image = [UIImage imageNamed:@"User_Identify"];
    } else {
        //未认证
        _userIdentfly.image = [UIImage imageNamed:@"User_Unidentification"];
    }
    
    hasSubView = YES;
    [self setNeedsLayout];
    
}

- (void)layoutSubviews {
    if (hasSubView) {
        
        _coverView.frame = CGRectMake(0, _contentView.center.y, SCREEN_WIDTH, CGRectGetHeight(self.frame) - _contentView.center.y);
        
        CGSize nameSize = [_userName.text sizeWithFont:BodyFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGSize phoneSize = [_phone.text sizeWithFont:NormalFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGSize countSize = [_count.text sizeWithFont:BodyFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGFloat namePadding = (UserIconWH - nameSize.height - phoneSize.height - countSize.height) / 2;
        
        _userName.frame = CGRectMake(CGRectGetMaxX(_userIcon.frame) + 24, CGRectGetMinY(_userIcon.frame), nameSize.width, nameSize.height);
        
        _userIdentfly.frame = CGRectMake(CGRectGetWidth(_contentView.frame) - 50, 0, 50, 50);
        
        CGFloat phoneX = CGRectGetMinX(_userName.frame);
        _phone.frame = CGRectMake(phoneX, CGRectGetMaxY(_userName.frame) + namePadding, SCREEN_WIDTH - phoneX, phoneSize.height);
        
        _count.frame = CGRectMake(CGRectGetMinX(_userName.frame), CGRectGetMaxY(_phone.frame) + namePadding, countSize.width, countSize.height);
        
        CGFloat padding = (CGRectGetWidth(_contentView.frame) - 34 * 4) / 5.0;
        _IDCard.frame = CGRectMake(padding, CGRectGetMaxY(_userIcon.frame) + IdentflyTopPadding, 34, 26);
        
        CGRect BLFrame = _IDCard.frame;
        BLFrame.origin.x += (padding + BLFrame.size.width);
        _BusinessLicense.frame = BLFrame;
        
        CGRect BCframe = _BusinessLicense.frame;
        BCframe.origin.x += (padding + BLFrame.size.width);
        _BusinessCard.frame = BCframe;
        
        CGRect MTframe = _BusinessCard.frame;
        MTframe.origin.x += (padding + BLFrame.size.width);
        _MenTou.frame = MTframe;
        
        hasSubView = NO;
    }
}

@end
