//
//  VOTCircleSlider.h
//  votcircleslide
//
//  Created by s.zengxiangxian@byd.com  on 15/02/2023.
//  Copyright © 2023 BYD. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 圆环形滑块，和UISlider类似，既可以显示进度又可以改变进度
 */
@interface VOTCircleSlider : UIControl

@property (nullable, nonatomic, strong) UIColor *backgroundTintColor;   //圆环的背景色
@property (nullable, nonatomic, strong) UIColor *setTrackTintColor; //设置将要原地转向弧度的颜色
@property (nullable, nonatomic, strong) UIColor *downTrackTintColor; //已执行进度的颜色

@property (nonatomic, assign) CGFloat circleBorderWidth;    //圆的宽度
@property (nonatomic, assign) CGFloat circleRadius;        //圆形进度条的半径，一般比view的宽高中最小者还要小24

@property (nonatomic, assign) CGFloat thumbRadius;          //滑块正常的半径

@property (nonatomic, assign) float value;                  //slider当前的value
@property (nonatomic, assign) float loadProgress;           //slider加载的进度

@end
