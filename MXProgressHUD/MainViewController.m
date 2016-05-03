//
//  MainViewController.m
//  MXProgressHUD
//
//  Created by Apple on 16/5/3.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MainViewController.h"

#import "MXProgressHUD/MXProgressHUD.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *huds;

@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"MXProgressHUD";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (NSArray *)huds
{
    if (_huds == nil) {
        _huds = @[@"Success Message",
                  @"Error Message",
                  @"Text Only",
                  @"Indeterminate Only",
                  @"Indeterminate Message",
                  @"Indeterminate Hide With Text",
                  @"Indeterminate Hide With Success State",
                  @"Indeterminate Hide With Errow State"];
    }
    return _huds;
}

- (void)hideLoadingProgressHUD
{
    [MXProgressHUD hideLoadingProgress];
}

- (void)hideLoadingProgressWithTextStatus
{
    [MXProgressHUD hideWithMessage:@"操作已完成"];
}

- (void)hideLoadingProgressWithSuccessStatus
{
    [MXProgressHUD hideWithSuccessStatus:@"登录成功"];
}

- (void)hideLoadingProgressWithErrowStatus
{
    [MXProgressHUD hideWithErrowStatus:@"密码错误"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.huds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.huds[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: [MXProgressHUD showSuccessWithStatus:@"登录成功"];
            break;
            
        case 1: [MXProgressHUD showErrorWithStatus:@"密码错误"];
            break;
            
        case 2: [MXProgressHUD showLoadingProgressWithMessage:@"登录成功" delay:1.0];
            break;
            
        case 3: {
            [MXProgressHUD showLoadingProgress];
            [self performSelector:@selector(hideLoadingProgressHUD) withObject:nil afterDelay:2.0];
        }
            break;
            
        case 4: {
            [MXProgressHUD showLoadingProgressWithMessage:@"请稍候..."];
            [self performSelector:@selector(hideLoadingProgressHUD) withObject:nil afterDelay:2.0];
        }
            break;
            
        case 5: {
            [MXProgressHUD showLoadingProgressWithMessage:@"请稍候..."];
            [self performSelector:@selector(hideLoadingProgressWithTextStatus) withObject:nil afterDelay:2.0];
        }
            break;
            
        case 6: {
            [MXProgressHUD showLoadingProgressWithMessage:@"请稍候..."];
            [self performSelector:@selector(hideLoadingProgressWithSuccessStatus) withObject:nil afterDelay:2.0];
        }
            break;
            
        case 7: {
            [MXProgressHUD showLoadingProgressWithMessage:@"请稍候..."];
            [self performSelector:@selector(hideLoadingProgressWithErrowStatus) withObject:nil afterDelay:2.0];
        }
            break;
            
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
