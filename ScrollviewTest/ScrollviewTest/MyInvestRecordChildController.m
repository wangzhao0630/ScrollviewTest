//
//  MyInvestRecordChildController.m
//  ScrollviewTest
//
//  Created by juru on 2018/1/18.
//  Copyright © 2018年 wangzhao. All rights reserved.
//

#import "MyInvestRecordChildController.h"
@interface MyInvestRecordChildController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *dataTable;

@end;

@implementation MyInvestRecordChildController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.dataTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gun) name:@"gun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gunxia) name:@"gunxia" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meCan) name:@"you" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youCan) name:@"me" object:nil];
    
    
}
- (void)meCan{
    self.dataTable.scrollEnabled = YES;
}
- (void)youCan{
    self.dataTable.scrollEnabled = NO;
}

- (void)gunxia{
    self.dataTable.scrollEnabled = YES;
}

- (void)gun{
    self.dataTable.scrollEnabled = NO;
}
- (UITableView *)dataTable{
    if (_dataTable == nil) {
        _dataTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _dataTable.delegate = self;
        _dataTable.dataSource = self;
        [_dataTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _dataTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个cell",(long)indexPath.row];
    return cell;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]){
        self.dataTable.scrollEnabled = YES;
        if (scrollView.contentOffset.y < 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gundong" object:nil];
        }
    }else{
        self.dataTable.scrollEnabled = NO;
    }
    
  
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gunxia" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"you" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"me" object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}





@end
