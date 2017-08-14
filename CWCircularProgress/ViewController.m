//
//  ViewController.m
//  CWCircularProgress
//
//  Created by moonmark on 2017/8/12.
//  Copyright © 2017年 ChrisWei. All rights reserved.
//

#import "ViewController.h"

#import "CWCircularProgressView.h"

@interface ViewController ()
{
    CWCircularProgressView *_circularProgressView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[self colorWithHex:0x00111a].CGColor, (__bridge id)[self colorWithHex:0x002b59].CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.layer addSublayer:gradientLayer];
    
    CGFloat curWidth = self.view.bounds.size.width/4.0;
    _circularProgressView = [[CWCircularProgressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 - curWidth/2.0, self.view.frame.size.height/2.0 - curWidth/2.0 + 80, curWidth, curWidth)];
    _circularProgressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_circularProgressView];
    [_circularProgressView drawRectCircularProgress];
    
    UISlider *sw = [[UISlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height - 60, 200, 50)];
    [self.view addSubview:sw];
    [sw addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)changeValue:(UISlider *)slider {
    _circularProgressView.progress = slider.value;
}

- (UIColor*) colorWithHex:(long)hexColor;
{
    return [self colorWithHex:hexColor alpha:1.0];
}

- (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
