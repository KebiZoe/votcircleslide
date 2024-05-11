//
//  ZSettingViewController.m
//  votcircleslide_Example
//
//  Created by 曾祥宪 on 2024/5/11.
//  Copyright © 2024 s.zengxiangxian@byd.com. All rights reserved.
//

#import "ZSettingViewController.h"
#import "ZViewController.h"
@interface ZSettingViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slide;
@property (weak, nonatomic) IBOutlet UISwitch *sw;
@property (weak, nonatomic) IBOutlet UILabel *angleLbl;


@end

@implementation ZSettingViewController
- (IBAction)setAngle:(UISlider *)sender {
    self.angleLbl.text = [NSString stringWithFormat:@"最大旋转角度%.1f",sender.value];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)jumptoCircleVC:(id)sender {
    ZViewController *vc = [[ZViewController alloc] init];
    vc.angle = self.slide.value;
    vc.rigidDirection = self.sw.on;
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
