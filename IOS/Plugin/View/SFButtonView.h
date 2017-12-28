//
//  SFButtonView.h
//  SFLIS
//
//  Created by kit on 2017/10/13.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFButtonView;

@protocol SFButtonViewDelegate <NSObject>

- (void)SFButtonView:(SFButtonView *)buttonView didSelectedButtonIndex:(NSInteger)index;

@end

@interface SFButtonView : UIView

- (void)setTitleViewWithArray:(NSArray <NSString *>*)titleArray;

@property (nonatomic, assign) CGFloat buttonPadding;

@property (nonatomic, weak) id <SFButtonViewDelegate> delegate;

@property (nonatomic,assign)NSInteger  selectedIndex;

@end
