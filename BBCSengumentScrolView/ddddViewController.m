//
//  ddddViewController.m
//  BBCSengumentScrolView
//
//  Created by botu on 2019/8/27.
//  Copyright © 2019 dbb. All rights reserved.
//

#import "ddddViewController.h"
#import "ViewController.h"
@interface ddddViewController ()

@end

@implementation ddddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

//进入个人中心
- (IBAction)enterCenterAction:(UIButton *)sender {
    ViewController *vc = [[ViewController alloc] init];
//    vc.isEnlarge = self.enlargeSwitch.on;
//    vc.selectedIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
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
