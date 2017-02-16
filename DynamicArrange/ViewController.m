//
//  ViewController.m
//  DynamicArrange
//
//  Created by ccpg_it on 17/2/15.
//  Copyright © 2017年 ccpg_it. All rights reserved.
//

#import "ViewController.h"
#import "ENDynamicListView.h"

@interface ViewController ()
@property (nonatomic , strong) NSArray *titleArray;
@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ENDynamicListView *listView = [[ENDynamicListView alloc] initWithDataArray:self.titleArray];

    listView.frame = self.view.bounds;
    
    [self.view addSubview:listView];
    
}

#pragma mark - custom delegate


#pragma mark - getter

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"module-1",@"module-2",@"module-3",@"module-4",@"module-5",@"module-6",@"module-7",@"module-8",@"module-9",@"module-10",@"module-11",@"module-12",@"module-13",@"module-14",@"module-15",@"module-16",@"module-17",@"module-18",@"module-19",@"module-20",@"module-21",@"module-22",@"module-23",@"module-24",@"module-25",@"module-26"];
    }
    return _titleArray;
}

@end
