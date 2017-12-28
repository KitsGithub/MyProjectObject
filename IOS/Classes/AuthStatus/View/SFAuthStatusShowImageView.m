//
//  SFAuthStatusShowImageView.m
//  SFLIS
//
//  Created by kit on 2017/11/20.
//  Copyright © 2017年 chaocaiwei. All rights reserved.
//

#import "SFAuthStatusShowImageView.h"
#import "SFAuthImageView.h"
#import "SFImagePicker.h"

@interface SFAuthStatusShowImageView ()

@property (nonatomic, strong) NSMutableArray <SFAuthImageView *>*imageViewArray;

@property (nonatomic, strong) NSMutableArray <NSString *>*placeHolderImageArray;

@property (nonatomic, strong) NSMutableDictionary *imageDic;
@end

@implementation SFAuthStatusShowImageView {
    UILabel *_titleLabel;
    UIView *_lineView;
    
}

- (instancetype)initWithFrame:(CGRect)frame authType:(SFAuthType)type statusModel:(SFAuthStatusModle *)statusModel{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        self.statusModel = statusModel;
        self.type = type;
    }
    return self;
}

- (void)setType:(SFAuthType)type {
    _type = type;
    
    switch (type) {
        case SFAuthTypeUser:
            [self User];
            break;
        case SFAuthTypeCar:
            [self Car];
            break;
        case SFAuthTypeCarOwnner:
            [self carOwner];
            break;
        default:
            break;
    }
}

- (NSDictionary *)getImageArray {
    return [self.imageDic copy];
}

#pragma mark - SetImageV
- (SFAuthImageView *)setImageViewWithURL:(NSString *)url placeHolderImage:(NSString *)placeHolderImageStr {
    SFAuthImageView *imageView = [[SFAuthImageView alloc] initWithImage:[UIImage imageNamed:placeHolderImageStr] placeHolderText:placeHolderImageStr];
    
    __weak typeof(placeHolderImageStr) wPlaceStr = placeHolderImageStr;
    __weak typeof(self) weakSelf = self;
    [imageView setTapAction:^(UIImageView *imageV) {
        if (!weakSelf.edittingEnable) {
            return ;
        }
        [weakSelf imagePickWithImageView:imageV completion:^(UIImage *isSuc) {
            if (isSuc) {
                NSData *imageData = UIImageJPEGRepresentation(isSuc, 0.6);
                [weakSelf.imageDic addEntriesFromDictionary:@{ wPlaceStr : imageData }];
            }
        }];
    }];
    if (url) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeHolderImageStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
                [weakSelf.imageDic addEntriesFromDictionary:@{ wPlaceStr : imageData }];
            }
        }];
    }
    return imageView;
}


- (void)setEdittingEnable:(BOOL)edittingEnable {
    _edittingEnable = edittingEnable;
    
    
}


#pragma mark - 打开相册
- (void)imagePickWithImageView:(UIImageView *)imgView completion:(SFImageResultBlock)completion
{
    CGSize size = CGSizeMake(142 * 2, 88 * 2);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择获取图片的方式" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[SFImagePicker shared] takePhotoWithSize:size completion:^(UIImage * _Nullable image) {
            if (image) {
                imgView.image  = image;
            }
            completion(image);
        }];
    }];
    
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[SFImagePicker shared] selectPhotoWithSize:size completion:^(UIImage * _Nullable image) {
            if (image) {
                imgView.image  = image;
            }
            completion([self compressImage:image]);
        }];
    }];
    UIAlertAction *a3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:a1];
    [alert addAction:a2];
    [alert addAction:a3];
    [_wSelfVC presentViewController:alert animated:YES completion:^{}];
    
}

- (UIImage *)compressImage:(UIImage *)img
{
    [self image:img fortargetSize:CGSizeMake(142 * 6, 88 * 6)];
    CGFloat max = sqrt(1024*1024);
    CGFloat width = img.size.width > max ? max : img.size.width;
    CGFloat height = width * img.size.height / img.size.width;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *resImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImg;
}

