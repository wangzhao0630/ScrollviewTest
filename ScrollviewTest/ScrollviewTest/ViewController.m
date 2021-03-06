//
//  ViewController.m
//  ScrollviewTest
//
//  Created by juru on 2018/1/18.
//  Copyright © 2018年 wangzhao. All rights reserved.
//
#import "ZJScrollPageView.h"
//#import ""
#import "MyInvestRecordChildController.h"
#import "ViewController.h"
static NSString * const cellID = @"cellID";
static CGFloat const segmentViewHeight = 44.0;
static CGFloat const naviBarHeight = 64.0;
static CGFloat const headViewHeight = 200.0;

@interface ZJCustomGestureTableView : UITableView

@end

@implementation ZJCustomGestureTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end


@interface ViewController ()<ZJScrollPageViewDelegate,ZJScrollPageViewChildVcDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) ZJContentView *contentView;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) ZJCustomGestureTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"微博个人页面";
   
    [self.view addSubview:self.tableView];
    /**底层tableview不能下滚*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gundong) name:@"gundong" object:nil];
    
    /**pageview横滑 tableview可以竖向向滚动*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meCan) name:@"you" object:nil];
    
    /**pageview停止横滑 tableview都不能竖向滚*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youCan) name:@"me" object:nil];
}
- (void)gundong{
    self.tableView.contentOffset = CGPointZero;
}
/**不横向滑动了我打开*/
- (void)meCan{
    self.tableView.scrollEnabled = YES;
}
- (void)youCan{
    self.tableView.scrollEnabled = NO;
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
       
        childVc = [[MyInvestRecordChildController alloc] init];
        
        }
        
    
    return childVc;
}


//#pragma mark- ZJPageViewControllerDelegate
//
//- (void)scrollViewIsScrolling:(UIScrollView *)scrollView {
//    _childScrollView = scrollView;
//    if (self.tableView.contentOffset.y < headViewHeight) {
//        scrollView.contentOffset = CGPointZero;
//        scrollView.showsVerticalScrollIndicator = NO;
//    }
//    else {
//        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
//        scrollView.showsVerticalScrollIndicator = YES;
//    }
//
//}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.childScrollView && _childScrollView.contentOffset.y > 0) {
//        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
//    }
    
 
    if ([scrollView isKindOfClass:[UITableView class]]){
        //UITableView
        if (self.tableView.contentOffset.y < headViewHeight) {
            if (self.tableView.contentOffset.y>0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gun" object:nil];
            }
        }
        
        
        if (self.tableView.contentOffset.y<0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gunxia" object:nil];
        }
        
        CGFloat offsetY = scrollView.contentOffset.y;
        if(offsetY < 0) {
            
            self.tableView.contentOffset = CGPointZero;
        }
 


    
   
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:ZJParentTableViewDidLeaveFromTopNotification object:nil];
        
    }else{
        
        self.tableView.contentOffset = CGPointZero;
        
    }
}

#pragma mark- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.contentView];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

#pragma mark- setter getter
- (ZJScrollSegmentView *)segmentView {
    if (_segmentView == nil) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        style.showCover = YES;
        // 渐变
        style.gradualChangeTitleColor = YES;
        // 遮盖背景颜色
        style.coverBackgroundColor = [UIColor whiteColor];
        //标题一般状态颜色 --- 注意一定要使用RGB空间的颜色值
        style.normalTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        //标题选中状态颜色 --- 注意一定要使用RGB空间的颜色值
        style.selectedTitleColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        
        self.titles = @[@"新闻头条",
                        @"国际要闻",
                        @"体育",
                        @"中国足球",
                        @"汽车",
                        @"囧途旅游",
                        @"幽默搞笑",
                        @"视频",
                        @"无厘头",
                        @"美女图片",
                        @"今日房价",
                        @"头像",
                        ];
        
        // 注意: 一定要避免循环引用!!
        __weak typeof(self) weakSelf = self;
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, naviBarHeight + headViewHeight, self.view.bounds.size.width, segmentViewHeight) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
            
        }];
        segment.backgroundColor = [UIColor lightGrayColor];
        _segmentView = segment;
        
    }
    return _segmentView;
}

- (ZJContentView *)contentView {
    if (_contentView == nil) {
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:self.view.bounds segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headViewHeight)];
        UILabel *label = [[UILabel alloc] initWithFrame:_headView.bounds];
        label.text = @"这是header~~~~~~~~~~~~~~";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        [_headView addSubview:label];
        _headView.backgroundColor = [UIColor greenColor];
    }
    
    return _headView;
}

- (ZJCustomGestureTableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, naviBarHeight, self.view.bounds.size.width, self.view.bounds.size.height);
        ZJCustomGestureTableView *tableView = [[ZJCustomGestureTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        // 设置tableView的headView
        tableView.tableHeaderView = self.headView;
        tableView.tableFooterView = [UIView new];
        // 设置cell行高为contentView的高度
        tableView.rowHeight = self.contentView.bounds.size.height;
        tableView.delegate = self;
        tableView.dataSource = self;
        // 设置tableView的sectionHeadHeight为segmentViewHeight
        tableView.sectionHeaderHeight = segmentViewHeight;
        tableView.showsVerticalScrollIndicator = false;
        _tableView = tableView;
    }
    
    return _tableView;
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gundong" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"you" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"me" object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
