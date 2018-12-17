//
//  StatisticalChartXView.h
//  StatisticalChartDemo
//
//  Created by lanling on 2017/12/25.
//  Copyright © 2017年 lanling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalChartXView : UIView
///折线图数据
@property (nonatomic, strong) NSArray *linePointArray;
///柱状图数据
@property (nonatomic, strong) NSArray *barPointArray;
///x轴内容
@property (nonatomic, strong) NSArray *xTitleArray;
///Y轴分割数
@property (nonatomic) NSInteger yPointNum;
///Y轴显示内容
@property (nonatomic, strong) NSArray *yTitleArray;
///是否显示点的数值
@property (nonatomic) BOOL showLinePointText;
///是否有负数
@property (nonatomic) BOOL hadNegativeNumber;

@property (nonatomic) BOOL showLine1;
@property (nonatomic) BOOL showLine2;
@property (nonatomic) BOOL showBar1;
@property (nonatomic) BOOL showBar2;

@property (nonatomic, strong) NSArray *lineColorArray;
@property (nonatomic, strong) NSArray *barColorArray;

- (void)setXView;
@end
