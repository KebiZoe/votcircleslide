//
//  ZViewController.m
//  votcircleslide
//
//  Created by s.zengxiangxian@byd.com on 02/17/2023.
//  Copyright (c) 2023 s.zengxiangxian@byd.com. All rights reserved.
//

#import "ZViewController.h"
#import "VOTCircleSlider.h"
#import "ZDefine.h"

@interface ZViewController ()
@property (nonatomic, strong) VOTCircleSlider *circleSlider;
@property (nonatomic, strong) UILabel *currentValueLabel;
@property (nonatomic, strong) UILabel *finalValueLabel;
@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) UILabel *progressValueLabel;
@property (nonatomic, strong) UISlider *loadProgressSlider;

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIButton *resume;
@end

@implementation ZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.circleSlider];
    [self.view addSubview:self.currentValueLabel];
    [self.view addSubview:self.finalValueLabel];
    [self.view addSubview:self.progressValueLabel];
    [self.view addSubview:self.progressSlider];
    [self.view addSubview:self.loadProgressSlider];
    [self.view addSubview:self.valueLabel];
    [self.view addSubview:self.progressLabel];
    [self.view addSubview:self.resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
- (VOTCircleSlider *)circleSlider {
    if (!_circleSlider) {
        _circleSlider = [[VOTCircleSlider alloc] initWithFrame:CGRectMake(kAutoSize(13), (kScreenHeight - kAutoSize(300)) / 2.0, kScreenWidth-kAutoSize(26), kScreenWidth-kAutoSize(26))];
        _circleSlider.maxRotationAngle = 270;
        _circleSlider.rigidDirection = YES;
        _circleSlider.BlockTips = ^(NSString * tips) {
            NSLog(@"%@",tips);
        };
        [_circleSlider addTarget:self
                          action:@selector(circleSliderTouchDown:)
                forControlEvents:UIControlEventTouchDown];
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueChanging:)
                forControlEvents:UIControlEventValueChanged];
        [_circleSlider addTarget:self
                          action:@selector(circleSliderValueDidChanged:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleSlider;
}

- (UILabel *)currentValueLabel {
    if (!_currentValueLabel) {
        _currentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, kAutoSize(100), 200, 30)];
        _currentValueLabel.textAlignment = NSTextAlignmentCenter;
        _currentValueLabel.text = @"当前值：0°";
    }
    return _currentValueLabel;
}

- (UILabel *)finalValueLabel {
    if (!_finalValueLabel) {
        _finalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, kAutoSize(140), 200, 30)];
        _finalValueLabel.textAlignment = NSTextAlignmentCenter;
        _finalValueLabel.text = @"最终值：0°";
    }
    return _finalValueLabel;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, kScreenHeight - kAutoSize(60), kScreenWidth - 80 - 20, 30)];
        _progressSlider.backgroundColor = [UIColor clearColor];
        _progressSlider.minimumValue = -self.circleSlider.maxRotationAngle/360;
        _progressSlider.maximumValue = self.circleSlider.maxRotationAngle/360;
        _progressSlider.value = 0;
        _progressSlider.tag = 100;
        [_progressSlider addTarget:self
                            action:@selector(progressSliderValueChanging:)
                  forControlEvents:UIControlEventValueChanged];

        [_progressSlider addTarget:self
                            action:@selector(progressSliderValueDidChanged:)
                  forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _progressSlider;
}

- (UILabel *)progressValueLabel {
    if (!_progressValueLabel) {
        _progressValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 230) / 2.0, kAutoSize(180), 230, 30)];
        _progressValueLabel.textAlignment = NSTextAlignmentCenter;
        _progressValueLabel.text = @"加载进度：0%";
    }
    return _progressValueLabel;
}

- (UISlider *)loadProgressSlider {
    if (!_loadProgressSlider) {
        _loadProgressSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, kScreenHeight - kAutoSize(100), kScreenWidth - 80 - 20, 30)];
        _loadProgressSlider.backgroundColor = [UIColor clearColor];
        _loadProgressSlider.minimumValue = 0;
        _loadProgressSlider.maximumValue = 1;
        _loadProgressSlider.value = 0;
        _loadProgressSlider.tag = 101;
        [_loadProgressSlider addTarget:self
                                action:@selector(progressSliderValueChanging:)
                      forControlEvents:UIControlEventValueChanged];
        
        [_loadProgressSlider addTarget:self
                                action:@selector(progressSliderValueDidChanged:)
                      forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loadProgressSlider;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, kScreenHeight - kAutoSize(100), 50, 30)];
        _progressLabel.text = @"加载进度:";
        [_progressLabel sizeToFit];
    }
    return _progressLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, kScreenHeight - kAutoSize(60), 50, 30)];
        _valueLabel.text = @"value:";
        [_valueLabel sizeToFit];
    }
    return _valueLabel;
}
- (UIButton *)resume {
    if (!_resume){
        _resume = [UIButton buttonWithType:UIButtonTypeCustom];
        _resume.frame = CGRectMake(self.view.center.x-100, kScreenHeight - kAutoSize(180), 200, 40);
        _resume.backgroundColor = UIColor.darkGrayColor;
        _resume.layer.cornerRadius = 8;
        [_resume setTitle:@"重新开始" forState:UIControlStateNormal];
        [_resume addTarget:self action:@selector(handleResumeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _resume;
}
#pragma mark - action
- (void)circleSliderTouchDown:(VOTCircleSlider *)slider {
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f°",slider.value * 360];
    self.progressSlider.value = slider.value;
}

- (void)circleSliderValueChanging:(VOTCircleSlider *)slider {
    
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f°",slider.value * 360];
    self.progressSlider.value = slider.value;
}

- (void)circleSliderValueDidChanged:(VOTCircleSlider *)slider {
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f°",slider.value * 360];
    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f°",slider.value * 360];
    self.progressSlider.value = slider.value;
}

- (void)progressSliderValueChanging:(UISlider *)slider {
    if (slider.tag == 100) {
        self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f°",slider.value * 360];
        self.circleSlider.value = slider.value;
    } else if (slider.tag == 101) {
        self.progressValueLabel.text = [NSString stringWithFormat:@"加载进度：%.0f%%",slider.value * 100];
        self.circleSlider.loadProgress = slider.value;
    }
}

- (void)progressSliderValueDidChanged:(UISlider *)slider {
    if (slider.tag == 100) {
        self.circleSlider.value = slider.value;
        [self.circleSlider adsorbedToTheNearestscale];
        self.progressSlider.value = self.circleSlider.value;
        self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f°",self.circleSlider.value * 360];
        self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f°",self.circleSlider.value * 360];
    } else if (slider.tag == 101) {
        self.progressValueLabel.text = [NSString stringWithFormat:@"加载进度：%.0f%%",slider.value * 100];
        self.circleSlider.loadProgress = slider.value;
    }
}
- (void)handleResumeAction:(id)sender{
    [self.circleSlider resumeAnimation:YES];
    self.progressSlider.value = 0;
    self.loadProgressSlider.value = 0;
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f°", 0.0];
    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f°", 0.0];
    self.progressValueLabel.text = [NSString stringWithFormat:@"加载进度：%.0f%%", 0.0];
}
@end
