//
//  HeartRateSetViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/11.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "HeartRateSetViewController.h"
#import "ScannerViewController.h"
#import "HeartRateSetDetailViewController.h"
#import "HeartRateViewController.h"
@interface HeartRateSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel  *temp_lab;
@property (nonatomic, strong) UIButton *startTest_btn;


@property (nonatomic, strong) UITableView *tempTableview;

@property (strong, nonatomic) CBPeripheral* connectedPeripheral;




@property (nonatomic, strong) NSDictionary *linktopPeripheral;

//设备数组
@property (nonatomic, strong) NSMutableArray *peripheral_arr;
@property (nonatomic, strong) UIImageView *pictureImageView;


@end

@implementation HeartRateSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  =[UIColor whiteColor];
    self.navigationItem.title = @"心率";
    
    [self initTempLayout];
    [self initLeftBarButtonItem];
    [self initRightBarButtonItem];
    [self addtableview];
}

- (void)backToSuper{
    CBPeripheral *per = [_linktopPeripheral objectForKey:@"peripheral"];
    if (per)
    {
        [_linktopManager disconnectBlueTooth:per];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initRightBarButtonItem {
    MyCustomButton *button = [MyCustomButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 44)];
    UIImage *image = [UIImage imageNamed:@"bag"];
    [button setImage:image forState:UIControlStateNormal];
    [button setMyButtonImageFrame:CGRectMake(25, 12, image.size.width-10, image.size.height-10)];
    [button addTarget:self action:@selector(setRightBtn)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    //self.navigationItem.rightBarButtonItem = leftBtn;
    
    
    MyCustomButton *rightTwoButton = [MyCustomButton buttonWithType:UIButtonTypeCustom];
    [rightTwoButton setFrame:CGRectMake(0, 0, 40, 44)];
    UIImage *image2 = [UIImage imageNamed:@"printer"];
    [rightTwoButton setImage:image2 forState:UIControlStateNormal];
    [rightTwoButton setMyButtonImageFrame:CGRectMake(25, 12, image2.size.width-10, image2.size.height-10)];
    [rightTwoButton addTarget:self action:@selector(setRight2Btn)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightTwoBtn = [[UIBarButtonItem alloc]initWithCustomView:rightTwoButton];
    self.navigationItem.rightBarButtonItems = @[leftBtn,rightTwoBtn];
    
}
-(void)setRight2Btn{
    
    HeartRateViewController *hearVC = [[HeartRateViewController alloc] init];
    [self.navigationController pushViewController:hearVC animated:YES];
}

-(void)setRightBtn{
    
    _tempTableview.hidden = !_tempTableview.hidden;
//    HeartRateSetDetailViewController *tempVC = [[HeartRateSetDetailViewController alloc] init];
//    [self.navigationController pushViewController:tempVC animated:YES];
}

- (void)addtableview{
    _peripheral_arr = [[NSMutableArray alloc] initWithObjects:@"Checkme",@"linkTop",@"Health", nil];
    
    _tempTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _peripheral_arr.count*40)];
    _tempTableview.delegate=self;
    _tempTableview.dataSource=self;
    [_tempTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setExtraCellLineHidden:_tempTableview];
    _tempTableview.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:_tempTableview];
    
    _tempTableview.hidden= YES;
    
}
- (void) initTempLayout{
    self.temp_lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    self.temp_lab.textAlignment=NSTextAlignmentLeft;
    self.temp_lab.text=@"心率";
    self.temp_lab.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    self.temp_lab.textColor = [UIColor blackColor];
    [self.view addSubview: self.temp_lab];
    
    
    
    
    
    self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, SCR_W - 40, SCR_H/667 *150)];
    self.pictureImageView.image = [UIImage imageNamed:@"Yosemite03.jpg"];
    [self.view addSubview:self.pictureImageView];
    
    
    
    _startTest_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startTest_btn.frame = CGRectMake(20, SCR_H-NAVIGATION_HEIGHT-70, SCR_W-40, 50);
    [_startTest_btn addTarget:self action:@selector(setRightBtn) forControlEvents:(UIControlEventTouchUpInside)];
    _startTest_btn.backgroundColor = UIColorFromRGB(0xc62828);
    [_startTest_btn setTitle:@"连接设备" forState:(UIControlStateNormal)];
    [_startTest_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.startTest_btn.layer.masksToBounds = YES;
    self.startTest_btn.layer.cornerRadius = 6.0;
    self.startTest_btn.layer.borderWidth = 1.0;
    self.startTest_btn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_startTest_btn];
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheral_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    static NSString *NailCellIdentifier = @"NailCell";
    UITableViewCell *nailcell = [tableView dequeueReusableCellWithIdentifier:NailCellIdentifier];
    if (nailcell == nil) {
        nailcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NailCellIdentifier];
    }
    nailcell.textLabel.textAlignment = NSTextAlignmentLeft;
    nailcell.textLabel.text = _peripheral_arr[indexPath.row];
    [nailcell.textLabel setFont:[UIFont systemFontOfSize:text_size_small]];
    nailcell.imageView.image = nil;
    nailcell.accessoryType = UITableViewCellAccessoryNone;
    nailcell.backgroundColor = [UIColor whiteColor];
    nailcell.alpha=1;
    return nailcell;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        NSInteger index = indexPath.row;
        ScannerViewController *scan = [[ScannerViewController alloc] init];
        scan.delegate = self;
        scan.scan_Type=index+1;
    //
    
    _tempTableview.hidden=YES;
    
     [self.navigationController pushViewController:scan animated:YES];
    
}

- (void)linktopManger:(SDKHealthMoniter *)manager didperiphralSelected:(NSDictionary *)dic_peripheral{
    _scantype=scan_linkTop;
    _linktopPeripheral = dic_peripheral;
    
    _linktopManager = manager;
    if (manager) {
        [_startTest_btn removeTarget:nil action:nil forControlEvents:(UIControlEventTouchUpInside)];
        [_startTest_btn addTarget:self action:@selector(clickbtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [_startTest_btn setTitle:@"开始测心率" forState:(UIControlStateNormal)];
    }
    
    
}
- (void)clickbtn:(id)sender{
    
    HeartRateSetDetailViewController *detailVC = [[HeartRateSetDetailViewController alloc] init];
    detailVC.linktopManager = _linktopManager;
    detailVC.bluetoothManager = _bluetoothManager;
    detailVC.scantype = self.scantype;
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    _tempTableview.hidden=YES;
    
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
