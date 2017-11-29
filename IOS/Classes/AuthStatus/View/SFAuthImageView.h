//
//  SFAuthImageView.h
//  SFLIS
//
//  Created by kit on 2017/11/21.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageTapBlock)(UIImageView *image);

@interface SFAuthImageView : UIImageView

- (instancetype)initWithImage:(UIImage *)image placeHolderText:(NSString *)str;

@property (nonatomic, copy) ImageTapBlock tapAction;

@end
