//
//  StatisticalChartXView.m
//  StatisticalChartDemo
//
//  Created by lanling on 2017/12/25.
//  Copyright © 2017年 lanling. All rights reserved.
//
//  2、5、10、20、
#import "StatisticalChartXView.h"

#define yInterval (self.bounds.size.height - 80) / (CGFloat)(self.yPointNum - 1)

#define minInterval 40

@interface StatisticalChartXView ()
{
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat avgValue;
    CGFloat maxY;
    CGFloat minY;
    CGFloat xInterval;
    
    CGFloat maxValue2;
    CGFloat minValue2;
    CGFloat avgValue2;
    
    NSMutableArray *pointMutableArray;
    NSMutableArray *pointMutableArray2;
    NSMutableArray *barPointMutableArray;
    NSMutableArray *barPointMutableArray2;
    NSInteger jumpNum;
}


@end

@implementation StatisticalChartXView

- (void)drawRect:(CGRect)rect {
    [self drawXView];
}

///绘制x轴与横向分割线
- (void)drawXView {
    for (int i = 0; i < self.yPointNum; i++) {
        //获得上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //画直线，设置路径颜色
        if (i == 0) {
            CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:79 / 255.0 green:145 / 255.0 blue:205 / 255.0 alpha:1.0].CGColor);
        } else {
            CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:226 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1.0].CGColor);
        }
        
        //设置线宽度
        CGContextSetLineWidth(ctx, 1);
        //起始点
        CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 50 - i * yInterval);
        //从起始点连线到另一个点
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 50 - i * yInterval);
        //画线
        CGContextStrokePath(ctx);
    }
}

///设置x轴显示内容
- (void)setXView {
    jumpNum = 0;
    if (self.xTitleArray.count > 0) {
        if ((self.bounds.size.width - 60) / self.xTitleArray.count < minInterval) {
            jumpNum = minInterval / ((self.bounds.size.width - 60) / self.xTitleArray.count);
        }
        [self compute];
        for (int i = 0; i < self.xTitleArray.count; i++) {
            if (jumpNum > 0 && i % jumpNum != 0  ) {
                if (i == self.xTitleArray.count - 1) {
                    if (i % jumpNum != jumpNum - 1) {
                        continue;
                    }
                } else {
                    continue;
                }
            }
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(i * xInterval - 25, self.bounds.size.height - 45, 70, 35);
            label.text = self.xTitleArray[i];
            label.font = [UIFont systemFontOfSize:11.0f];
            label.numberOfLines = 2;
            label.textAlignment = NSTextAlignmentCenter;
            label.transform = CGAffineTransformMakeRotation(-M_PI * 0.15);
            [self addSubview:label];
            [self drawXViewWithX:i * xInterval + 30];
        }
    }
    
    if (self.barPointArray.count > 0) {
        [self drawBarView];
    }
    
    if (self.linePointArray.count > 0) {
        [self setPoint];
    }
}

#pragma mark - 绘制取线图

//设置点位置
- (void)setPoint {
    if ([self.linePointArray[0] count] > 0 && self.showLine1) {
        pointMutableArray = [NSMutableArray array];
        for (int i = 0; i < [self.linePointArray[0] count]; i++) {
            CGPoint point = CGPointMake(i * xInterval + 30, [self getYWithNum:[self.linePointArray[0][i] floatValue]]);
            NSValue *value = [NSValue valueWithCGPoint:point];
            [pointMutableArray addObject:value];
        }
        UIColor *color;
        if (self.lineColorArray.count > 0) {
            color = self.lineColorArray[0];
        } else {
            color = [UIColor blueColor];
        }
        [self drawLineWithPointArray:pointMutableArray LineColor:color TextArray:self.linePointArray[0]];
    }
    if (self.linePointArray.count > 1) {
        if ([self.linePointArray[1] count] > 0 && self.showLine2) {
            pointMutableArray2 = [NSMutableArray array];
            for (int i = 0; i < [self.linePointArray[1] count]; i++) {
                CGPoint point = CGPointMake(i * xInterval + 30, [self getYWithNum:[self.linePointArray[1][i] floatValue]]);
                NSValue *value = [NSValue valueWithCGPoint:point];
                [pointMutableArray2 addObject:value];
            }
            UIColor *color;
            if (self.lineColorArray.count > 1) {
                color = self.lineColorArray[1];
            } else {
                color = [UIColor greenColor];
            }
            [self drawLineWithPointArray:pointMutableArray2 LineColor:color TextArray:self.linePointArray[1]];
        }
    }
}

///画垂直分割线
- (void)drawXViewWithX:(CGFloat)x {
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:CGPointMake(x, self.bounds.size.height - 50)];
    // 其他点
    [linePath addLineToPoint:CGPointMake(x, 30)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor colorWithRed:226 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1.0].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    lineLayer.lineDashPattern = @[@3, @2];//画虚线
    [self.layer addSublayer:lineLayer];
}

