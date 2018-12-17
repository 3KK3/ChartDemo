//
//  StatisticalChartYView.h
//  StatisticalChartDemo
//
//  Created by lanling on 2017/12/25.
//  Copyright © 2017年 lanling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalChartYView : UIView
///Y轴显示内容
@property (nonatomic, strong) NSArray *yTitleArray;
@property (nonatomic, strong) NSArray *barPointArray;
///Y轴分割数
@property (nonatomic) NSInteger yPointNum;
///是否有负数
@property (nonatomic) BOOL hadNegativeNumber;
///单位
@property (nonatomic, strong) NSArray *unitArray;
///曲线坐标位置，YES右侧，NO左侧
@property (nonatomic) BOOL lineRightY;

- (void)setYView;

@end
