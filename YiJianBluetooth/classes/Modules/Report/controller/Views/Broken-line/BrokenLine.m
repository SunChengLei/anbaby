//
//  BrokenLine.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "BrokenLine.h"

@implementation BrokenLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame type:(BOOL)type{
    
    self=[super initWithFrame:frame];
    if (self) {
        _isBloodPressure=type;
        [self setCake];
    }
    return self;
}

- (void)setCake{
    self.backgroundColor = [UIColor whiteColor];
    
    
    //添加折线视图LineChartView
    self.LineChartView = [[LineChartView alloc] initWithFrame:self.bounds];
    self.LineChartView.delegate = self;//设置代理
    [self addSubview:self.LineChartView];
    
    //基本样式
    self.LineChartView.backgroundColor =  [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    self.LineChartView.noDataText = @"暂无数据";
    //交互样式
    self.LineChartView.scaleYEnabled = NO;//取消Y轴缩放
    self.LineChartView.doubleTapToZoomEnabled = YES;//取消双击缩放
    self.LineChartView.dragEnabled = YES;//启用拖拽图标
    self.LineChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    self.LineChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    //X轴样式
    ChartXAxis *xAxis = self.LineChartView.xAxis;
    xAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = YES;//不绘制网格线
    xAxis.spaceBetweenLabels = 4;//设置label间隔
    xAxis.labelTextColor = [self colorWithHexString:@"#057748"];//label文字颜色
    //Y轴样式
    self.LineChartView.rightAxis.enabled = NO;//不绘制右边轴
    ChartYAxis *leftAxis = self.LineChartView.leftAxis;//获取左边Y轴
    leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.forceLabelsEnabled = YES;//不强制绘制指定数量的label
    leftAxis.showOnlyMinMaxEnabled = YES;//是否只显示最大值和最小值
    leftAxis.axisMinValue = 0;//设置Y轴的最小值
    leftAxis.startAtZeroEnabled = YES;//从0开始绘制
    leftAxis.axisMaxValue = 15;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//Y轴线宽
    leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];//自定义格式
    leftAxis.valueFormatter.positiveSuffix = @" mmol/L";//数字后缀单位
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [self colorWithHexString:@"#057748"];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    //网格线样式
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    //添加限制线
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:3.9 label:@"正常区间"];
    limitLine.lineWidth = 2;
    limitLine.lineColor = [UIColor greenColor];
    limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
    limitLine.labelPosition = ChartLimitLabelPositionRightTop;//位置
    limitLine.valueTextColor = [self colorWithHexString:@"#057748"];//label文字颜色
    limitLine.valueFont = [UIFont systemFontOfSize:12];//label字体
    [leftAxis addLimitLine:limitLine];//添加到Y轴上
    leftAxis.drawLimitLinesBehindDataEnabled = NO;//设置限制线绘制在折线图的后面
    
    //添加限制线
    ChartLimitLine *limitLine2 = [[ChartLimitLine alloc] initWithLimit:6.1 label:@""];
    limitLine2.lineWidth = 2;
    limitLine2.lineColor = [UIColor greenColor];
    limitLine2.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
    limitLine2.labelPosition = ChartLimitLabelPositionRightTop;//位置
    limitLine2.valueTextColor = [self colorWithHexString:@"#057748"];//label文字颜色
    limitLine2.valueFont = [UIFont systemFontOfSize:12];//label字体
    [leftAxis addLimitLine:limitLine2];//添加到Y轴上
    leftAxis.drawLimitLinesBehindDataEnabled = NO;//设置限制线绘制在折线图的后面
    
    //描述及图例样式
    [self.LineChartView setDescriptionText:@"血糖控制图"];
    [self.LineChartView setDescriptionTextColor:[UIColor darkGrayColor]];
    self.LineChartView.legend.form = ChartLegendFormLine;
    self.LineChartView.legend.formSize = 30;
    self.LineChartView.legend.textColor = [UIColor darkGrayColor];
    self.lineCData = [self setData];
    self.LineChartView.data = self.lineCData;
    [self.LineChartView animateWithXAxisDuration:1.0f];
}

