//
//  MXProgressHUD.h
//  MXProgressHUD
//
//  Created by 韦纯航 on 16/4/29.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXProgressHUD : NSObject

/**
 *  显示一个成功结果的HUD（显示完成后会自动隐藏）
 *
 *  @param message 提示文字
 */
+ (void)showSuccessWithStatus:(NSString *)message;

/**
 *  显示一个错误结果的HUD（显示完成后会自动隐藏）
 *
 *  @param message 提示文字
 */
+ (void)showErrorWithStatus:(NSString *)message;

/**
 *  显示一个只带文字的HUD（显示后在指定时间之后自动隐藏）
 *
 *  @param message 提示文字
 *  @param delay   显示持续时间
 */
+ (void)showLoadingProgressWithMessage:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  显示一个等待状态的HUD（显示后不会自动隐藏）
 *  需调用hideLoadingProgress隐藏
 */
+ (void)showLoadingProgress;

/**
 *  显示一个带有提示文字的等待状态HUD（显示后不会自动隐藏）
 *  需调用hideLoadingProgress隐藏
 *
 *  @param message 提示文字
 */
+ (void)showLoadingProgressWithMessage:(NSString *)message;

/**
 *  显示一个提示文字后隐藏
 *
 *  @param message 提示文字
 */
+ (void)hideWithMessage:(NSString *)message;

/**
 *  显示一个成功状态后隐藏HUD
 *
 *  @param message 提示文字
 */
+ (void)hideWithSuccessStatus:(NSString *)message;

/**
 *  显示一个错误状态后隐藏HUD
 *
 *  @param message 提示文字
 */
+ (void)hideWithErrowStatus:(NSString *)message;

/**
 *  立即隐藏所有显示的HUD
 */
+ (void)hideLoadingProgress;

@end
