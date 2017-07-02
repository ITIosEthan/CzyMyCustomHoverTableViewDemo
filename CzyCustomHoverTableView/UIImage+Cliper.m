//
//  UIImage+Cliper.m
//  CzyCustomHoverTableView
//
//  Created by macOfEthan on 16/12/26.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#import "UIImage+Cliper.h"

@implementation UIImage (Cliper)


/**
 倒圆角

 @return UIImage *
 */
- (UIImage *)czyClipper
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //添加椭圆区域
    CGContextAddEllipseInRect(context, rect);
    
    //剪切
    CGContextClip(context);
    
    //图片画入区域
    [self drawInRect:rect];

    //渠道图片
    UIImage *czyFinalImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //别忘记关闭上下文
    UIGraphicsEndImageContext();
    
    return czyFinalImg;
}

@end
