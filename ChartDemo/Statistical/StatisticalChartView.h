//
//  StatisticalChartView.h
//  StatisticalChartDemo
//
//  Created by lanling on 2017/12/25.
//  Copyright © 2017年 lanling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalChartView : UIView
/*
 * 数据格式@[@[],@[]]
 * 只可存入数字
 * 最多支持双曲线和双柱状图
 */
///折线图数据
@property (nonatomic, strong) NSArray *linePointArray;
///柱状图数据
@property (nonatomic, strong) NSArray *barPointArray;

/*
 * Y轴显示内容，将曲线或柱状图所有点放进去，会自动适应y轴显示范围内容
 * 格式：@[@[],@[]],
 * 传入两个数组，将绘制左右两个y坐标
 * 只可存入数字
 */
@property (nonatomic, strong) NSArray *yTitleArray;
///Y轴分割数
@property (nonatomic) NSInteger yPointNum;
///Y轴单位
@property (nonatomic, strong) NSArray *yUnitArray;
///X轴显示内容【务必保持和上方pointArray/barPointArray数据数量和位置一致】
@property (nonatomic, strong) NSArray *xTitleArray;
///曲线颜色
@property (nonatomic, strong) NSArray *lineColorArray;
///柱状图颜色
@property (nonatomic, strong) NSArray *barColorArray;
///是否有负数
@property (nonatomic) BOOL hadNegativeNumber;
///曲线坐标位置，YES右侧，NO左侧 默认左侧, 双坐标生效
@property (nonatomic) BOOL lineRightY;

///曲线与柱状图显示控制
@property (nonatomic) BOOL showLine1;
@property (nonatomic) BOOL showLine2;
@property (nonatomic) BOOL showBar1;
@property (nonatomic) BOOL showBar2;

///是否显示折线点的数值
@property (nonatomic) BOOL showLinePointLabel;

///设置完上面属性后调用开始绘制
- (void)drawView;

///无数据变化更新UI
- (void)updateUI;

@end
