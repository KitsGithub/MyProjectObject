//
//  SFAuthStatusMessageView.h
//  SFLIS
//
//  Created by kit on 2017/11/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAuthStatusModle.h"

@interface SFAuthStatusMessageView : UIView

- (instancetype)initWithFrame:(CGRect)frame authType:(SFAuthType)type;
@property (nonatomic, assign) SFAuthType type;
@property (nonatomic, strong) SFAuthStatusModle *status;
@property (nonatomic, assign) BOOL edittingEnable;


@property (nonatomic, copy, readonly) NSString *textField1;
@property (nonatomic, copy, readonly) NSString *textField2;
@property (nonatomic, copy, readonly) NSString *textField3;
@property (nonatomic, copy, readonly) NSString *textField4;

@end
