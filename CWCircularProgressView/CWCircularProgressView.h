//
//  CWCircularProgressView.h
//  CWCircularProgress
//
//  Created by moonmark on 2017/8/12.
//  Copyright © 2017年 ChrisWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWCircularProgressView : UIView


@property (assign, nonatomic) CGFloat progress;                   //进度

@property (strong, nonatomic) UIColor *circularNormalColor;       //圆圈的背景色
@property (strong, nonatomic) UIColor *circularProgressColor;     //根据进度条填充圆圈的颜色

- (void)drawRectCircularProgress;

@end