-(UIImage*)image:(UIImage*)image fortargetSize: (CGSize)targetSize{
    
    UIImage*sourceImage = image;
    CGSize imageSize = sourceImage.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    NSInteger judge;
    
    CGFloat targetWidth = targetSize.width;//获取最终的目标宽度尺寸
    CGFloat targetHeight = targetSize.height;//获取最终的目标高度尺寸
    
    CGFloat scaleFactor ;//先声明拉伸的系数
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint =CGPointMake(0.0,0.0);//这个是图片剪切的起点位置
    
    //第一个判断,图片大小宽跟高都小于目标尺寸,直接返回image
    if( imageHeight < targetHeight && imageWidth < targetWidth) {
        return image;
    }
    if (CGSizeEqualToSize(imageSize, targetSize)) {
        return image;
    }
    
    CGFloat widthFactor = targetWidth / imageWidth;
    CGFloat heightFactor = targetHeight / imageHeight;
    
    if(widthFactor <1&& heightFactor<1){
        
        //第一种,需要判断要缩小哪一个尺寸,这里看拉伸尺度,我们的scale在小于1的情况下,谁越小,等下就用原图的宽度高度✖️那一个系数(这里不懂的话,代个数想一下,例如目标800*480  原图1600*800  系数就采用宽度系数widthFactor = 1/2  )
        if(widthFactor > heightFactor){
            
            judge =1;//右部分空白
            
            scaleFactor = heightFactor; //修改最后的拉伸系数是高度系数(也就是最后要*这个值)
            
        }else{
            
            judge =2;//下部分空白
            
            scaleFactor = widthFactor;
            
        }
        
    }else if(widthFactor >1&& heightFactor <1){
        
        //第二种,宽度不够比例,高度缩小一点点(widthFactor大于一,说明目标宽度比原图片宽度大,此时只要拉伸高度系数)
        
        judge =3;//下部分空白
        
        //采用高度拉伸比例
        
        scaleFactor = imageWidth / targetWidth;// 计算高度缩小系数
        
    }else if( heightFactor > 1 && widthFactor < 1){
        
        //第三种,高度不够比例,宽度缩小一点点(heightFactor大于一,说明目标高度比原图片高度大,此时只要拉伸宽度系数)
        
        judge =4;//下边空白
        
        //采用高度拉伸比例
        scaleFactor = imageHeight / targetWidth;
        
    }else{
        
        //第四种,此时宽度高度都小于目标尺寸,不必要处理放大(如果有处理放大的,在这里写).
        
    }
    
    scaledWidth= imageWidth * scaleFactor;
    
    scaledHeight = imageHeight * scaleFactor;
    
    if(judge ==1){
        //右部分空白
        targetWidth = scaledWidth;//此时把原来目标剪切的宽度改小,例如原来可能是800,现在改成780
        
    }else if(judge ==2){
        //下部分空白
        targetHeight = scaledHeight;
        
    }else if(judge ==3){
        
        //第三种,高度不够比例,宽度缩小一点点
        
        targetWidth = scaledWidth;
        
    }else{
        
        //第三种,高度不够比例,宽度缩小一点点
        
        targetHeight= scaledHeight;
        
    }
    
    UIGraphicsBeginImageContext(targetSize);//开始剪切
    
    CGRect thumbnailRect =CGRectZero;//剪切起点(0,0)
    
    thumbnailRect.origin= thumbnailPoint;
    
    thumbnailRect.size.width= scaledWidth;
    
    thumbnailRect.size.height= scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
    
    return newImage;
    
}

