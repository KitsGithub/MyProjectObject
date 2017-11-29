//
//  SFCustomTextView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/10/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCustomTextView : UIView
{
    NSString *_text;
    NSString *_placeholder;
}
@property (nonatomic,copy)NSString *text;

@property (nonatomic,copy)NSString *placeholder;

@end
