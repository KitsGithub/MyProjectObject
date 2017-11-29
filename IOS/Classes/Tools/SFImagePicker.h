//
//  SFImagePicker.h
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SFImageResultBlock)(UIImage *_Nullable image);

@interface SFImagePicker : NSObject

+ (instancetype _Nonnull )shared;

- (void)takePhotoWithSize:(CGSize)size completion:(SFImageResultBlock _Nonnull)completion;
- (void)selectPhotoWithSize:(CGSize)size completion:(SFImageResultBlock _Nonnull)completion;





@end
