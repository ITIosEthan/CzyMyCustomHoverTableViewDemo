//
//  NSObject+CzyShowAlerter.h
//  CzyCustomHoverTableView
//
//  Created by macOfEthan on 16/12/26.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

//为NSOBject添加类别
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CzySureHandle)(UIAlertAction *);
typedef void(^CzyCancelHandle)(UIAlertAction *);

@interface NSObject (CzyShowAlerter)

//确定的回调
@property (nonatomic, strong) CzySureHandle czySureHandle;

//取消的回调
@property (nonatomic, strong) CzyCancelHandle czyCancleHandle;


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
                   inViewController:(UIViewController *)czyViewController;

@end
