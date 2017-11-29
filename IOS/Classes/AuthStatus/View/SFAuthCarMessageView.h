//
//  SFAuthCarMessageView.h
//  SFLIS
//
//  Created by kit on 2017/11/23.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFAuthCarMessageView : UIView {
    UIView *_name;
}

@property (nonatomic, strong) SFAuthStatusModle *status;
@property (nonatomic, assign) BOOL edittingEnable;

- (NSMutableDictionary *)getCarMessageJson;

@end
