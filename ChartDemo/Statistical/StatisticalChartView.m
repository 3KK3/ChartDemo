//
//  StatisticalChartView.m
//  StatisticalChartDemo
//
//  Created by lanling on 2017/12/25.
//  Copyright © 2017年 lanling. All rights reserved.
//

#import "StatisticalChartView.h"
#import "StatisticalChartYView.h"
#import "StatisticalChartXView.h"

@interface StatisticalChartView ()
{
    CGFloat xViewWidth;
    CGFloat xcViewWidth;
    StatisticalChartYView *yView;
    StatisticalChartXView *xView;
}

@end

@implementation StatisticalChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawView {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    xView = [[StatisticalChartXView alloc]init];
    if (self.yTitleArray.count > 1) {
        xViewWidth = self.bounds.size.width - 80;
        xcViewWidth = self.bounds.size.width - 80;
        xView.frame = CGRectMake(40, 0, xViewWidth, self.bounds.size.height);
    } else {
        xViewWidth = self.bounds.size.width - 40;
        xcViewWidth = self.bounds.size.width - 40;
        xView.frame = CGRectMake(40, 0, xViewWidth, self.bounds.size.height);
    }
    xView.backgroundColor = [UIColor whiteColor];
    [self addSubview:xView];
    
    xView.linePointArray = self.linePointArray;
    xView.barPointArray = self.barPointArray;
    xView.yPointNum = self.yPointNum;
    xView.xTitleArray = self.xTitleArray;
    xView.yTitleArray = self.yTitleArray;
    xView.lineColorArray = self.lineColorArray;
    xView.barColorArray = self.barColorArray;
    xView.showLine1 = self.showLine1;
    xView.showLine2 = self.showLine2;
    xView.showBar1 = self.showBar1;
    xView.showBar2 = self.showBar2;
    xView.showLinePointText = self.showLinePointLabel;
    xView.hadNegativeNumber = self.hadNegativeNumber;
    [xView setXView];
    xView.userInteractionEnabled = YES;
    //添加捏合手势
    [xView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
    //添加拖动手势
    [xView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveView:)]];
    
    yView = [[StatisticalChartYView alloc]init];
    yView.frame = CGRectMake(0, 0, 40, self.bounds.size.height - 49);
    [self addSubview:yView];
    yView.backgroundColor = [UIColor whiteColor];
    yView.yPointNum = self.yPointNum;
    yView.yTitleArray = self.yTitleArray;
    yView.unitArray = self.yUnitArray;
    yView.barPointArray = self.barPointArray;
    yView.hadNegativeNumber = self.hadNegativeNumber;
    yView.lineRightY = self.lineRightY;
    [yView setYView];
    
}

- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer {
    //缩放:设置缩放比例
    CGFloat scale = recognizer.scale;
    
    //放大情况
    if(scale > 1.0) {
        
    }
    
    //缩小情况
    if(scale < 1.0) {
        
    }
    xcViewWidth *= scale;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self updateUI];
    }
    recognizer.scale = 1;
}

- (void)updateUI {
    CGRect rect = xView.frame;
    if (xcViewWidth <= xViewWidth) {
        xcViewWidth = xViewWidth;
        rect.origin.x = 40;
    }
    rect.size.width = xcViewWidth;
    
    if (rect.origin.x < 40 + xViewWidth - rect.size.width) {
        rect.origin.x = 40 + xViewWidth - rect.size.width;
    }
    
    xView.frame = rect;
    for (UIView *view in xView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    if ([xView.layer.sublayers count] > 0) {
        xView.layer.sublayers = nil;
    }
    
    xView.showLine1 = self.showLine1;
    xView.showLine2 = self.showLine2;
    xView.showBar1 = self.showBar1;
    xView.showBar2 = self.showBar2;
    [xView setXView];
}

- (void)moveView:(UIPanGestureRecognizer *)recognizer {
    //只有曲线线图宽度大于显示区宽度才进行移动
    if (recognizer.view.bounds.size.width > xViewWidth) {
        CGPoint point = [recognizer translationInView:self];
        CGFloat x = recognizer.view.center.x + point.x;
//        CGFloat y = recognizer.view.center.y + point.y;
        //进行移动范围限制
        //判断向左移时，曲线图右侧边已显示则停止移动
        if (x + recognizer.view.bounds.size.width / 2.0 <= xViewWidth + 40) {
            x = xViewWidth + 40 - recognizer.view.bounds.size.width / 2.0;
        }
        //判断向右移时，曲线图左侧边已显示则停止移动
        if (x >= recognizer.view.bounds.size.width / 2.0 + 40) {
            x = recognizer.view.bounds.size.width / 2.0 + 40;
        }
        
        recognizer.view.center = CGPointMake(x, recognizer.view.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    }
}

@end
