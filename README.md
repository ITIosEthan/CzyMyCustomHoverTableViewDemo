#基于CGContextRef绘制的类似微信红包页面效果+UIImage添加UIGraphic倒圆角类别+NSObject添加弹框类别

布局思路:headerView和tableView一样都是添加在控制器的view上 占位视图用来控制器表格视图的偏移量  然后通过滑动来改变headerView的frame达到同步滑动的效果
    
    - (void)czyInitUI
      {
          _czyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCzyFullWidth, kCzyFullHeight - 64) style:UITableViewStylePlain];
          _czyTableView.delegate = self;
          _czyTableView.dataSource = self;
          _czyTableView.tableFooterView = [UIView new];
          _czyTableView.showsVerticalScrollIndicator = NO;
          _czyTableView.sectionHeaderHeight = 30;
          [self.view addSubview:_czyTableView];

          //占位视图
          _placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, kCzyPlaceHolderViewHeight)];
          [self.view addSubview:_placeHolderView];

          _czyTableView.tableHeaderView = _placeHolderView;

          _czyHeaderView = [[CzyHeaderView alloc] init];
          _czyHeaderView.frame = CGRectMake(0, 0, kCzyFullWidth, kCzyPlaceHolderViewHeight);
          [self.view addSubview:_czyHeaderView];

          _czyHeaderView.czyController = self;
      }
      
    - (void)scrollViewDidScroll:(UIScrollView *)scrollView
    {
        float czyTableViewOffset = _czyTableView.contentOffset.y;

        CGRect czyHeaderViewFrame = _czyHeaderView.frame;

    #if 0
        //效果：上推顶部视图高度逐渐减小 下拉顶部视图顶部移动
        if (czyTableViewOffset > 0) {
            czyHeaderViewFrame.size.height = kCzyPlaceHolderViewHeight - czyTableViewOffset;
            czyHeaderViewFrame.origin.y = 0;
        }else{
            czyHeaderViewFrame.size.height = kCzyPlaceHolderViewHeight;
            czyHeaderViewFrame.origin.y = - czyTableViewOffset;
        }
    #endif

        //效果：上推顶部视图高度逐渐减小 下拉顶部视图顶部不移动
        czyHeaderViewFrame.size.height = kCzyPlaceHolderViewHeight - czyTableViewOffset;
        czyHeaderViewFrame.origin.y    = 0;

        _czyHeaderView.frame = czyHeaderViewFrame;

        //偏移量传给顶部视图
        _czyHeaderView.czyTableViewOffset = czyTableViewOffset;
    }

CzyHeaderView.m

在layoutSubviews里设置控件的frame 并调用setNeedsDisplay开始绘制
    
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

小细节:外部调用init创建对象 会先走initWithFrame: 再走init: ; 外部调用initWithFrame:只会走initWithFrame 不走init

小细节:在- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event里面实现事件穿透 使得headerView支持滑动


    - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
    {
        UIView *selectView = [super hitTest:point withEvent:event];
       
        if (selectView == self) {
            return nil;
        }

        return selectView;
    }
    
    
基于UIImage封装的倒圆角

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
    
   
   基于NSObject封装的弹框 细节：弹框的操作一定要在主线程 应该加上安全判断
 
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
    
    
# 效果图
![image](https://github.com/ITIosEthan/CzyMyCustomHoverTableView/blob/master/czyHoverGif.gif)
    
    
    
    
