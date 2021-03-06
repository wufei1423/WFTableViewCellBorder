//
//  ViewController.m
//  WFTableViewCellBorder
//
//  Created by feiwu on 15/9/19.
//  Copyright (c) 2015年 feiwu. All rights reserved.
//

#import "ViewController.h"
#import "UITableViewCell+WFBorder.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"今天上海的天气不错";
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    
    cell.borderOption = WFBorderOptionTop | WFBorderOptionLeft | WFBorderOptionBottom | WFBorderOptionRight;
    cell.borderWidths = UIEdgeInsetsMake(2, 4, 2, 4);
    cell.borderInsets = UIEdgeInsetsMake(15, 0, 30, 0);
    cell.borderDashes = UIEdgeInsetsMake(1, 0, 0, 0);
    if (indexPath.row % 2 == 0) {
        cell.borderColor = [UIColor redColor];
    }
    else {
        cell.borderColor = [UIColor greenColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