//为折线图设置数据
- (LineChartData *)setData{
    
    int xVals_count = 7;//X轴上要显示多少条数据
    double maxYVal = 13;//Y轴的最大值
    
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"第%d天", i+1]];
    }
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        double mult = maxYVal + 1;
        double val = (double)(arc4random_uniform(mult));
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:val xIndex:i];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    if (self.LineChartView.data.dataSetCount > 0) {
        LineChartData *data = (LineChartData *)self.LineChartView.data;
        set1 = (LineChartDataSet *)data.dataSets[0];
        set1.yVals = yVals;
        return data;
    }else{
        //创建LineChartDataSet对象
        set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"测量值"];
        //设置折线的样式
        set1.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
        [set1 setColor:[self colorWithHexString:@"#007FFF"]];//折线颜色
        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.circleRadius = 4.0f;//拐点半径
        set1.circleColors = @[[UIColor redColor], [UIColor greenColor]];//拐点颜色
        //拐点中间的空心样式
        set1.drawCircleHoleEnabled = YES;//是否绘制中间的空心
        set1.circleHoleRadius = 2.0f;//空心的半径
        set1.circleHoleColor = [UIColor blackColor];//空心的颜色
        //折线的颜色填充样式
        //第一种填充样式:单色填充
        //        set1.drawFilledEnabled = YES;//是否填充颜色
        //        set1.fillColor = [UIColor redColor];//填充颜色
        //        set1.fillAlpha = 0.3;//填充颜色的透明度
        //第二种填充样式:渐变填充
        set1.drawFilledEnabled = YES;//是否填充颜色
        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fillAlpha = 0.3f;//透明度
        set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
        CGGradientRelease(gradientRef);//释放gradientRef
        
        //点击选中拐点的交互样式
        set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
        set1.highlightColor = [self colorWithHexString:@"#c83c23"];//点击选中拐点的十字线的颜色
        set1.highlightLineWidth = 1.0/[UIScreen mainScreen].scale;//十字线宽度
        set1.highlightLineDashLengths = @[@5, @5];//十字线的虚线样式
        
        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        if (_isBloodPressure) {
            
            //        添加第二个LineChartDataSet对象
            LineChartDataSet *set2 = [set1 copy];
            NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
            for (int i = 0; i < xVals_count; i++) {
                double mult = maxYVal + 1;
                double val = (double)(arc4random_uniform(mult));
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:val xIndex:i];
                [yVals2 addObject:entry];
            }
            set2.yVals = yVals2;
            [set2 setColor:[UIColor redColor]];
            set2.drawFilledEnabled = YES;//是否填充颜色
            set2.fillColor = [UIColor redColor];//填充颜色
            set2.fillAlpha = 0.1;//填充颜色的透明度
            [dataSets addObject:set2];
        }
        
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];//文字字体
        [data setValueTextColor:[UIColor grayColor]];//文字颜色
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //自定义数据显示格式
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"#0.0"];
        [data setValueFormatter:formatter];
        
        
        return data;
    }
    
}

#pragma mark - ChartViewDelegate

//点击选中折线拐点时回调
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * _Nonnull)highlight{
    NSLog(@"---chartValueSelected---value: %g", entry.value);
}
//没有选中折线拐点时回调
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    NSLog(@"---chartValueNothingSelected---");
}
//放大折线图时回调
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    NSLog(@"---chartScaled---scaleX:%g, scaleY:%g", scaleX, scaleY);
}
//拖拽折线图时回调
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    NSLog(@"---chartTranslated---dX:%g, dY:%g", dX, dY);
}

#pragma mark --- 将十六进制颜色转换为 UIColor 对象
- (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


-(void)updateDataBtnClick{
    self.lineCData = [self setData];
    self.LineChartView.data = self.lineCData;
    [self.LineChartView animateWithXAxisDuration:2.0f];
}

@end
