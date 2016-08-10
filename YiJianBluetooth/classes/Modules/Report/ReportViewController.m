//
//  ReportViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/9.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ReportViewController.h"
#import "YiJianBluetooth-Bridging-Header.h"
#import "YiJianBluetooth-Swift.h"
#import "TempChartViewController.h"
#import "HeartRateViewController.h"

@interface ReportViewController ()<ChartViewDelegate,ChartXAxisValueFormatter>

@property (nonatomic, strong) RadarChartView *radarChartView;
@property (nonatomic, strong) RadarChartData *data;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;
@property (nonatomic, strong) UIButton *btn6;


@property (nonatomic, strong) NSArray *title_arr;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_arr   = @[@"体温",@"心电",@"心率",@"血糖",@"血压",@"血氧"];

    // Do any additional setup after loading the view.
    self.navigationItem.title = @"报告";

    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建雷达图对象
    self.radarChartView = [[RadarChartView alloc] initWithFrame:CGRectMake(20, 10, SCR_W-40, 300)];
    [self.view addSubview:self.radarChartView];
    self.radarChartView.delegate = self;
    self.radarChartView.descriptionText = @"123";//描述
    self.radarChartView.rotationEnabled = YES;//是否允许转动
    self.radarChartView.highlightPerTapEnabled = YES;//是否能被选中
    
    
    
    
    //雷达图线条样式
    self.radarChartView.webLineWidth = 0.5;//主干线线宽
    self.radarChartView.webColor = [self colorWithHexString:@"#c2ccd0"];//主干线线宽
    self.radarChartView.innerWebLineWidth = 0.375;//边线宽度
    self.radarChartView.innerWebColor = [self colorWithHexString:@"#c2ccd0"];//边线颜色
    self.radarChartView.webAlpha = 1;//透明度
    self.radarChartView.drawWeb = YES;
    
    //设置 xAxi
    ChartXAxis *xAxis = self.radarChartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:15];//字体
//    xAxis.labelTextColor = [self colorWithHexString:@"#057748"];//颜色
    xAxis.labelTextColor = [UIColor blackColor];//颜色

    xAxis.enabled=YES;
    xAxis.valueFormatter=self;
    
    
    
    //设置 yAxis
    ChartYAxis *yAxis = self.radarChartView.yAxis;
    yAxis.axisMinValue = 0.0;//最小值
    yAxis.axisMaxValue = 150.0;//最大值
    yAxis.drawLabelsEnabled = YES;//是否显示 label
    yAxis.labelCount = 6;// label 个数
    yAxis.labelFont = [UIFont systemFontOfSize:9];// label 字体
    yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
    
    
    //为雷达图提供数据
    self.data = [self setData];
    self.radarChartView.data = self.data;
    [self.radarChartView renderer];
    
    //设置动画
    [self.radarChartView animateWithYAxisDuration:0.1f];
    
    //改变数据button
    UIButton *updateDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateDataBtn.frame = CGRectMake(20, 330, SCR_W-40, 40);
    [updateDataBtn setTitle:@"改变数据" forState:UIControlStateNormal];
    [updateDataBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [updateDataBtn setBackgroundColor:[UIColor cyanColor]];
    updateDataBtn.layer.cornerRadius = 5;
    [self.view addSubview:updateDataBtn];
    [updateDataBtn addTarget:self action:@selector(updateDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 setBackgroundColor:[UIColor darkTextColor]];
    _btn1.layer.cornerRadius = 5;
    _btn1.tag = 100;
    _btn1.alpha=0.05;

    [_btn1 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn2 setBackgroundColor:[UIColor darkTextColor]];
    _btn2.layer.cornerRadius = 5;
    _btn2.tag = 101;
    _btn2.alpha=0.05;

    [_btn2 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn3 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn3 setBackgroundColor:[UIColor darkTextColor]];
    _btn3.layer.cornerRadius = 5;
    _btn3 .tag = 102;
    _btn3.alpha=0.05;

    [_btn3 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn4 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn4 setBackgroundColor:[UIColor darkTextColor]];
    _btn4.layer.cornerRadius = 5;
    _btn4.tag = 103;
    _btn4.alpha=0.05;

    [_btn4 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn5 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn5 setBackgroundColor:[UIColor darkTextColor]];
    _btn5.layer.cornerRadius = 5;
    _btn5.tag = 104;
    _btn5.alpha=0.05;

    [_btn5 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn6 =[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn6 setBackgroundColor:[UIColor darkTextColor]];
    _btn6.layer.cornerRadius = 5;
    _btn6.alpha=0.05;
    _btn6.tag = 105;
    [_btn6 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.radarChartView addSubview:self.btn1];
    [self.radarChartView addSubview:self.btn2];
    [self.radarChartView addSubview:self.btn3];
    [self.radarChartView addSubview:self.btn4];
    [self.radarChartView addSubview:self.btn5];
    [self.radarChartView addSubview:self.btn6];
    
    
    
}

- (void)pushBtn:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 100://体温
        {
            TempChartViewController *Temp = [[TempChartViewController alloc] init];
            Temp.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:Temp animated:YES];
        }
            break;
        case 101:
        {
        }
            break;
        case 102:
        {
            HeartRateViewController *HeartRate = [[HeartRateViewController alloc] init];
            HeartRate.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:HeartRate animated:YES];
        }
            break;
        case 103:
        {
        }
            break;
        case 104:
        {
        }
            break;
        case 105:
        {
        }
            break;
  
            
        default:
            break;
    }
    
}

