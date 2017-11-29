
//
//  SFImagePicker.m
//  SFLIS
//
//  Created by chaocaiwei on 2017/11/1.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFImagePicker.h"
@import Photos;
@import AVFoundation;

static SFImagePicker *_shared;

@interface SFImagePicker()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,copy)SFImageResultBlock completion;

@property (nonatomic,strong)UIImagePickerController *pick;

@end

@implementation SFImagePicker

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared  = [super allocWithZone:zone];
    });
    return _shared;
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared  = [super init];
    });
    return _shared;
}

- (id)copy
{
    return _shared;
}

+ (instancetype)shared
{
    if (!_shared) {
        _shared  = [[self alloc] init];
    }
    return _shared;
}


- (void)takePhotoWithSize:(CGSize)size completion:(SFImageResultBlock _Nonnull)completion
{
    if([UIImagePickerController availableMediaTypesForSourceType:(UIImagePickerControllerSourceTypeCamera)]){
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.sourceType  = UIImagePickerControllerSourceTypeCamera;
        pick.allowsEditing   = YES;
        pick.delegate  = self;
        self.pick  = pick;
        self.completion = completion;
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:pick animated:YES completion:^{}];
    }else{
        [[SFTipsView shareView] showFailureWithTitle:@"此设备不支持相机功能"];
        completion(nil);
    }
}
- (void)selectPhotoWithSize:(CGSize)size completion:(SFImageResultBlock _Nonnull)completion
{
    if([UIImagePickerController availableMediaTypesForSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)]){
        [self authLibraryIfNeedCompletion:^(BOOL isSuc) {
            if (isSuc) {
                UIImagePickerController *pick = [[UIImagePickerController alloc] init];
                pick.sourceType  = UIImagePickerControllerSourceTypePhotoLibrary;
                pick.allowsEditing   = YES;
                pick.delegate  = self;
                self.pick  = pick;
                self.completion = completion;
                [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:pick animated:YES completion:^{}];
            }else{
                [[SFTipsView shareView] showFailureWithTitle:@"获取相册权限失败"];
            }
        }];
        
    }else{
        [[SFTipsView shareView] showFailureWithTitle:@"此设备不支持相册功能"];
        completion(nil);
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self)wself = self;
    [self.pick dismissViewControllerAnimated:YES completion:^{
        wself.completion(nil);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    __weak typeof(self)wself = self;
    [self.pick dismissViewControllerAnimated:YES completion:^{
        wself.completion(img);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    
}

- (void)authCameraIfNeedCompletion:(SFBoolResultBlock)completion
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized){
        completion(YES);
    }else if(status == AVAuthorizationStatusDenied){
        completion(NO);
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            completion(granted);
        }];
    }
    
}


- (void)requestCameraAuthCompletion:(SFBoolResultBlock)completion
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusDenied:
                {
                    completion(NO);
                    break;
                }
                default:
                {
                    completion(YES);
                    break;
                }
            }
        });
    }];
}

- (void)authLibraryIfNeedCompletion:(SFBoolResultBlock)completion
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
        {
            [self requestAuthorizationStatusCompletion:completion];
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            completion(NO);
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default:
        {
            completion(YES);
            break;
        }
    }
    
}


- (void)requestAuthorizationStatusCompletion:(SFBoolResultBlock)completion
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusDenied:
                {
                    completion(NO);
                    break;
                }
                default:
                {
                    completion(YES);
                    break;
                }
            }
        });
    }];
}


@end
