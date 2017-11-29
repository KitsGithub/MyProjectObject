//
//  SFAdressPickerView.h
//  SFLIS
//
//  Created by kit on 2017/10/12.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFAdressPickerView;
@protocol SFAdressPickerViewDelegate <NSObject>

@required
- (void)SFAdressPickerView:(SFAdressPickerView *_Nullable)picker commitDidSelected:(NSString *_Nullable)adress;


- (void)SFAdressPickerViewDidSelectedCancel:(SFAdressPickerView *_Nullable)picker;

@end

@interface SFAdressPickerView : UIView

@property (nonatomic, weak) id <SFAdressPickerViewDelegate> delegate;

- (void)showAnimation;
- (void)hiddenAnimation;


+ (void)showWithAddress:(NSString * _Nullable )str completion:(void(^_Nullable)(NSString *_Nullable address))completion;
- (void)updateWithAddress:(NSString * _Nonnull)address;

@end
