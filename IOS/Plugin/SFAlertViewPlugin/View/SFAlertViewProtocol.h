//
//  SFAlertViewProtocol.h
//  SFLIS
//
//  Created by kit on 2017/10/27.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFAlertViewProtocol <NSObject>

@optional
- (void)SFAlertView:(NSObject *)alertView didSelectedIndex:(NSInteger)index;
- (void)SFAlertViewDidSelecetedCancel:(NSObject *)alertView;

@end
