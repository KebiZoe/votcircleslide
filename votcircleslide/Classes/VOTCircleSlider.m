//
//  VOTCircleSlider.m
//  votcircleslide
//
//  Created by by s.zengxiangxian@byd.com  on 15/02/2023.
//  Copyright © 2023 BYD. All rights reserved.
//

#import "VOTCircleSlider.h"

@interface VOTCircleSlider()
{
    UIImage* _thumbDefaultImage;    // 滑块初始图片
    UIImage* _thumb180DImage;    // 滑块初始图片
    UIImage* _thumbswipeLeftImage;   // 滑块左滑图片
    UIImage* _thumbswipeRightImage;   // 滑块右滑图片
    UIImage* _thumbsGoalImage;   // 滑块定位图片
}
/// 左右拖拽提示图片
@property(nonatomic, strong) UIImageView *arrowimgV;
/// 刻度图片
@property (nonatomic, strong) UIImageView *degreeImgV;
/// 滑块图片
@property (nonatomic, strong) UIImageView *thumbView;
/// 实车图片
@property(nonatomic, strong) UIImageView *carImgV;
/// 目标角度车图片
@property(nonatomic, strong) UIImageView *virtualCarImgV;
/// 当前滑块选择的度数
@property (nonatomic, strong) UILabel *showDegreeLbl;
/// 滑块的实时位置
@property (nonatomic, assign) CGPoint lastPoint;
/// 绘制圆的圆心
@property (nonatomic, assign) CGPoint drawCenter;
/// thumb起始位置
@property (nonatomic, assign) CGPoint circleStartPoint;
/// 滑块转过的角度
@property (nonatomic, assign) CGFloat angle;

@end

