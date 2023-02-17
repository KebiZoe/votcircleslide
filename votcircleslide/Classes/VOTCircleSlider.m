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
@property (nonatomic, strong) UIImageView *degreeImgV;
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UILabel *showDegreeLbl;
@property (nonatomic, assign) CGPoint lastPoint;        //滑块的实时位置

@property (nonatomic, assign) CGFloat radius;           //半径
@property (nonatomic, assign) CGPoint drawCenter;       //绘制圆的圆心
@property (nonatomic, assign) CGPoint circleStartPoint; //thumb起始位置
@property (nonatomic, assign) CGFloat angle;            //转过的角度

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
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *path0 = [currentBundle pathForResource:@"ic_vot_thumb_default@3x.png" ofType:nil inDirectory:@"votcircleslide.bundle"];
    NSString *path1 = [currentBundle pathForResource:@"ic_vot_thumb_180D@3x.png" ofType:nil inDirectory:@"votcircleslide.bundle"];
    NSString *path2 = [currentBundle pathForResource:@"ic_vot_thumb_swipeLeft@3x.png" ofType:nil inDirectory:@"votcircleslide.bundle"];
    NSString *path3 = [currentBundle pathForResource:@"ic_vot_thumb_swipeRight@3x.png" ofType:nil inDirectory:@"votcircleslide.bundle"];
    NSString *path4 = [currentBundle pathForResource:@"ic_vot_thumb_goal@3x.png" ofType:nil inDirectory:@"votcircleslide.bundle"];
    
    _thumbDefaultImage = [UIImage imageWithContentsOfFile:path0];
    _thumb180DImage = [UIImage imageWithContentsOfFile:path1];
    _thumbswipeLeftImage = [UIImage imageWithContentsOfFile:path2];
    _thumbswipeRightImage = [UIImage imageWithContentsOfFile:path3];
    _thumbsGoalImage = [UIImage imageWithContentsOfFile:path4];
    
    self.circleRadius = MIN(self.frame.size.width, self.frame.size.height)/2 - 40;
    self.circleBorderWidth = 10.0f;
    self.thumbRadius = 24.0f;
    self.downTrackTintColor = [UIColor colorWithRed:69/255.0 green:130/255.0 blue:230/255.0 alpha:255/255.0];
    self.setTrackTintColor = [UIColor colorWithRed:0.30 green:0.33 blue:0.38 alpha:1.00];
    self.backgroundTintColor = [UIColor colorWithRed:0.88 green:0.89 blue:0.90 alpha:1.00];
    
    self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    self.loadProgress = 0.0;
    self.angle = 0;
    
    self.degreeImgV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.degreeImgV.image = [self drawLineOfDashByImageView:self.degreeImgV];
    [self addSubview:self.degreeImgV];
    
    self.thumbView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.thumbView];
    [self addSubview:self.showDegreeLbl];
    [self addObserver:self forKeyPath:@"userInteractionEnabled" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    BOOL interaction = [change valueForKey:@"new"];
    if (interaction == NO) {
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
    _loadProgress = loadProgress;
    [self setNeedsDisplay];
}

- (void)setThumbRadius:(CGFloat)thumbRadius {
    _thumbRadius = thumbRadius;
    self.thumbView.frame = CGRectMake(0, 0, thumbRadius * 2, thumbRadius * 2);
    self.thumbView.layer.cornerRadius = thumbRadius;

    [self setNeedsDisplay];
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
    self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    self.radius = self.circleRadius;
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //圆形的背景颜色
    CGContextSetStrokeColorWithColor(ctx, self.backgroundTintColor.CGColor);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextAddArc(ctx, self.drawCenter.x, self.drawCenter.y, self.radius, 0, 2 * M_PI, 0);
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
                          radius:self.radius
                      startAngle:originstart
                        endAngle:currentOrigin
                       clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextSetStrokeColorWithColor(ctx, self.setTrackTintColor.CGColor);
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    //加载的进度
    UIBezierPath *loadPath = [UIBezierPath bezierPath];
    CGFloat loadStart = -M_PI_2;
    CGFloat loadCurre = loadStart + 2 * M_PI * self.loadProgress;
    if (_value<0){
        loadStart = -M_PI_2 - 2 * M_PI * self.loadProgress;
        loadCurre = -M_PI_2;
    }
    [loadPath addArcWithCenter:self.drawCenter
                        radius:self.radius
                    startAngle:loadStart
                      endAngle:loadCurre
                     clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextSetStrokeColorWithColor(ctx, self.downTrackTintColor.CGColor);
    CGContextAddPath(ctx, loadPath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    // 关闭图像
    CGContextClosePath(ctx);
    /*
     * 计算移动点的位置
     * alpha = 移动点相对于起始点顺时针扫过的角度(弧度)
     * x = r * sin(alpha) + 圆心的x坐标, sin在0-PI之间为正，PI-2*PI之间为负
     * y 可以通过-r * cos(alpha) + 圆心的y坐标来计算。
     */
    double alpha = self.value * 2 * M_PI;
    double x = self.radius * sin(alpha) + self.drawCenter.x;
    double y = -self.radius * cos(alpha) + self.drawCenter.y;
    self.lastPoint = CGPointMake(x, y);
    self.thumbView.center = self.lastPoint;
    self.thumbView.transform = CGAffineTransformIdentity;
    self.thumbView.transform = CGAffineTransformMakeRotation(self.value*M_PI*2);
}
- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);

    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    // 虚线刻度半径
    CGFloat degreeRadius = imageView.frame.size.width/2-31;
    UIColor *degreeColor =  [UIColor colorWithRed:133/255.0 green:174/255.0 blue:255/255.0 alpha:255/255.0];
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 绘制三角形
    CGFloat dx = imageView.center.x - degreeRadius*sin(M_PI_4*8/9);
    CGFloat d2x = imageView.center.x + degreeRadius*sin(M_PI_4*8/9);
    CGFloat dy = imageView.center.y - degreeRadius*cos(M_PI_4*8/9);
    CGFloat ddx = imageView.center.x - degreeRadius*sin(M_PI_4*7/9);
    CGFloat dd2x = imageView.center.x + degreeRadius*sin(M_PI_4*7/9);
    CGFloat ddy = imageView.center.y - degreeRadius*cos(M_PI_4*7/9);
    CGContextSetFillColorWithColor(line, degreeColor.CGColor);
    // 绘制左边
    CGContextMoveToPoint(line, dx, dy);
    // 设置第二个点
    CGContextAddLineToPoint(line, ddx, ddy);
    // 设置第三个点
    CGContextAddLineToPoint(line, (ddx+dx)/2, ddy-6);
    // 关闭起点和终点
    CGContextClosePath(line);
    // 3.渲染图形到layer上
    CGContextFillPath(line);
    // 绘制右边边
    CGContextMoveToPoint(line, d2x, dy);
    // 设置第二个点
    CGContextAddLineToPoint(line, dd2x, ddy);
    // 设置第三个点
    CGContextAddLineToPoint(line, (dd2x+d2x)/2, ddy-6);
    // 关闭起点和终点
    CGContextClosePath(line);
    // 3.渲染图形到layer上
    CGContextFillPath(line);
    
    // 开始绘制虚线
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    CGContextSetLineDash(line, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(line, degreeColor.CGColor);
    
    UIBezierPath *loadPath = [UIBezierPath bezierPath];
    CGFloat start = -M_PI_2-M_PI_4*8/9;
    CGFloat end = -M_PI_2+M_PI_4*8/9;
    [loadPath addArcWithCenter:self.drawCenter
                        radius:degreeRadius
                    startAngle:start
                      endAngle:end
                     clockwise:YES];
    
    CGContextAddPath(line, loadPath.CGPath);
    CGContextDrawPath(line, kCGPathStroke);
    
    
    for (int i=0; i<55; i++) {
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        CGFloat originstart = -M_PI_2+M_PI_4+M_PI_4*i/9;
        [circlePath addArcWithCenter:self.drawCenter
                              radius:degreeRadius
                          startAngle:originstart
                            endAngle:originstart+0.005
                           clockwise:YES];
        CGContextSaveGState(line);
        if ((i%9)==0){
            CGContextSetLineWidth(line, 8);
        }else{
            CGContextSetLineWidth(line, 4);
        }
        
        CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
        CGContextAddPath(line, circlePath.CGPath);
        CGContextDrawPath(line, kCGPathStroke);
    }
    
    NSString *d0=@"0°";
    [d0 drawAtPoint:CGPointMake(imageView.frame.size.width/2-6, 8) withAttributes:@{NSForegroundColorAttributeName: UIColor.grayColor,NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
    NSString *d1=@"90°";
    [d1 drawAtPoint:CGPointMake(imageView.frame.size.width-26, imageView.frame.size.height/2-10) withAttributes:@{NSForegroundColorAttributeName: UIColor.grayColor,NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    NSString *d2=@"180°";
    [d2 drawAtPoint:CGPointMake(imageView.frame.size.width/2-15, imageView.frame.size.height-26) withAttributes:@{NSForegroundColorAttributeName: UIColor.grayColor,NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    NSString *d3=@"90°";
    [d3 drawAtPoint:CGPointMake(0, imageView.frame.size.height/2-10) withAttributes:@{NSForegroundColorAttributeName: UIColor.grayColor,NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    return UIGraphicsGetImageFromCurrentImageContext();
}
#pragma mark - UIControl methods

//点击开始
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint starTouchPoint = [touch locationInView:self];

    //如果点击点和上一次点击点的距离大于20，不做操作。
    double touchDist = [VOTCircleSlider distanceBetweenPointA:starTouchPoint pointB:self.lastPoint];
    if (touchDist > 20) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        return YES;
    }
    //如果点击点和圆心的距离大于20，不做操作。
    //以上两步是用来限定滑块的点击范围，距离滑块太远不操作，距离圆心太远或太近不操作
    double dist = [VOTCircleSlider distanceBetweenPointA:starTouchPoint pointB:self.drawCenter];
    if (fabs(dist - self.radius) > 20) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        return YES;
    }
    self.thumbView.center = self.lastPoint;
    
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
     self.thumbView.center = self.lastPoint;
    
    CGPoint starTouchPoint = [touch locationInView:self];
    
    double touchDist = [VOTCircleSlider distanceBetweenPointA:starTouchPoint pointB:self.lastPoint];
    if (touchDist > 20) {
        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
        return;
    }
    double dist = [VOTCircleSlider distanceBetweenPointA:starTouchPoint pointB:self.drawCenter];
    if (fabs(dist - self.radius) > 20) {
        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
        return;
    }
    [self moveHandlerWithPoint:starTouchPoint];
    
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - Handle move

- (void)moveHandlerWithPoint:(CGPoint)point {
    CGFloat centerX = self.drawCenter.x;
    CGFloat centerY = self.drawCenter.y;
    
    CGFloat moveX = point.x;
    CGFloat moveY = point.y;
    
    double dist = sqrt(pow((moveX - centerY), 2) + pow(moveY - centerY, 2));
    /*
     * 计算移动点的坐标
     * sinAlpha = 亮点在x轴上投影的长度 ／ 距离
     * xT = r * sin(alpha) + 圆心的x坐标
     * yT 算法同上
     */
    double sinAlpha = (moveX - centerX) / dist;
    double xT = self.radius * sinAlpha + centerX;
    double yT = sqrt((self.radius * self.radius - (xT - centerX) * (xT - centerX))) + centerY;
    if (moveY < centerY) {
        yT = centerY - fabs(yT - centerY);
    }
    double LL = self.radius + 35;
    double xL = LL * sinAlpha + centerX;
    double yL = sqrt((LL * LL - (xL - centerX) * (xL - centerX))) + centerY;
    if (moveY < centerY) {
        yL = centerY - fabs(yL - centerY);
    }
    
    self.lastPoint = self.thumbView.center = CGPointMake(xT, yT);
    
    
    CGFloat angle = [VOTCircleSlider calculateAngleWithRadius:self.radius
                                                     center:self.drawCenter
                                                startCenter:self.circleStartPoint
                                                  endCenter:self.lastPoint];
    
    self.showDegreeLbl.text = [NSString stringWithFormat:@"%.0f°",angle<0?-angle:angle];
    [self.showDegreeLbl sizeToFit];
    CGSize size = self.showDegreeLbl.frame.size;
    self.showDegreeLbl.frame = CGRectMake(self.showDegreeLbl.frame.origin.x, self.showDegreeLbl.frame.origin.y, size.width+10, size.height);
    
    self.showDegreeLbl.center = CGPointMake(xL, yL);
    self.angle = angle;
    
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
    self.value = angle / 360;
    
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
@end