///画曲线图
- (void)drawLineWithPointArray:(NSMutableArray *)pointArray LineColor:(UIColor *)color TextArray:(NSArray *)textArray {
    if (pointArray.count > 0) {
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = 1;
        lineLayer.strokeColor = color.CGColor;
        lineLayer.path = [self bezierWithCircleArray:pointArray].CGPath;
        lineLayer.fillColor = nil; // 默认为blackColor
        lineLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:lineLayer];
        [self drawRingWithPointArray:pointArray LineColor:color TextArray:textArray];
    }
}

//曲线处理
- (UIBezierPath *)bezierWithCircleArray:(NSMutableArray *)pointArray {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    NSValue *value = pointArray[0];
    CGPoint startCircle = [value CGPointValue];
    [bezier moveToPoint:CGPointMake(startCircle.x, startCircle.y)];
    CGPoint PrePonit;
    for (NSInteger i = 0; i < pointArray.count; i++) {
        NSValue *value2 = pointArray[i];
        CGPoint circle = [value2 CGPointValue];
        if (i == 0) {
            PrePonit = CGPointMake(circle.x, circle.y);
        }else{
            CGPoint NowPoint = CGPointMake(circle.x, circle.y);
            [bezier addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
            PrePonit = NowPoint;
        }
    }
    return bezier;
}

//画圆点
- (void)drawRingWithPointArray:(NSMutableArray *)pointArray LineColor:(UIColor *)color TextArray:(NSArray *)textArray{
    for (int i = 0; i < pointArray.count; i++) {
        
        if (jumpNum > 0 && i % jumpNum != 0) {
            if (i == pointArray.count - 1) {
                if (i % jumpNum != jumpNum - 1) {
                    continue;
                }
            } else {
                continue;
            }
        }
        
        UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 4, 4)];
        NSValue *value1 = pointArray[i];
        CGPoint point1 = [value1 CGPointValue];
        // 其他点
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.frame = CGRectMake(0, 0, 4, 4);//设置Frame
        bgLayer.position = point1;//居中显示
        bgLayer.fillColor = [UIColor whiteColor].CGColor;//填充颜色=透明色
        bgLayer.lineWidth = 1.f;//线条大小
        bgLayer.strokeColor = color.CGColor;//线条颜色
        bgLayer.strokeStart = 0.f;//路径开始位置
        bgLayer.strokeEnd = 1.f;//路径结束位置
        bgLayer.path = circle.CGPath;//设置bgLayer的绘制路径为circle的路径
        [self.layer addSublayer:bgLayer];//添加到屏幕上
        
        if (self.showLinePointText) {
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(point1.x - 20, point1.y - 18, 40, 15);
            // 渲染分辨率-重要，否则显示模糊
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            textLayer.string = textArray[i];
            //文字颜色
            textLayer.foregroundColor = color.CGColor;
            textLayer.fontSize = 11;
            textLayer.alignmentMode = @"center";
            [self.layer addSublayer:textLayer];
            
        }
    }
}

//获取点对应曲线y
- (CGFloat)getYWithNum:(CGFloat)num {
   return self.bounds.size.height - ((num - minValue) / (maxValue - minValue)) * (maxY - minY) - 50;
}

#pragma mark - 绘制柱状图

- (void)drawBarView {
    BOOL isTwo = self.barPointArray.count > 1;
    if ([self.barPointArray[0] count] > 0 && self.showBar1) {
        barPointMutableArray = [NSMutableArray array];
        for (int i = 0; i < [self.barPointArray[0] count]; i++) {
            if (jumpNum > 0 && i % jumpNum != 0) {
                continue;
            }
            CGPoint point;
            if (isTwo) {
                point = CGPointMake(i * xInterval + 25, [self getYWithNum2:[self.barPointArray[0][i] floatValue]]);
            } else {
                point = CGPointMake(i * xInterval + 30, [self getYWithNum2:[self.barPointArray[0][i] floatValue]]);
            }
            
            NSValue *value = [NSValue valueWithCGPoint:point];
            [barPointMutableArray addObject:value];
            UIColor *color;
            if (self.barColorArray.count > 0) {
                color = self.barColorArray[0];
            } else {
                color = [UIColor blueColor];
            }
            [self drawBarViewWithPoint:point Color:color];
        }
    }
    if (self.barPointArray.count > 1 && self.showBar2) {
        if ([self.barPointArray[1] count] > 0) {
            barPointMutableArray2 = [NSMutableArray array];
            for (int i = 0; i < [self.barPointArray[1] count]; i++) {
                if (jumpNum > 0 && i % jumpNum != 0) {
                    continue;
                }
                CGPoint point = CGPointMake(i * xInterval + 35, [self getYWithNum2:[self.barPointArray[1][i] floatValue]]);
                NSValue *value = [NSValue valueWithCGPoint:point];
                [barPointMutableArray2 addObject:value];
                UIColor *color;
                if (self.barColorArray.count > 1) {
                    color = self.barColorArray[1];
                } else {
                    color = [UIColor greenColor];
                }
                [self drawBarViewWithPoint:point Color:color];
            }
        }
    }
}

