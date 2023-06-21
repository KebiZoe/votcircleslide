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

@property (nonatomic, assign) CGFloat circleBorderWidth;    //圆环的宽度
@property (nonatomic, assign, readonly) CGFloat circleRadius;        //圆形进度条的半径，默认比view的宽高中最小者还要小48,为了在圆外显示刻度

@property (nonatomic, assign) CGFloat thumbRadius;          //滑块正常的半径
/// value = angle / 360;  -maxRotationAngle <= value <= maxRotationAngle;
///maxRotationAngle = 180度时 value的值在-0.5-0.5之间，负数为逆时针
/// value的值的范围取决于maxRotationAngle
@property (nonatomic, assign) float value;                  //slider当前的value
/// 设置旋转角度时的精度，默认为10度。四舍五入原则。
@property(nonatomic, assign) CGFloat precision;
/// loadProgress的在0-1之间，加载到1是位置和设定位置一样
@property (nonatomic, assign) float loadProgress;           //slider加载的进度
/// 最大旋转角度，默认180度
@property (nonatomic, assign) float maxRotationAngle;
/// 可否可以在切换旋转方向，默认可以(严格的方向 rigidDirection = NO)；
/// 如果不是180度，页同意支持，切换的角度变为360-maxRotationAngle
@property (nonatomic, assign) BOOL rigidDirection;
/// 友情提示，当选择到最大位置时继续旋转则给出提示
@property(nonatomic, copy, nullable) void (^BlockTips)(NSString* _Nonnull);
- (void)resumeAnimation:(BOOL) anima;
/// 吸附到最近精度值位置
- (void)adsorbedToTheNearestscale;
@end
