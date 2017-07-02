//
//  NSObject+CzyShowAlerter.m
//  CzyCustomHoverTableView
//
//  Created by macOfEthan on 16/12/26.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#import "NSObject+CzyShowAlerter.h"

@implementation NSObject (CzyShowAlerter)

//不让编译器 生成setter和getter方法 如需自己写setter和getter 需要自己在类中显式提供实例变量，因为@dynamic不能像@synthesize那样向实现文件(.m)提供实例变量。
@dynamic czySureHandle;
@dynamic czyCancleHandle;

/**
 弹框
 
 @param czyCtlTitle 控制器弹框的标题
 @param czyCtlMessage 控制器弹框消息
 @param czySureActionTitle 确定的标题
 @param czySureBlock 确定的回调
 @param czyCancelActionTitle 取消的标题
 @param czyCancelBlock 取消的回调
 @param czyViewController 在哪个控制器里面弹出该弹框
 */
+ (void)czyShowAlertCtlWithCtlTitle:(NSString *)czyCtlTitle
                         ctlMessage:(NSString *)czyCtlMessage
                    sureActionTitle:(NSString *)czySureActionTitle
                         sureHandle:(CzySureHandle)czySureBlock
                  cancelActionTitle:(NSString *)czyCancelActionTitle
                       cancelHandle:(CzyCancelHandle)czyCancelBlock
                   inViewController:(UIViewController *)czyViewController
{
    
    UIAlertController *czyAlertCtl = [UIAlertController alertControllerWithTitle:czyCtlTitle
                                                                         message:czyCtlMessage
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *czySureAction = [UIAlertAction actionWithTitle:czySureActionTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:czySureBlock];
    
    UIAlertAction *czyCancelAction = [UIAlertAction actionWithTitle:czyCancelActionTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:czyCancelBlock];
    
    
    [czyAlertCtl addAction:czySureAction];
    
    [czyAlertCtl addAction:czyCancelAction];
    
    
    //回到主线程 弹出框  安全操作 因为外边的操作不一定在主线程中操作 比如异步下载数据
    dispatch_async(dispatch_get_main_queue(), ^{
        [czyViewController presentViewController:czyAlertCtl animated:YES completion:nil];
    });
    
}

@end