//获取点对应柱状y
- (CGFloat)getYWithNum2:(CGFloat)num {
    return self.bounds.size.height - ((num - minValue2) / (maxValue2 - minValue2)) * (maxY - minY) - 50;
}

//画柱状图
- (void)drawBarViewWithPoint:(CGPoint)point Color:(UIColor *)color {
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:CGPointMake(point.x, self.bounds.size.height - 50)];
    // 其他点
    [linePath addLineToPoint:CGPointMake(point.x, point.y)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 10;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [self.layer addSublayer:lineLayer];
}

#pragma mark - 取最大值、最小值
- (void)compute {
    
    maxValue = [[self.yTitleArray[0] valueForKeyPath:@"@max.floatValue"] floatValue];
    minValue = [[self.yTitleArray[0] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat differenceValue = maxValue - minValue;
    
    avgValue = (maxValue - minValue) / (CGFloat)(self.yPointNum - 1);
    
    ///修正等差值,规范显示
    if (avgValue < 0.04) {
        avgValue = 0.05;
    } else if (avgValue >= 0.04 && avgValue < 0.08) {
        avgValue = 0.1;
    } else if (avgValue >= 0.08 && avgValue < 0.4) {
        avgValue = 0.5;
    } else if (avgValue >= 0.4 && avgValue < 0.8) {
        avgValue = 1;
    } else {
        avgValue = ((differenceValue / (self.yPointNum - 3)) * (self.yPointNum + 1)) / (self.yPointNum - 1);
        avgValue = (NSInteger)avgValue + 1;
    }
    
    
    if (avgValue < 0.1) {
        avgValue = (NSInteger)(avgValue * 100) / 100.0;
    } else if (avgValue >= 0.1 && avgValue < 1) {
        avgValue = (NSInteger)(avgValue * 10) / 10.0;
    } else {
        avgValue = (NSInteger)avgValue;
    }
    
    minValue = minValue - ((self.yPointNum - 1) * avgValue - differenceValue) / 2.0;
    
    if (avgValue < 0.1) {
        minValue = (NSInteger)(minValue * 100) / 100.0;
    } else if (avgValue >= 0.1 && avgValue < 1) {
        minValue = (NSInteger)(minValue * 10) / 10.0;
    } else {
        minValue = (NSInteger)minValue;
    }
    
    if (!self.hadNegativeNumber && minValue < 0) {
        minValue = 0;
    }
    
    maxValue = minValue + (self.yPointNum - 1) * avgValue;
    
    maxY = self.bounds.size.height - 50;
    minY = 30;
    
    xInterval = (self.bounds.size.width - 60) / (self.xTitleArray.count - 1);
    
    //有柱状图
    if (self.barPointArray.count > 0) {
        maxValue2 = [[self.yTitleArray[1] valueForKeyPath:@"@max.floatValue"] floatValue];
        if (maxValue2 >= 1000) {
            maxValue2 = maxValue2 * 1.02;
        } else if (maxValue2 >= 100 && maxValue2 < 1000) {
            maxValue2 = maxValue2 + 10;
        } else if (maxValue2 >= 10 && maxValue2 < 100) {
            maxValue2 = maxValue2 + 5;
        } else {
            maxValue2 = maxValue2 + 1;
        }
        
        
        minValue2 = [[self.yTitleArray[1] valueForKeyPath:@"@min.floatValue"] floatValue];
        if (minValue2 >= 1000) {
            minValue2 = minValue2 * 0.98;
        } else if (minValue2 >= 100 && minValue2 < 1000) {
            minValue2 = minValue2 - 10;
        } else if (minValue2 >= 10 && minValue2 < 100) {
            minValue2 = minValue2 - 5;
        } else if (minValue2 >= 0 && minValue2 < 10){
            minValue2 =  minValue2 > 1 ? minValue2 - 1 : 0;
        } else {
            minValue2 = minValue2 - 0.5;
        }
        
        if (self.barPointArray.count > 1) {
            if (maxValue2 - minValue2 > 10000) {
                minValue2 = minValue2 * 0.4;
            } else if (maxValue2 - minValue2 > 1000 && maxValue2 - minValue2 < 10000) {
                minValue2 = minValue2 * 0.5;
            }
        }

    }
}

@end
