//
//  CzyHoverTbVc.m
//  CzyCustomHoverTableView
//
//  Created by macOfEthan on 16/12/26.
//  Copyright © 2016年 macOfEthan. All rights reserved.
//

#define kCzyCellCount 20

#import "CzyHoverTbVc.h"

@interface CzyHoverTbVc ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_czyTableView;
    CzyHeaderView *_czyHeaderView;
    UIView *_placeHolderView;       //占位视图 用于设置tableView的偏移量 然后将自定义视图添加到self.view上面
    NSMutableArray *_czyDataSource;
}

@end

@implementation CzyHoverTbVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self czyCustomInitNav];
    
    [self czyInitData];
    
    [self czyInitUI];
}

#pragma mark - Nav
- (void)czyCustomInitNav
{
    self.navigationItem.title = @"CzyHoverTableView";
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - data
- (void)czyInitData
{
    _czyDataSource = [NSMutableArray array];
    for (NSInteger i=0; i<kCzyCellCount; i++) {
        NSString *cellStr = [NSString stringWithFormat:@"这是第%ld行",i+1];
        [_czyDataSource addObject:cellStr];
    }
}

#pragma mark - UI
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

#pragma mark - UIScrollViewDelegate
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

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _czyDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    cell.textLabel.text = _czyDataSource[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *reusedId = @"header";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusedId];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:reusedId];
    }
    
    headerView.textLabel.textColor = kCzyRedColor;
    headerView.textLabel.text = @"这是段头";
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end





