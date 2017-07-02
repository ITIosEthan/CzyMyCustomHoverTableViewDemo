//
//  CzyHeaderView.h
//  CzyCustomHoverTableView
//
//  Created by macOfEthan on 16/12/26.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CzyHeaderView : UIView

//检测偏移量
@property (nonatomic, assign) float czyTableViewOffset;

//弹框弹出的控制器
@property (nonatomic, strong) UIViewController *czyController;

@end