#pragma mark - 用户认证
- (void)User {
    for (NSInteger index = 0; index < self.placeHolderImageArray.count; index ++) {
        NSString *url;
        switch (index) {
            case 0:
                url = [NSString stringWithFormat:@"%@",self.statusModel.idCardUrl];;
                
                break;
            case 1:
                url = [NSString stringWithFormat:@"%@",self.statusModel.idCardBackUrl];;
                
                break;
            case 2:
                url = [NSString stringWithFormat:@"%@",self.statusModel.lifePhotoUrl];;
                
                break;
            case 3:
                url = [NSString stringWithFormat:@"%@",self.statusModel.businessLicenseUrl];;
                
                break;
            case 4:
                url = [NSString stringWithFormat:@"%@",self.statusModel.shopPhotoUrl];;
                
            default:
                break;
        }
        SFAuthImageView *imageView = [self setImageViewWithURL:url placeHolderImage:self.placeHolderImageArray[index]];
        [self addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
}

#pragma mark - 车辆认证
- (void)Car {
    for (NSInteger index = 0; index < self.placeHolderImageArray.count; index ++) {
        NSString *url;
        switch (index) {
            case 0:
                url = [NSString stringWithFormat:@"%@",self.statusModel.DrivingCard];
                break;
            case 1:
                url = [NSString stringWithFormat:@"%@",self.statusModel.DrivingCardBack];
                
                break;
            case 2:
                url = [NSString stringWithFormat:@"%@",self.statusModel.CarAPhoto];
                
                break;
            case 3:
                url = [NSString stringWithFormat:@"%@",self.statusModel.CarBPhoto];
                
                break;
            case 4:
                url = [NSString stringWithFormat:@"%@",self.statusModel.CarCPhoto];
                
            default:
                break;
        }
        SFAuthImageView *imageView = [self setImageViewWithURL:url placeHolderImage:self.placeHolderImageArray[index]];
        [self addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
}

#pragma mark - 车主认证
- (void)carOwner {
    for (NSInteger index = 0; index < self.placeHolderImageArray.count; index ++) {
        
        NSString *url;
        switch (index) {
            case 0:
                url = [NSString stringWithFormat:@"%@",self.statusModel.driverUrl];;
                
                break;
            case 1:
                url = [NSString stringWithFormat:@"%@",self.statusModel.driverBUrl];;
                
                break;
            case 2:
                url = [NSString stringWithFormat:@"%@",self.statusModel.lifePhotoUrl];;
                
                break;
            default:
                break;
        }
        
        SFAuthImageView *imageView = [self setImageViewWithURL:url placeHolderImage:self.placeHolderImageArray[index]];
        [self addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
}


#pragma mark - 布局
- (void)setupView {
    _titleLabel = [UILabel new];
    _titleLabel.textColor = COLOR_TEXT_COMMON;
    _titleLabel.font = [UIFont systemFontOfSize:21];
    _titleLabel.text = @"上传证件照片";
    [self addSubview:_titleLabel];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = COLOR_LINE_DARK;
    [self addSubview:_lineView];
}

- (void)layoutSubviews {
    _titleLabel.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, 21);
    _lineView.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 1, SCREEN_WIDTH - 40, 1);
    
    
    CGFloat imageW = (CGRectGetWidth(self.frame) - 60) / 2 > 140 ? 140 : (SCREEN_WIDTH - 60) / 2;
    CGFloat imageH = imageW / (140 / 88.0);
    CGFloat baseY = CGRectGetMaxY(_titleLabel.frame) + 30;
    UIView *lastView;
    for (NSInteger index = 0; index < self.imageViewArray.count; index++) {
        UIImageView *imageV = self.imageViewArray[index];
        
        CGFloat row = index / 2;        //行
        CGFloat columns = index % 2;    //列
        
        CGFloat imageY = row > 0 ? (baseY + row * imageH + 20 *row) : baseY;
        CGFloat imageX = columns > 0 ? (columns * imageW + 20 + 20 *columns) : 20;
        
        imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        
        lastView = imageV;
    }
    
}


#pragma mark - layout
- (NSMutableArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (NSMutableArray *)placeHolderImageArray {
    if (!_placeHolderImageArray) {
        _placeHolderImageArray = [NSMutableArray array];
        if (self.type == SFAuthTypeUser) {
            [_placeHolderImageArray addObjectsFromArray:@[@"身份证正面",@"身份证背面",@"生活照",@"营业执照",@"门头照"]];
        } else if (self.type == SFAuthTypeCar) {
            [_placeHolderImageArray addObjectsFromArray:@[@"行驶证主页",@"行驶证副页",@"车侧照",@"车头照",@"车尾照"]];
        } else {
            [_placeHolderImageArray addObjectsFromArray:@[@"行驶证主页",@"行驶证副页",@"生活照"]];
        }
    }
    return _placeHolderImageArray;
}

- (NSMutableDictionary *)imageDic {
    if (!_imageDic) {
        _imageDic = [NSMutableDictionary dictionary];
    }
    return _imageDic;
}

@end
