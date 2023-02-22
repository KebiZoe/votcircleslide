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
@end

@implementation ZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"hello world");
    [self.view addSubview:self.circleSlider];
    [self.view addSubview:self.currentValueLabel];
    [self.view addSubview:self.finalValueLabel];
    [self.view addSubview:self.progressValueLabel];
    [self.view addSubview:self.progressSlider];
    [self.view addSubview:self.loadProgressSlider];
    [self.view addSubview:self.valueLabel];
    [self.view addSubview:self.progressLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (VOTCircleSlider *)circleSlider {
    if (!_circleSlider) {
        _circleSlider = [[VOTCircleSlider alloc] initWithFrame:CGRectMake(kAutoSize(13), (kScreenHeight - 300) / 2.0, kScreenWidth-kAutoSize(26), kScreenWidth-kAutoSize(26))];
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
        _currentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, 100, 200, 30)];
        _currentValueLabel.textAlignment = NSTextAlignmentCenter;
        _currentValueLabel.text = @"当前值：0";
    }
    return _currentValueLabel;
}

- (UILabel *)finalValueLabel {
    if (!_finalValueLabel) {
        _finalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, 140, 200, 30)];
        _finalValueLabel.textAlignment = NSTextAlignmentCenter;
        _finalValueLabel.text = @"最终值：0";
    }
    return _finalValueLabel;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, kScreenHeight - 60, kScreenWidth - 80 - 20, 30)];
        _progressSlider.backgroundColor = [UIColor clearColor];
        _progressSlider.minimumValue = 0;
        _progressSlider.maximumValue = 1;
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
        _progressValueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 230) / 2.0, 180, 230, 30)];
        _progressValueLabel.textAlignment = NSTextAlignmentCenter;
        _progressValueLabel.text = @"加载进度：0";
    }
    return _progressValueLabel;
}

- (UISlider *)loadProgressSlider {
    if (!_loadProgressSlider) {
        _loadProgressSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, kScreenHeight - 100, kScreenWidth - 80 - 20, 30)];
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
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, kScreenHeight - 100, 50, 30)];
        _progressLabel.text = @"加载进度:";
        [_progressLabel sizeToFit];
    }
    return _progressLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, kScreenHeight - 60, 50, 30)];
        _valueLabel.text = @"value:";
        [_valueLabel sizeToFit];
    }
    return _valueLabel;
}

#pragma mark - action

/*以下三个方法，都要添加对slider.interaction的判断。
 *因为虽然看起来是个圆环，但是响应手势的区域确实整个矩形的View
 *在内部添加了interaction这个属性用于限定响应区域，在规定的区
 */

- (void)circleSliderTouchDown:(VOTCircleSlider *)slider {
    
    
}

- (void)circleSliderValueChanging:(VOTCircleSlider *)slider {
    
    self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f",slider.value * 360];
    self.progressSlider.value = slider.value;
}

- (void)circleSliderValueDidChanged:(VOTCircleSlider *)slider {
    
    self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f",slider.value * 360];
}

- (void)progressSliderValueChanging:(UISlider *)slider {
    if (slider.tag == 100) {
        self.currentValueLabel.text = [NSString stringWithFormat:@"当前值：%.0f",slider.value * 360];
        self.circleSlider.value = slider.value;
    } else if (slider.tag == 101) {
        self.progressValueLabel.text = [NSString stringWithFormat:@"加载进度：%.0f",slider.value * 360];
        self.circleSlider.loadProgress = slider.value;
    }
}

- (void)progressSliderValueDidChanged:(UISlider *)slider {
    if (slider.tag == 100) {
        self.progressSlider.value = slider.value;
        self.finalValueLabel.text = [NSString stringWithFormat:@"最终值：%.0f",slider.value * 360];
    } else if (slider.tag == 101) {
        
    }
}
@end