//刷新数据
- (void)updateDataBtnClick{
    self.data = [self setData];
    self.radarChartView.data = self.data;
    [self.radarChartView animateWithYAxisDuration:0.1f];
}

//创建数据
- (RadarChartData *)setData{
    
    double mult = 100;
    int count = 6;//维度的个数
    
    //每个维度的名称或描述
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"%@", self.title_arr[i]]];
    }
    
    //每个维度的数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult) + mult / 2;//产生 50~150 的随机数
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
        [yVals1 addObject:entry];
    }
    
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithYVals:yVals1 label:@"标准"];
    set1.lineWidth = 0.5;//数据折线线宽
//    [set1 setColor:[self colorWithHexString:@"#ff8936"]];//数据折线颜色
    set1.drawFilledEnabled = YES;//是否填充颜色
//    set1.fillColor = [self colorWithHexString:@"#ff8936"];//填充颜色
    [set1 setColor:[self colorWithHexString:@"#ff2d51"]];
    set1.fillColor = [self colorWithHexString:@"#ff2d51"];
    set1.fillAlpha = 0.25;//填充透明度
    set1.drawValuesEnabled = NO;//是否绘制显示数据
    set1.valueFont = [UIFont systemFontOfSize:9];//字体
    set1.valueTextColor = [UIColor grayColor];//颜色
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult/2) + mult / 2/2;//产生 50~150 的随机数
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:randomVal xIndex:i];
        [yVals2 addObject:entry];
    }
    RadarChartDataSet *set2 = [[RadarChartDataSet alloc] initWithYVals:yVals2 label:@"测量"];
    set2.lineWidth = 0.5;//数据折线线宽
    set2.drawFilledEnabled = YES;//是否填充颜色
    [set2 setColor:[UIColor greenColor]];
    set2.fillColor = [UIColor greenColor];
    set2.fillAlpha = 0.25;//填充透明度
    set2.drawValuesEnabled = NO;//是否绘制显示数据
    set2.valueFont = [UIFont systemFontOfSize:9];//字体
    set2.valueTextColor = [UIColor grayColor];//颜色
    
    RadarChartData *data = [[RadarChartData alloc] initWithXVals:xVals dataSets:@[set1,set2]];
    
    return data;
}
-(NSString *)stringForXValue:(NSInteger)index original:(NSString *)original viewPortHandler:(ChartViewPortHandler *)viewPortHandler x:(CGFloat)x y:(CGFloat)y{
    
    switch (index) {
        case 0:
        {
            _btn1.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 1:
        {
            _btn2.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 2:
        {
            _btn3.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 3:
        {
            _btn4.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 4:
        {
            _btn5.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
        case 5:
        {
            _btn6.frame = CGRectMake(x-15, y, 32, 20);
        }
            break;
 
            
        default:
            break;
    }
    
    
    return original;
}

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * _Nonnull)highlight{
    
    
    //    NSLog(@"chartValueSelected");
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    //    NSLog(@"chartValueNothingSelected");
    //    NSLog(@"%@",chartView._data);
    
    
}
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    //    NSLog(@"chartScaled");
    
}
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    //    NSLog(@"chartTranslated");
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end