@implementation VOTCircleSlider

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"userInteractionEnabled"];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 设定默认值
 */
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _thumbDefaultImage = UIImageLoadWithName(@"ic_vot_thumb_default");
    _thumb180DImage = UIImageLoadWithName(@"ic_vot_thumb_180D");
    _thumbswipeLeftImage = UIImageLoadWithName(@"ic_vot_thumb_swipeLeft");
    _thumbswipeRightImage = UIImageLoadWithName(@"ic_vot_thumb_swipeRight");
    _thumbsGoalImage = UIImageLoadWithName(@"ic_vot_thumb_goal");
    
    self.circleRadius = MIN(self.frame.size.width, self.frame.size.height)/2 - kAutoSize(48);
    self.circleBorderWidth = kAutoSize(10);
    self.thumbRadius = kAutoSize(15);
    self.downTrackTintColor = [UIColor colorWithRed:69/255.0 green:130/255.0 blue:230/255.0 alpha:255/255.0];
    self.setTrackTintColor = [UIColor colorWithRed:0.30 green:0.33 blue:0.38 alpha:1.00];
    self.backgroundTintColor = [UIColor colorWithRed:0.88 green:0.89 blue:0.90 alpha:1.00];
    
    self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    self.loadProgress = 0.0;
    self.angle = 0;
    self.precision = 10;
    self.degreeImgV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.degreeImgV.image = [self drawLineOfDashByImageView:self.degreeImgV];
    [self addSubview:self.degreeImgV];
    
    CGFloat standardRadius = kScreenWidth/2-kAutoSize(61);
    CGFloat scale = self.circleRadius/standardRadius;
    self.arrowimgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-kAutoSize(191)*scale/2, self.frame.size.height/2-self.circleRadius-kAutoSize(10), kAutoSize(191)*scale, kAutoSize(43)*scale)];
    self.arrowimgV.image = UIImageLoadWithName(@"ic_vot_arrow");
    self.arrowimgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.arrowimgV];
    
    self.virtualCarImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.drawCenter.x-kAutoSize(81)*scale/2, self.drawCenter.y-kAutoSize(183)*scale/2, kAutoSize(81)*scale, kAutoSize(183)*scale)];
    self.virtualCarImgV.image = UIImageLoadWithName(@"ic_vot_virtualcar");
    self.virtualCarImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.virtualCarImgV];
    
    self.carImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.drawCenter.x-kAutoSize(113)*scale/2, self.drawCenter.y-kAutoSize(215)*scale/2, kAutoSize(113)*scale, kAutoSize(215)*scale)];
    self.carImgV.image = UIImageLoadWithName(@"ic_vot_car");
    self.carImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.carImgV];
    
    self.thumbView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.thumbView];
    [self addSubview:self.showDegreeLbl];
    [self addObserver:self forKeyPath:@"userInteractionEnabled" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)resumeAnimation:(BOOL) anima{
    CGFloat aniAngle;
    // 如果是180度的时候动画的方向是不能确定的，必须小于180度是才能确定动画方向
    if (self.loadProgress*self.value==0.5){
        aniAngle = 2 * M_PI * 0.499;
    }else if (self.loadProgress*self.value==-0.5){
        aniAngle = -2 * M_PI * 0.499;
    }else{
        aniAngle = 2 * M_PI * self.loadProgress * self.value;
    }
    
    self.angle = 0;
    self.value = 0;
    self.loadProgress = 0;
    
    if (anima == YES){
        self.transform = CGAffineTransformMakeRotation(aniAngle);
        self.thumbView.hidden = YES;
        self.showDegreeLbl.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.thumbView.hidden = NO;
            self.showDegreeLbl.hidden = NO;
        }];
    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    int interaction = [[change valueForKey:@"new"] intValue];
    if (interaction == 0) {
        self.thumbView.image = _thumbsGoalImage;
    }else{
        if(self.angle<0){
            self.thumbView.image = _thumbswipeLeftImage;
        }else if(self.angle == 0){
            self.thumbView.image = _thumbDefaultImage;
        }else if (self.angle >0&&self.angle<179){
            self.thumbView.image = _thumbswipeRightImage;
        }else{
            self.thumbView.image = _thumb180DImage;
        }
    }
}
#pragma mark - getter
- (UIImageView *)degreeImgV {
    if (!_degreeImgV) {
        _degreeImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _degreeImgV;
}

- (UIImageView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _thumbView.image = _thumbDefaultImage;
    }
    return _thumbView;
}
- (UILabel *)showDegreeLbl{
    if(!_showDegreeLbl){
        _showDegreeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _showDegreeLbl.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        _showDegreeLbl.font = [UIFont systemFontOfSize:16];
        _showDegreeLbl.textColor = UIColor.whiteColor;
        _showDegreeLbl.layer.cornerRadius = 9.5;
        _showDegreeLbl.textAlignment = NSTextAlignmentCenter;
        _showDegreeLbl.layer.masksToBounds = YES;
    }
    return _showDegreeLbl;
}

#pragma mark - setter
- (void)setValue:(float)value {
    _value = value;
    [self setNeedsDisplay];
}

- (void)setLoadProgress:(float)loadProgress {
    _loadProgress = ABS(loadProgress);
    [self setNeedsDisplay];
}

- (void)setThumbRadius:(CGFloat)thumbRadius {
    _thumbRadius = thumbRadius;
    self.thumbView.frame = CGRectMake(0, 0, thumbRadius * 2, thumbRadius * 2);
    self.thumbView.layer.cornerRadius = thumbRadius;
}

- (void)setCircleRadius:(CGFloat)circleRadius {
    _circleRadius = circleRadius;
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    [self setNeedsDisplay];
}

- (void)setCircleBorderWidth:(CGFloat)circleBorderWidth {
    _circleBorderWidth = circleBorderWidth;
    [self setNeedsDisplay];
}

- (void)setsetTrackTintColor:(UIColor *)setTrackTintColor {
    _setTrackTintColor = setTrackTintColor;
    [self setNeedsDisplay];
}

