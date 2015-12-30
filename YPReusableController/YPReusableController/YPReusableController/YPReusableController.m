//
//  YPReusableController.m
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/28.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "YPReusableController.h"
#import <objc/runtime.h>
#import "YPStyleBar.h"
#import "YPContainerView.h"

@interface UIViewController ()

@property (nonatomic, strong, readwrite) YPReusableController *reusableController;

@end

@interface YPReusableController ()

@property (nonatomic, weak) YPStyleBar *bar;

@property (nonatomic, weak) YPContainerView *containerView;

@end

@implementation YPReusableController

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  监听屏幕旋转的方法
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    self.bar.yp_width = width;
    self.containerView.yp_width = width;
    self.containerView.yp_height = height - self.bar.yp_bottom;
}

#pragma mark - Public
- (instancetype)initWithParentViewController:(UIViewController *)parentViewController
{
    self = [super init];
    if (!self) return nil;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    parentViewController.reusableController = self;
    parentViewController.automaticallyAdjustsScrollViewInsets = NO;
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    
    
    // bar
    YPStyleBar *bar = [[YPStyleBar alloc] init];
    self.bar = bar;
    bar.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:bar];
    
    // containerView
    YPContainerView *containerView = [[YPContainerView alloc] init];
    self.containerView = containerView;
    containerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:containerView];
    
    containerView.yp_y = bar.yp_bottom;
    containerView.yp_height = YPScreenH - bar.yp_bottom;
    

    
    return self;
}


#pragma mark - setter
- (void)setSubViewControllers:(NSArray *)subViewControllers
{
    // nil || 数组元素个数为0 || 旧数组与新数组相等 return;
    if (!subViewControllers || subViewControllers.count == 0 || [_subViewControllers isEqualToArray:subViewControllers]) return;
    
    // 保存
    _subViewControllers = subViewControllers;
    
    
    // 取出subViewController数组内所有控制器的标题
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    for (UIViewController *vc in _subViewControllers) {
        [titles addObject:vc.yp_Title];
    }
    
}

@end

@implementation UIViewController (YPReusableControllerExtension)

// 关联
YPSYNTH_DYNAMIC_PROPERTY_OBJECT(yp_Title, setYp_Title, COPY_NONATOMIC, NSString *);

YPSYNTH_DYNAMIC_PROPERTY_OBJECT(reusableController, setReusableController, RETAIN_NONATOMIC, YPReusableController *);

@end



































