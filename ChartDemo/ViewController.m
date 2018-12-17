//
//  ViewController.m
//  ChartDemo
//
//  Created by YZY on 2018/12/17.
//  Copyright © 2018 https://github.com/3KK3. All rights reserved.
//

#import "ViewController.h"
#import "Statistical/StatisticalChartView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    StatisticalChartView *chartView = [[StatisticalChartView alloc] initWithFrame: CGRectMake(50, 100, 300, 300)];
    [self.view addSubview: chartView];
 
    chartView.showLine1 = YES;
    chartView.showLine2 = YES;
    chartView.showLinePointLabel = YES;
    chartView.hadNegativeNumber = NO;
    chartView.yPointNum = 8;
    
    chartView.yTitleArray = @[@[@"5.13",
                              @"5.1",
                              @"5.1",
                              @"5.09",
                              @"5.08",
                              @"5.06",
                              @"5.01",
                              @"5.02"]];
    
    chartView.yUnitArray = @[@"元/公斤"];
    chartView.xTitleArray = @[@"2018-10-19",
                              @"2018-10-26",
                              @"2018-11-02",
                              @"2018-11-09",
                              @"2018-11-16",
                              @"2018-11-23",
                              @"2018-11-30",
                              @"2018-12-07"];
    chartView.linePointArray = @[@[@"5.13",
                                     @"5.1",
                                     @"5.1",
                                     @"5.09",
                                     @"5.08",
                                     @"5.06",
                                     @"5.01",
                                     @"5.02"]];
    chartView.lineColorArray = @[[UIColor redColor]];
    [chartView drawView];

}


@end
