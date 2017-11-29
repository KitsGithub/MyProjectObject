//
//  SFMultiOprationImageView.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/2.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOprationImageView.h"

@interface SFMultiOprationImageModel : NSObject


@end


@interface SFMultiOprationImageView : UIView
{
    CGFloat _calculateHeihgt;
}
@property (nonatomic,assign)NSInteger  numberOfItem;



- (void)addItemsWithDesc:(NSString *_Nullable)desc image:(UIImage *_Nullable)image url:(NSString
                                                                                        *_Nullable)url action:(SFOprationImageViewResultBlock _Nullable )action;

- (void)reset;

- (CGFloat)calculateHeihgt;

- (void)setUrls:(NSArray <NSString *>*_Nullable)urls placeHolds:(NSArray <UIImage *>*)images;

@end
