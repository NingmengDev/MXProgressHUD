//
//  MXProgressHUD.m
//  MXProgressHUD
//
//  Created by 韦纯航 on 16/4/29.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXProgressHUD.h"

#import "MBProgressHUD.h"

#pragma mark - MXProgressHUDConfig

@interface MXProgressHUDConfig : NSObject

#define MXHUD_DEFAULT_BUNDLE @"MXProgressHUD.bundle"

@property (strong, nonatomic) NSCache *bundleImageCache;

@property (copy, nonatomic) NSString *hudBundlePath;

+ (instancetype)instance;

- (UIImage *)imageInHudBundle:(NSString *)name;

@end

@implementation MXProgressHUDConfig

+ (instancetype)instance
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

- (NSCache *)bundleImageCache
{
    if (!_bundleImageCache) {
        _bundleImageCache = [NSCache new];
        _bundleImageCache.countLimit = 100;
    }
    return _bundleImageCache;
}

- (NSString *)hudBundlePath
{
    if (!_hudBundlePath) {
        _hudBundlePath = [MXHUD_DEFAULT_BUNDLE copy];
    }
    return _hudBundlePath;
}

- (UIImage *)imageInHudBundle:(NSString *)name
{
    id obj = [self.bundleImageCache objectForKey:name];
    if (obj) return obj;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], [self hudBundlePath]];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    path = [NSString stringWithFormat:@"%@@2x", name];
    path = [bundle pathForResource:path ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image)[self.bundleImageCache setObject:image forKey:name];
    return image;
}

@end

#pragma mark - MXProgressHUD

@implementation MXProgressHUD

extern UIWindow *mx_keyWindow()
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    if (window) return window;
    
    id delegate = app.delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        window = [delegate window];
    }
    return window;
}

extern UIImage *mx_imageInHudBundle(NSString *name)
{
    return [[MXProgressHUDConfig instance] imageInHudBundle:name];
}

extern NSTimeInterval displayDurationForString(NSString *string)
{
    return MIN((float)string.length * 0.06 + 0.5, 5.0);
}

static MBProgressHUD *_messageHub;

#pragma mark - Public

/**
 *  显示一个成功结果的HUD（显示完成后会自动隐藏）
 *
 *  @param message 提示文字
 */
+ (void)showSuccessWithStatus:(NSString *)message
{
    [self showLoadingProgressWithMode:MBProgressHUDModeCustomView
                              message:message
                                image:@"mx_hud_success"
                                delay:displayDurationForString(message)];
}

/**
 *  显示一个错误结果的HUD（显示完成后会自动隐藏）
 *
 *  @param message 提示文字
 */
+ (void)showErrorWithStatus:(NSString *)message
{
    [self showLoadingProgressWithMode:MBProgressHUDModeCustomView
                              message:message
                                image:@"mx_hud_error"
                                delay:displayDurationForString(message)];
}

/**
 *  显示一个只带文字的HUD（显示后在指定时间之后自动隐藏）
 *
 *  @param message 提示文字
 *  @param delay   显示持续时间
 */
+ (void)showLoadingProgressWithMessage:(NSString *)message delay:(NSTimeInterval)delay
{
    [self showLoadingProgressWithMode:MBProgressHUDModeText
                              message:message
                                image:nil
                                delay:delay];
}

/**
 *  显示一个等待状态的HUD（显示后不会自动隐藏）
 *  需调用hideLoadingProgress隐藏
 */
+ (void)showLoadingProgress
{
    [self showLoadingProgressWithMessage:nil];
}

/**
 *  显示一个带有提示文字的等待状态HUD（显示后不会自动隐藏）
 *  需调用hideLoadingProgress隐藏
 *
 *  @param message 提示文字
 */
+ (void)showLoadingProgressWithMessage:(NSString *)message
{
    [self showLoadingProgressWithMode:MBProgressHUDModeIndeterminate
                              message:message
                                image:nil
                                delay:MAXFLOAT];
}

/**
 *  显示一个提示文字后隐藏
 *
 *  @param message 提示文字
 */
+ (void)hideWithMessage:(NSString *)message
{
    [self hideWithStatus:message image:nil];
}

/**
 *  显示一个成功状态后隐藏HUD
 *
 *  @param message 提示文字
 */
+ (void)hideWithSuccessStatus:(NSString *)message
{
    [self hideWithStatus:message image:@"mx_hud_success"];
}

/**
 *  显示一个错误状态后隐藏HUD
 *
 *  @param message 提示文字
 */
+ (void)hideWithErrowStatus:(NSString *)message
{
    [self hideWithStatus:message image:@"mx_hud_error"];
}

/**
 *  立即隐藏所有显示的HUD
 */
+ (void)hideLoadingProgress
{
    UIView *view = mx_keyWindow();
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

#pragma mark - Private

/**
 *  配置HUD属性
 *
 *  @param mode      显示类型
 *  @param message   提示文字
 *  @param imageName 显示图片名称
 *  @param delay     显示持续时间
 */
+ (void)showLoadingProgressWithMode:(MBProgressHUDMode)mode message:(NSString *)message image:(NSString *)imageName delay:(NSTimeInterval)delay
{
    UIView *view = mx_keyWindow();
    if (!_messageHub) {
        _messageHub = [[MBProgressHUD alloc] initWithView:view];
        _messageHub.removeFromSuperViewOnHide = YES;
    }
    [_messageHub setMode:mode];
    [_messageHub setLabelText:message];
    
    if (mode == MBProgressHUDModeIndeterminate) {
        [_messageHub setMinSize:CGSizeZero];
    }
    else {
        [_messageHub setMinSize:(CGSize){100.0, 100.0 * 0.5}];
        
        if (mode == MBProgressHUDModeCustomView) {
            [_messageHub setCustomView:[[UIImageView alloc] initWithImage:mx_imageInHudBundle(imageName)]];
        }
    }
    
    if (!_messageHub.superview) {
        [view addSubview:_messageHub];
    }
    [_messageHub show:YES];
    
    if (mode != MBProgressHUDModeIndeterminate) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MXProgressHUD hideLoadingProgress];
        });
    }
}

/**
 *  配置隐藏HUD属性
 *
 *  @param message   提示文字
 *  @param imageName 显示图片名称
 */
+ (void)hideWithStatus:(NSString *)message image:(NSString *)imageName
{
    if (!_messageHub) return;
    
    [_messageHub setLabelText:message];
    [_messageHub setMinSize:(CGSize){100.0, 100.0 * 0.5}];
    [_messageHub setMode:MBProgressHUDModeCustomView];
    [_messageHub setCustomView:[[UIImageView alloc] initWithImage:mx_imageInHudBundle(imageName)]];
    
    NSTimeInterval delay = displayDurationForString(message);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MXProgressHUD hideLoadingProgress];
    });
}

@end
