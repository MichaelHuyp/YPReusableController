//
//  YPReusableController.h
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/28.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPReusableControllerConst.h"

@interface YPReusableController : UIViewController

/** 子控制器 */
@property (nonatomic, strong) NSArray *subViewControllers;

/** 构造方法 */
- (instancetype)initWithParentViewController:(UIViewController *)parentViewController;

@end

@interface UIViewController(YPReusableControllerExtension)

@property (nonatomic, copy) NSString *yp_Title;

@property (nonatomic, strong, readonly) YPReusableController *reusableController;

@end