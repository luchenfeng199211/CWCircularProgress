//
//  CWCircularProgressView.m
//  CWCircularProgress
//
//  Created by moonmark on 2017/8/12.
//  Copyright © 2017年 ChrisWei. All rights reserved.
//
//  
//

#import "CWCircularProgressView.h"

#define DEGRESS_TO_RADIANS(degrees)  ((M_PI * (degrees)) / 180)

#define CIRCULAR_DEFAULT_COLOR [UIColor colorWithRed:61/255.0 green:84/255.0 blue:125/255.0 alpha:1.0]
#define CIRCULAR_CONTENT_COLOR [UIColor colorWithRed:153/255.0 green:165/255.0 blue:186/255.0 alpha:1.0]

@interface CWCircularProgressView ()

@property (nonatomic, strong) CAShapeLayer *defaultLayer;
@property (nonatomic, strong) CAShapeLayer *contentLayer;
@property (nonatomic, strong) UILabel      *progressLabel;

//控件的属性
@property (assign, nonatomic) CGFloat BarRedius;
@property (assign, nonatomic) CGPoint BarCenter;

//circular的大小和之间的间隔
@property (assign, nonatomic) CGFloat circularRedius;
@property (assign, nonatomic) CGFloat angleDifference;

//设置开始的角度和弧形要的角度  0 ～360。
@property (assign, nonatomic) CGFloat barStartAngle;
@property (assign, nonatomic) CGFloat barLength;

@end

@implementation CWCircularProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultDatas];
    }
    return self;
}

- (void)initDefaultDatas
{
    self.defaultLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.defaultLayer];
    self.contentLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.contentLayer];
    
    self.BarRedius = 35;
    self.BarCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    self.circularRedius = 20.0;         //圆的大小
    self.angleDifference = 36.0;        //平均下来的角度
    
    self.barStartAngle = 265;
    self.barLength = 360;
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 - 30, self.frame.size.height/2.0 - 10, 60, 20)];
    self.progressLabel.text = @"100%";
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.progressLabel];
}

- (void)drawRectCircularProgress
{
    //计算出圆的周长
    CGFloat cangle = self.angleDifference;
    CGFloat total = 0;
    CGFloat num = 0;
    //NSLog(@"barLength = %f || barStartAngle = %f",self.barLength,self.barStartAngle);
    while (num < 10) {
        total = self.barStartAngle + cangle*num;
        CAShapeLayer *layer = [self circularLayerPathWithCAngle:total color:CIRCULAR_DEFAULT_COLOR];
        [self.defaultLayer addSublayer:layer];
        CAShapeLayer *progressColorLayer = [self circularLayerPathWithCAngle:total color:CIRCULAR_CONTENT_COLOR];
        [self.contentLayer addSublayer:progressColorLayer];
        num++;
    }
    
    self.contentLayer.mask = [self layerMaskWithStartAngle:self.barStartAngle - self.circularRedius/2.0 - 10 endAngle:self.barStartAngle + self.barLength - 20];
    self.progress = 0;
}

/*
 * 绘制小圆形
 * @param   startPoint：
 * @param   color:圆形的填充色
 */
- (CAShapeLayer *)circularLayerPathWithCAngle:(CGFloat)total color:(UIColor *)color
{
    //绘制想要形状的路径
    CGFloat a = self.BarCenter.x;
    CGFloat b = self.BarCenter.y;
    CGFloat x = self.BarRedius * cos(DEGRESS_TO_RADIANS(total)) + a;
    CGFloat y = self.BarRedius * sin(DEGRESS_TO_RADIANS(total)) + b;
    CGFloat radiiX = _circularRedius/2;
    CGFloat radiiY = _circularRedius/2;
    x = x-radiiX;
    y = y-radiiY;
    //NSLog(@"a == %f || b == %f || x == %f || y == %f || raiiX == %f || raiiY == %f",a,b,x,y,radiiX,radiiY);
    //绘制圆 参数 -> 范围：那几个角为圆角：圆的半径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, _circularRedius, _circularRedius) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radiiX, radiiY)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = color.CGColor;
    layer.lineWidth = 1;
    layer.path = path.CGPath;
    
    return layer;
}

/*绘制进度条*/
- (CAShapeLayer *)layerMaskWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    return [self shapeLayerWithStartAngle:startAngle endAngle:endAngle color:[UIColor blackColor]];
}

- (CAShapeLayer *)shapeLayerWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.BarCenter radius:self.BarRedius startAngle:DEGRESS_TO_RADIANS(startAngle) endAngle:DEGRESS_TO_RADIANS(endAngle) clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = self.circularRedius;
    layer.path = path.CGPath;
    
    return layer;
}

//set方法
- (void)setProgress:(CGFloat)progress
{
    if (progress > 1) progress = 1;
    if (progress < 0) progress = 0;
    _progress = progress;
    ((CAShapeLayer *)self.contentLayer.mask).strokeEnd = progress;//顺时针
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%",_progress * 100];
}

@end
