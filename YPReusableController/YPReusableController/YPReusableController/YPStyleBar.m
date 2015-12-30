//
//  YPStyleBar.m
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/29.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "YPStyleBar.h"

@implementation YPStyleBar


#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self prepare];
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        self.yp_width = newSuperview.yp_width;
        self.yp_left = 0;
        self.yp_height = 44;
    }
}

#pragma mark - Private
- (void)prepare
{
    self.backgroundColor = [UIColor clearColor];
}

@end
