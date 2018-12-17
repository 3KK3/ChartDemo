//
//  StatisticalChartYView.m
//  StatisticalChartDemo
//
//  Created by lanling on 2017/12/25.
//  Copyright © 2017年 lanling. All rights reserved.
//

#import "StatisticalChartYView.h"

#define interval (self.bounds.size.height - 30) / (CGFloat)(self.yPointNum - 1)

@interface StatisticalChartYView ()
{
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat avgValue;
    CGFloat maxValue2;
    CGFloat minValue2;
    CGFloat avgValue2;
    NSInteger DecimalDigits;
}

@end

@implementation StatisticalChartYView

- (void)setYView {
    if (self.yPointNum > 0) {
        [self compute];
        
        [self drawYViewWithX:self.bounds.size.width - 1];

        UILabel *unitLabel = [[UILabel alloc]init];
        unitLabel.frame = CGRectMake(0, 0, 50, 20);
        unitLabel.textAlignment = NSTextAlignmentCenter;
        unitLabel.font = [UIFont systemFontOfSize:10.0f];
        if ([self.unitArray[0] length] != 0) {
            unitLabel.text = [NSString stringWithFormat:@"(%@)", self.unitArray[0]];
        }
        
        unitLabel.numberOfLines = 2;
        [self addSubview:unitLabel];
        
        for (int i = 0; i < self.yPointNum; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(0,  self.bounds.size.height - (i * interval + 15), self.bounds.size.width - 2, 30);
            
            if (i == 0) {
                if (DecimalDigits == 2) {
                    label.text = [NSString stringWithFormat:@"%.2f",minValue];
                } else if (DecimalDigits == 1) {
                    label.text = [NSString stringWithFormat:@"%.1f",minValue];
                } else {
                    label.text = [NSString stringWithFormat:@"%.0f",minValue];
                }
            } else {
                if (DecimalDigits == 2) {
                    label.text = [NSString stringWithFormat:@"%.2f",minValue + (i * avgValue)];
                } else if (DecimalDigits == 1) {
                    label.text = [NSString stringWithFormat:@"%.1f",minValue + (i * avgValue)];
                } else {
                    label.text = [NSString stringWithFormat:@"%.0f",minValue + (i * avgValue)];
                }
            }
            label.font = [UIFont systemFontOfSize:10.0f];
            if (label.text.length > 6) {
                label.textAlignment = NSTextAlignmentLeft;
            } else {
                label.textAlignment = NSTextAlignmentRight;
            }
            
            label.numberOfLines = 2;
            [self addSubview:label];
        }
        if (self.yTitleArray.count > 1) {
            [self drawYViewWithX:self.superview.bounds.size.width - 40];
            
            UIView *bgview = [[UIView alloc]init];
            bgview.frame = CGRectMake(self.superview.bounds.size.width - 39, 0, 39, self.bounds.size.height);
            bgview.backgroundColor = [UIColor whiteColor];
            [self addSubview:bgview];
            
            UILabel *unitLabel2 = [[UILabel alloc]init];
            unitLabel2.frame = CGRectMake(self.superview.bounds.size.width - 50, 0, 50, 20);
            unitLabel2.textAlignment = NSTextAlignmentCenter;
            unitLabel2.font = [UIFont systemFontOfSize:10.0f];
            if (self.lineRightY) {
                
                unitLabel.text = [self.unitArray[1] length] == 0 ? @"":[NSString stringWithFormat:@"(%@)", self.unitArray[1]];
                unitLabel2.text = [self.unitArray[0] length] == 0 ? @"":[NSString stringWithFormat:@"(%@)", self.unitArray[0]];
            } else {
                unitLabel.text = [self.unitArray[0] length] == 0 ? @"":[NSString stringWithFormat:@"(%@)", self.unitArray[0]];
                unitLabel2.text = [self.unitArray[1] length] == 0 ? @"":[NSString stringWithFormat:@"(%@)", self.unitArray[1]];
            }

            
            unitLabel2.numberOfLines = 2;
            [self addSubview:unitLabel2];
            
            for (int i = 0; i < self.yPointNum; i++) {
                UILabel *label = [[UILabel alloc]init];
                label.frame = CGRectMake(self.superview.bounds.size.width - 39, i * interval + 15, self.bounds.size.width - 1, 30);
                
                if (i == 0) {
                    label.text = [NSString stringWithFormat:@"%.0f",maxValue2];
                } else if (i == self.yPointNum - 1) {
                    label.text = [NSString stringWithFormat:@"%.0f",minValue2];
                } else {
                    label.text = [NSString stringWithFormat:@"%.0f",maxValue2 - (i * avgValue2)];
                }
                label.font = [UIFont systemFontOfSize:10.0f];
                label.textAlignment = NSTextAlignmentLeft;
                label.numberOfLines = 2;
                [self addSubview:label];
            }
        }
    }
}

- (void)drawYViewWithX:(CGFloat)x {
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:CGPointMake(x, self.bounds.size.height)];
    // 其他点
    [linePath addLineToPoint:CGPointMake(x, 30)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor colorWithRed:79 / 255.0 green:145 / 255.0 blue:205 / 255.0 alpha:1.0].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [self.layer addSublayer:lineLayer];
}

///取最大值、最小值、最大最小差值平均数
- (void)compute {
    
    maxValue = [[self.yTitleArray[0] valueForKeyPath:@"@max.floatValue"] floatValue];
    minValue = [[self.yTitleArray[0] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat differenceValue = maxValue - minValue;
    
    avgValue = (maxValue - minValue) / (CGFloat)(self.yPointNum - 1);
    
    ///修正等差值,规范显示
    
    if (avgValue < 0.04) {
        avgValue = 0.05;
        DecimalDigits = 2;
    } else if (avgValue >= 0.04 && avgValue < 0.08) {
        avgValue = 0.1;
        DecimalDigits = 1;
    } else if (avgValue >= 0.08 && avgValue < 0.4) {
        avgValue = 0.5;
        DecimalDigits = 1;
    } else if (avgValue >= 0.4 && avgValue < 0.8) {
        avgValue = 1;
        DecimalDigits = 0;
    }  else {
        avgValue = ((differenceValue / (self.yPointNum - 3)) * (self.yPointNum + 1)) / (self.yPointNum - 1);
        avgValue = (NSInteger)avgValue + 1;
        DecimalDigits = 0;
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
    
    
    //判断第二条y轴
    if (self.yTitleArray.count > 1) {
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

        avgValue2 = (maxValue2 - minValue2) / (CGFloat)(self.yPointNum - 1);

        if (self.lineRightY) {
            CGFloat min = minValue;
            CGFloat max = maxValue;
            CGFloat avg = avgValue;
            
            minValue = minValue2;
            minValue2 = min;
            maxValue = maxValue2;
            maxValue2 = max;
            avgValue = avgValue2;
            avgValue2 = avg;
        }
    }
}

@end
