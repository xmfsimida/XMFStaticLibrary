//
//  UIViewController+XMFPhotoSheet.h
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/7/22.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XMFPhotoSheetFinish)(UIImagePickerController *__nonnull picker, NSDictionary *__nonnull info );

@interface UIViewController (XMFPhotoSheet)<UIActionSheetDelegate, UIImagePickerControllerDelegate>

/*!
 图片选择
 */
- (void)xmf_showPhotoSheetWithPhotoSheetFinish : (XMFPhotoSheetFinish __nullable) finishAction;

/*!
 视频选择
 */
- (void)xmf_showViewMovieWithPhotoSheetFinish : (XMFPhotoSheetFinish __nullable)
finishAction authorityTips : (NSString * _Nullable)authorityTips;

/*!
 录制视频
 */
- (void)xmf_showViewRecordVideoWithPhotoSheetFinish : (XMFPhotoSheetFinish __nullable)
finishAction authorityTips : (NSString * _Nullable)authorityTips;

/*!
 判断权限
 */
- (BOOL)requestMediaCapturerAccessWithCompletionHandler:(void (^ _Nullable)(BOOL, NSError* _Nullable))handler;


@end