- (void)setdownTrackTintColor:(UIColor *)downTrackTintColor {
    _downTrackTintColor = downTrackTintColor;
    [self setNeedsDisplay];
}

#pragma mark - drwRect

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //圆形的背景颜色
    CGContextSetStrokeColorWithColor(ctx, self.backgroundTintColor.CGColor);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextAddArc(ctx, self.drawCenter.x, self.drawCenter.y, self.circleRadius, 0, 2 * M_PI, 0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //value
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat originstart = -M_PI_2;
    CGFloat currentOrigin = originstart + 2 * M_PI * self.value;
    if (_value<0){
        originstart = -M_PI_2 + 2 * M_PI * self.value;
        currentOrigin = -M_PI_2;
    }
    [circlePath addArcWithCenter:self.drawCenter
                          radius:self.circleRadius
                      startAngle:originstart
                        endAngle:currentOrigin
                       clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextSetStrokeColorWithColor(ctx, self.setTrackTintColor.CGColor);
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    //加载的进度
    UIBezierPath *loadPath = [UIBezierPath bezierPath];
    CGFloat loadStart = -M_PI_2;
    CGFloat loadpg = self.loadProgress * _value * 2 * M_PI;
    CGFloat loadCurre = loadStart + loadpg;
    if (_value<0){
        loadStart = -M_PI_2 + loadpg;
        loadCurre = -M_PI_2;
    }
    [loadPath addArcWithCenter:self.drawCenter
                        radius:self.circleRadius
                    startAngle:loadStart
                      endAngle:loadCurre
                     clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, self.downTrackTintColor.CGColor);
    CGContextAddPath(ctx, loadPath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    /*
     * 计算移动点的位置
     * alpha = 移动点相对于起始点顺时针扫过的角度(弧度)
     * x = r * sin(alpha) + 圆心的x坐标, sin在0-PI之间为正，PI-2*PI之间为负
     * y 可以通过-r * cos(alpha) + 圆心的y坐标来计算。
     */
    
    double alpha = self.value * 2 * M_PI;
    self.angle = self.value * 360;
    if(self.angle<-179.5){
        self.thumbView.image = _thumb180DImage;
    }else if(self.angle <= -0.5){
        self.thumbView.image = _thumbswipeLeftImage;
    }else if(self.angle > -0.5&&self.angle < 0.5){
        self.thumbView.image = _thumbDefaultImage;
    }else if (self.angle >=0.5&&self.angle<179.5){
        self.thumbView.image = _thumbswipeRightImage;
    }else{
        self.thumbView.image = _thumb180DImage;
    }
    double x = self.circleRadius * sin(alpha) + self.drawCenter.x;
    double y = -self.circleRadius * cos(alpha) + self.drawCenter.y;
    self.lastPoint = CGPointMake(x, y);
    self.thumbView.center = self.lastPoint;
    self.thumbView.transform = CGAffineTransformIdentity;
    self.thumbView.transform = CGAffineTransformMakeRotation(self.value*M_PI*2);
    self.virtualCarImgV.transform = CGAffineTransformIdentity;
    self.virtualCarImgV.transform = CGAffineTransformMakeRotation(self.value*M_PI*2);
    
    self.carImgV.transform = CGAffineTransformIdentity;
    self.carImgV.transform = CGAffineTransformMakeRotation(loadpg);
    
    double LL = self.circleRadius + kAutoSize(35);
    double xL = LL * sin(alpha) + self.drawCenter.x;
    double yL = -(LL-kAutoSize(10)) * cos(alpha) + self.drawCenter.y;
    self.showDegreeLbl.text = [NSString stringWithFormat:@"%.0f°",ABS(self.value*360)];
    [self.showDegreeLbl sizeToFit];
    CGSize size = self.showDegreeLbl.frame.size;
    self.showDegreeLbl.frame = CGRectMake(self.showDegreeLbl.frame.origin.x, self.showDegreeLbl.frame.origin.y, size.width+10, size.height);
    
    self.showDegreeLbl.center = CGPointMake(xL, yL);
}

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);

    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    // 虚线刻度半径
    CGFloat degreeRadius = imageView.frame.size.width/2-kAutoSize(38);
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    for (int i=0; i<55; i++) {
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        CGFloat originstart = -M_PI_2+M_PI_4+M_PI_4*i/9;
        if ((i%9)==0){
            [circlePath addArcWithCenter:self.drawCenter
                                  radius:degreeRadius
                              startAngle:originstart
                                endAngle:originstart+0.005
                               clockwise:YES];
            CGContextSaveGState(line);
            CGContextSetLineWidth(line, 10);
        }else{
            [circlePath addArcWithCenter:self.drawCenter
                                  radius:degreeRadius-3
                              startAngle:originstart
                                endAngle:originstart+0.005
                               clockwise:YES];
            CGContextSaveGState(line);
            CGContextSetLineWidth(line, 4);
        }
        
        CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
        CGContextAddPath(line, circlePath.CGPath);
        CGContextDrawPath(line, kCGPathStroke);
    }
    
    NSString *d0=@"0°";
    [d0 drawAtPoint:CGPointMake(imageView.frame.size.width/2-6, self.drawCenter.y-degreeRadius-kAutoSize(30)) withAttributes:@{NSForegroundColorAttributeName:  [UIColor colorWithRed:21/255.0 green:22/255.0 blue:26/255.0 alpha:255/255.0],NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
    NSString *d1=@"90°";
    [d1 drawAtPoint:CGPointMake(imageView.frame.size.width-26, imageView.frame.size.height/2-10) withAttributes:@{NSForegroundColorAttributeName:  [UIColor colorWithRed:21/255.0 green:22/255.0 blue:26/255.0 alpha:255/255.0],NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    NSString *d2=@"180°";
    [d2 drawAtPoint:CGPointMake(imageView.frame.size.width/2-15, self.drawCenter.y+degreeRadius+kAutoSize(10)) withAttributes:@{NSForegroundColorAttributeName:   [UIColor colorWithRed:21/255.0 green:22/255.0 blue:26/255.0 alpha:255/255.0],NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    NSString *d3=@"90°";
    [d3 drawAtPoint:CGPointMake(0, imageView.frame.size.height/2-10) withAttributes:@{NSForegroundColorAttributeName:  [UIColor colorWithRed:21/255.0 green:22/255.0 blue:26/255.0 alpha:255/255.0],NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    return UIGraphicsGetImageFromCurrentImageContext();
}
#pragma mark - UIControl methods

//点击开始
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint starTouchPoint = [touch locationInView:self];

    //如果点击点和上一次点击点的距离大于20，不做操作。
//    double touchDist = [VOTCircleSlider distanceBetweenPointA:starTouchPoint pointB:self.lastPoint];
//    if (touchDist > 20) {
//        return NO;
//    }
    [self moveHandlerWithPoint:starTouchPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

//拖动过程中
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint starTouchPoint = [touch locationInView:self];
    [self moveHandlerWithPoint:starTouchPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

//拖动结束
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    CGPoint starTouchPoint = [touch locationInView:self];
    
    [self moveHandlerWithPoint:starTouchPoint];
    [self adsorbedToTheNearestscale];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - Handle move

- (void)moveHandlerWithPoint:(CGPoint)point {
    CGFloat centerX = self.drawCenter.x;
    CGFloat centerY = self.drawCenter.y;
    
    CGFloat moveX = point.x;
    CGFloat moveY = point.y;
    
    double dist = sqrt(pow((moveX - centerX), 2) + pow(moveY - centerY, 2));
    /*
     * 计算移动点的坐标
     * sinAlpha = 亮点在x轴上投影的长度 ／ 距离
     * xT = r * sin(alpha) + 圆心的x坐标
     * yT 算法同上
     */
    double sinAlpha = (moveX - centerX) / dist;
    double xT = self.circleRadius * sinAlpha + centerX;
    double yT = sqrt(fabs((self.circleRadius * self.circleRadius - (xT - centerX) * (xT - centerX)))) + centerY;
    if (moveY < centerY) {
        yT = centerY - fabs(yT - centerY);
    }
    self.lastPoint = CGPointMake(xT, yT);
    
    CGFloat angle = [VOTCircleSlider calculateAngleWithRadius:self.circleRadius
                                                     center:self.drawCenter
                                                startCenter:self.circleStartPoint
                                                  endCenter:self.lastPoint];
    self.angle = angle;
    
    self.value = angle / 360;
}
// 吸附到最近精度值
- (void)adsorbedToTheNearestscale {
    if (self.precision < 1){
        return;
    }
    self.angle = floor((self.angle + 0.5 * self.precision) / self.precision) * self.precision;
    self.value = self.angle/360;
    
    double alpha = _value * 2 * M_PI;
    double x = self.circleRadius * sin(alpha) + self.drawCenter.x;
    double y = -self.circleRadius * cos(alpha) + self.drawCenter.y;
    
    self.lastPoint = CGPointMake(x, y);
    
    double LL = self.circleRadius + kAutoSize(35);
    double xL = LL * sin(alpha) + self.drawCenter.x;
    double yL = -(LL-kAutoSize(10)) * cos(alpha) + self.drawCenter.y;
    
    self.showDegreeLbl.text = [NSString stringWithFormat:@"%.0f°",ABS(self.value*360)];
    CGSize size = [self.showDegreeLbl sizeThatFits:CGSizeMake(200, 30)];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.thumbView.center = self.lastPoint;
        self.thumbView.transform = CGAffineTransformMakeRotation(self.value*M_PI*2);
        self.virtualCarImgV.transform = CGAffineTransformMakeRotation(self.value*M_PI*2);
        self.showDegreeLbl.frame = CGRectMake(self.showDegreeLbl.frame.origin.x, self.showDegreeLbl.frame.origin.y, size.width+10, size.height);
        self.showDegreeLbl.center = CGPointMake(xL, yL);
    }];
}
#pragma mark - Util

/**
 计算圆上两点间的角度

 @param radius 半径
 @param center 圆心
 @param startCenter 起始点坐标
 @param endCenter 结束点坐标
 @return 圆上两点间的角度
 */
+ (CGFloat)calculateAngleWithRadius:(CGFloat)radius
                             center:(CGPoint)center
                        startCenter:(CGPoint)startCenter
                          endCenter:(CGPoint)endCenter {
    //a^2 = b^2 + c^2 - 2bccosA;
    CGFloat cosA = (2 * radius * radius - powf([VOTCircleSlider distanceBetweenPointA:startCenter pointB:endCenter], 2)) / (2 * radius * radius);
    CGFloat angle = 180 / M_PI * acosf(cosA);
    
    if (startCenter.x > endCenter.x) {
        angle = - angle;
    }
    return angle;
}

/**
 两点间的距离

 @param pointA 点A的坐标
 @param pointB 点B的坐标
 @return 两点间的距离
 */
+ (double)distanceBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    double x = fabs(pointA.x - pointB.x);
    double y = fabs(pointA.y - pointB.y);
    return hypot(x, y);//hypot(x, y)函数为计算三角形的斜边长度
}

/// 图片加载
/// @param name 本地图片名字 eg: UIImageLoadWithName()
/// @return 图片
UIImage* UIImageLoadWithName(NSString *name){
    NSString *directory = @"votcircleslide.bundle";
    NSBundle *currentBundle = [NSBundle bundleForClass:[VOTCircleSlider class]];
    UIImage* img = [UIImage imageWithContentsOfFile:[currentBundle pathForResource:[NSString stringWithFormat:@"%@@3x.png",name] ofType:nil inDirectory:directory]];
    return img;
}
@end
