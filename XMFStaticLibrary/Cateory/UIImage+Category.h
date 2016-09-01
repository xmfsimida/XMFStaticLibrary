//
//  UIImage+Category.h
//  ChatDemo
//
//  Created by xumingfa on 16/4/6.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

- (UIImage *)byScalingToSize:(CGSize)targetSize;

+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size;

+ (CGSize)countImageSizeWithSize : (CGSize) size maxHeight : (CGFloat)maxHeight;

//  image转base64
- (NSString *)base64WithCompressionQuality : (CGFloat) compressionQuality;

/*!
 通过url获取视频截图
 */
+ (void)getThumbnailImage:(NSURL *)videoURL block : (void (^) (UIImage *image)) block;
@end
