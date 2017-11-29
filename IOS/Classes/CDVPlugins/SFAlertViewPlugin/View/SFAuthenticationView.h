//
//  SFAuthenticationView.h
//  SFLIS
//
//  Created by kit on 2017/10/26.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAlertViewProtocol.h"

@interface SFAuthenticationView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel confirm:(NSString *)comfirm delegate:(id<SFAlertViewProtocol>)delegate;

@property (nonatomic, weak) id <SFAlertViewProtocol> delegate;

- (void)showAnimation;
- (void)hiddenAnimation;
@end
