//
//  VOTCircleSlider.h
//  votcircleslide
//
//  Created by s.zengxiangxian@byd.com  on 15/02/2023.
//  Copyright © 2023 BYD. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef kScreenWidth
/// 屏幕宽度
#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif
#ifndef kAutoSize
///ui给的效果图是以375屏幕宽度为标准给的
#define kUIStandardScreenWidth 375.0
#define kAutoSize(size)  size * (kScreenWidth / kUIStandardScreenWidth)
#endif
/**
 * 圆环形滑块，和UISlider类似，既可以显示进度又可以改变进度
 */
@interface VOTCircleSlider : UIControl

@property (nullable, nonatomic, strong) UIColor *backgroundTintColor;   //圆环的背景色
@property (nullable, nonatomic, strong) UIColor *setTrackTintColor; //设置将要原地转向弧度的颜色
@property (nullable, nonatomic, strong) UIColor *downTrackTintColor; //已执行进度的颜色

@property (nonatomic, assign) CGFloat circleBorderWidth;    //圆的宽度
@property (nonatomic, assign, readonly) CGFloat circleRadius;        //圆形进度条的半径，默认比view的宽高中最小者还要小48,为了在圆外显示刻度

@property (nonatomic, assign) CGFloat thumbRadius;          //滑块正常的半径
///value的值在-0.5-0.5之间，负数为逆时针
@property (nonatomic, assign) float value;                  //slider当前的value
/// loadProgress的在0-1之间，加载到1是位置和设定位置一样
@property (nonatomic, assign) float loadProgress;           //slider加载的进度
- (void)resumeAnimation:(BOOL) anima;
@end
