//
//  BaseViewController.h
//  YiJianBluetooth
//
//  Created by tyl on 16/8/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


- (void)setExtraCellLineHidden:(UITableView *)tableView;

-(void)initrightBarButtonItem:(NSString*)title action:(SEL)action;

@end
