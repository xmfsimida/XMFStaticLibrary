//
//  UIView+Category.h
//  Sfunchat
//
//  Created by mr kiki on 16/3/14.
//  Copyright © 2016年 外语高手. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, XMFLineOptions){
    XMFLineOptionsTop = 1 << 0,
    XMFLineOptionsLeft = 1 << 1,
    XMFLineOptionsBottom = 1 << 2,
    XMFLineOptionsRight = 1 << 3
};

@interface UIView (XMFCategory)

/*!
 获得view所在的viewController
 */
- (UIViewController *_Nullable)xmf_getBelongViewController;

/*!
 获取父类的颜色
 */
- (UIColor *_Nullable)xmf_getSuperViewBackgroundColor;

/*!
 添加圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat xmf_cornerRadius;

/*!
 添加蒙版圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat xmf_maskCornerRadius;

/*!
 改变蒙版颜色
 */
- (void)xmf_changeMashColor: (UIColor *_Nonnull)color;

/*!
 还原蒙版颜色
 */
- (void)xmf_reductionMashColor;

/*!
 添加蒙版圆角 如果option等于-404不做任何操作
 */
- (void)xmf_setMaskCornerRadiusWithUIRectCorner:(UIRectCorner)options CornerRadius:(CGFloat)cornerRadius;

-(CABasicAnimation *_Nonnull)rotationDuration:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount;

/*!
 添加圆角框
 */
- (void)xmf_setRoundedBoxWithCornerRadius : (CGFloat) cornerRadius
                                     color: (UIColor *_Nullable) color;

- (void)xmf_setRoundedBoxWithCornerRadius:(CGFloat)cornerRadius
                                    color:(UIColor *_Nullable)color
                               lineWidth : (CGFloat) lineWidth;
- (void)xmf_removeRoundedBox;

/*!
 改变图片的颜色
 */
- (UIImage *_Nonnull)imageWithColor:(UIColor *_Nonnull)color image:(UIImage *_Nonnull)image;

/*!
 添加边框
 */
- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions
                                color : (UIColor *_Nullable)color
                            lineWidth : (CGFloat)lineWidth;

- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions
                                color : (UIColor *_Nullable)color;

- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions
                            lineWidth : (CGFloat)lineWidth;

- (void)xmf_lineAddWithXMFLineOptions : (XMFLineOptions)lineOptions;

/*!
 添加自适应边框
 */
- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions
                                    color : (UIColor *_Nullable)color
                                lineWidth : (CGFloat)lineWidth
                                  padding : (CGFloat)padding;

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions
                                    color : (UIColor *_Nullable)color
                                lineWidth : (CGFloat)lineWidth;

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions
                                    color : (UIColor *_Nullable)color;

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions
                                lineWidth : (CGFloat)lineWidth;

- (void)xmf_autoLineAddWithXMFLineOptions : (XMFLineOptions)lineOptions;

@end

@interface UIView (XMFAnimation)

/*!
 已y轴旋转一圈
 */
- (void)xmf_addYRotateWithDuration : (CGFloat) duration
                      autoreverses : (BOOL) autoreverses;

/*!
 透明度变化
 */
- (void)xmf_addChangeOpacityWithDuration : (CGFloat) duration
                               fromValue : (CGFloat) fromValue
                                 toValue : (CGFloat) toValue
                            autoreverses : (BOOL) autoreverses;

/*!
 大小变化
 */
- (void)xmf_addChangeScaleWithDuration : (CGFloat) duration
                             fromValue : (CGFloat) fromValue
                               toValue : (CGFloat) toValue
                          autoreverses : (BOOL) autoreverses;

/*!
 平移
 */
- (void)xmf_addMoveXWithDuration : (CGFloat) duration
                       fromValue : (CGFloat) fromValue
                         toValue : (CGFloat) toValue
                    autoreverses : (BOOL) autoreverses;
@end
