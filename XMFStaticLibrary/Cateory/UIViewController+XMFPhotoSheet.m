//
//  UIViewController+XMFPhotoSheet.m
//  FunChatStaticLibrary
//
//  Created by xumingfa on 16/7/22.
//  Copyright © 2016年 xumingfa. All rights reserved.
//

#import "UIViewController+XMFPhotoSheet.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
#import "XMFToastView.h"

@implementation UIViewController (XMFPhotoSheet)

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

static char xmf_PhotoSheetFinishAction;
static char xmf_PhotoSheetApplicationStatusStyle;

- (XMFPhotoSheetFinish)finishAction {
    
    return objc_getAssociatedObject(self, &xmf_PhotoSheetFinishAction);
}

- (void)setFinishAction:(XMFPhotoSheetFinish)finishAction {
    
    objc_setAssociatedObject(self, &xmf_PhotoSheetFinishAction, finishAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)xmf_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag {
    
    [self presentViewController:viewControllerToPresent animated:flag completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    }];
}
- (void)xmf_showPhotoSheetWithPhotoSheetFinish:(XMFPhotoSheetFinish)finishAction {
    
    objc_setAssociatedObject(self, &xmf_PhotoSheetApplicationStatusStyle, @([UIApplication sharedApplication].statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.finishAction = finishAction;
    
    UIImagePickerController *pickView = [[UIImagePickerController alloc] init];
    // 相机
    pickView.delegate = self;
    pickView.allowsEditing = YES;
    
    __weak typeof(self) weakSelf = self;
    if (IOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Acquire Photo（获取图片）" message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){// 判断是否支持相机
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Take Photo（拍照）" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {// 相机
                pickView.sourceType = UIImagePickerControllerSourceTypeCamera;
                [weakSelf xmf_presentViewController:pickView animated:YES];
            }];
            [alertController addAction:defaultAction];
        }
        UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"Choose From Photos（从相册中选）" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {    // 相册
            pickView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [weakSelf xmf_presentViewController:pickView animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel（取消）" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:defaultAction1];
        
        //  弹出视图 使用UIViewController的方法
        [weakSelf presentViewController:alertController animated:YES completion:NULL];
    } else {
        UIActionSheet *sheet = nil;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){// 判断是否支持相机
            sheet  = [[UIActionSheet alloc] initWithTitle:@"Acquire Photo（获取图片）" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel（取消）" otherButtonTitles:@"Take Photo（拍照）", @"Choose From Photos（从相册中选）", nil];
            
        }else {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"Acquire Photo（获取图片）" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel（取消）" otherButtonTitles:@"Choose From Photos（从相册中选）", nil];
        }
        [sheet showInView:self.view];
    }
}

- (void)xmf_showViewRecordVideoWithPhotoSheetFinish:(XMFPhotoSheetFinish)finishAction authorityTips:(NSString *)authorityTips {
    
    objc_setAssociatedObject(self, &xmf_PhotoSheetApplicationStatusStyle, @([UIApplication sharedApplication].statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.finishAction = finishAction;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //    iOS 判断应用是否有使用相机的权限
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            [XMFToastView showToastViewToView:self.view content:authorityTips duration:2];
            return;
        }
        else {
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityType640x480];
            [imagePickerController setVideoMaximumDuration:20.f];
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self xmf_presentViewController:imagePickerController animated:YES];
        }
    }
}

- (void)xmf_showViewMovieWithPhotoSheetFinish:(XMFPhotoSheetFinish)finishAction authorityTips:(NSString *)authorityTips{
    
    objc_setAssociatedObject(self, &xmf_PhotoSheetApplicationStatusStyle, @([UIApplication sharedApplication].statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.finishAction = finishAction;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self xmf_presentViewController:imagePickerController animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *pickView = [[UIImagePickerController alloc] init];
    // 相机
    pickView.delegate = self;
    pickView.allowsEditing = YES;
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                // 取消
                return;
            case 1:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    } else {
        
        if (buttonIndex == 0) {
            // 取消
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }
        
    }
    // 跳转到相机或相册页面
    pickView.sourceType = sourceType;
    [self xmf_presentViewController:pickView animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIStatusBarStyle statusBarStyle = [objc_getAssociatedObject(self, &xmf_PhotoSheetApplicationStatusStyle) integerValue];
    [[UIApplication sharedApplication] setStatusBarStyle: statusBarStyle];
    if (self.finishAction) self.finishAction(picker, info);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    UIStatusBarStyle statusBarStyle = [objc_getAssociatedObject(self, &xmf_PhotoSheetApplicationStatusStyle) integerValue];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle: statusBarStyle];
    }];
}

/*!
 应用程序需要事先申请音视频使用权限
 */
- (BOOL)requestMediaCapturerAccessWithCompletionHandler:(void (^)(BOOL, NSError*))handler {
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus && AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        if (handler) handler(YES,nil);
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(NO,error);
            
            return NO;
        }
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问麦克风，请设置", @"此应用需要访问麦克风，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            if (handler) handler(NO,error);
            return NO;
        }
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                       if (handler) handler(YES,nil);
                    }else{
                        NSString *errMsg = NSLocalizedString(@"不允许访问麦克风", @"不允许访问麦克风");
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                        NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                        if (handler) handler(NO,error);
                    }
                }];
            }else{
                NSString *errMsg = NSLocalizedString(@"不允许访问摄像头", @"不允许访问摄像头");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                if (handler) handler(NO,error);
            }
        }];
        
    }
    return YES;
}

@end
