//
//  CzyHeaderView.m
//  CzyCustomHoverTableView
//
//  Created by macOfEthan on 16/12/26.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#import "CzyHeaderView.h"

@implementation CzyHeaderView
{
    UIImageView *_czyAvatarImageView;
    UIBezierPath *_path;
    CAShapeLayer *_layer;
    UITapGestureRecognizer *_tap;
}

#pragma mark - 初始化函数
//小细节:外部调用init创建对象 会先走initWithFrame: 再走init: ; 外部调用initWithFrame:只会走initWithFrame 不走init
- (instancetype)init
{
    if (self = [super init]) {
        [self czyInitUI];
    }
    return self;
}

#pragma mark - Setter
- (void)setCzyTableViewOffset:(float)czyTableViewOffset
{
    _czyTableViewOffset = czyTableViewOffset;
}

#pragma mark - UI
- (void)czyInitUI
{
    self.backgroundColor = kCzyRedColor;
    
    _czyAvatarImageView = [[UIImageView alloc] initWithImage:[kCzyRedBirdImage czyClipper]];
    [self addSubview:_czyAvatarImageView];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    _czyAvatarImageView.userInteractionEnabled = YES;
    [_czyAvatarImageView addGestureRecognizer:_tap];
}

#pragma mark - 图片点击手势
- (void)tap:(UITapGestureRecognizer *)tap
{
    //弹框
    [UIView czyShowAlertCtlWithCtlTitle:@"点击了图片"
                             ctlMessage:nil
                        sureActionTitle:@"确定"
                             sureHandle:^(UIAlertAction *sureAction) {
        NSLog(@"点击了确定");
    }
                      cancelActionTitle:@"取消"
                           cancelHandle:^(UIAlertAction *cancelAction) {
        NSLog(@"点击了取消");
    }
                       inViewController:_czyController];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    _czyAvatarImageView.frame = CGRectMake(0, 0, kCzyImageWidth, kCzyImageHeight);
    
    _czyAvatarImageView.center = self.center;
    
//    NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));

//    NSLog(@"_czyAvatarImageView.frame = %@",NSStringFromCGRect(_czyAvatarImageView.frame));
    
    //改变frame会触发layOutSubViews 可以在这里设置相关动画
    if (self.frame.size.height > kCzyPlaceHolderViewHeight) {
        
        _czyAvatarImageView.transform = CGAffineTransformScale(_czyAvatarImageView.transform,
                                                               self.frame.size.height/kCzyPlaceHolderViewHeight,
                                                               self.frame.size.height/kCzyPlaceHolderViewHeight);
        
    }
    
    //滑动时 开始绘图
    [self setNeedsDisplay];
}

//调用setNeedsDisplay 开始绘制
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //填充颜色
    CGContextSetRGBFillColor(context, 0.5, 0.65, 0.7, 1.0);
    
    //绘制路径
    CGContextMoveToPoint(context, kCzyFullWidth, 0 );
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddQuadCurveToPoint(context,
                                 kCzyFullWidth/2, 2 * _czyAvatarImageView.frame.origin.y + _czyAvatarImageView.frame.size.height,
                                 kCzyFullWidth, 0);
    
    //关闭路径
    CGContextClosePath(context);
    
    //开始绘制
    CGContextDrawPath(context, kCGPathFill);
}

#pragma mark - 事件穿透效果  使得用户点击顶部视图 也可以滑动tableView
//图像添加点击事件/拖动图片不能下拉滚动 两者效果选一
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *selectView = [super hitTest:point withEvent:event];
    
    if (selectView == self) {
        return nil;
    }
    
    return selectView;
}

#if 0
//在这个方法里判断点击了某个图片
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //判断是否点击了图片
    CGPoint czyImageCenter = _czyAvatarImageView.center;
    
    //点击的任一点到圆心的距离
    float distance = sqrtf(pow(point.x - czyImageCenter.x, 2) + pow(point.y - czyImageCenter.y, 2));

    if (distance < kCzyImageWidth/2) {
        
        return YES;
        
    }else{
    
        NSString *czyXCoordinateOfPoint = [NSString stringWithFormat:@"当前横坐标:%f",point.x];
        NSString *czyYCoordinateOfPoint = [NSString stringWithFormat:@"当前纵坐标:%f",point.y];
        
        [UIView czyShowAlertCtlWithCtlTitle:@"温馨提示"
                                 ctlMessage:nil
                            sureActionTitle:czyXCoordinateOfPoint
                                 sureHandle:^(UIAlertAction *sureAction) {
                                     
            NSLog(@"x = %f",point.x);
                                     
        }
                          cancelActionTitle:czyYCoordinateOfPoint
                               cancelHandle:^(UIAlertAction *cancelAction) {
                                   
            NSLog(@"y = %f",point.y);
                                   
        }
                           inViewController:_czyController];
        
        return true;

    }
}
#endif

@end
