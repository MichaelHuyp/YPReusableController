//
//  YPStyleBar.h
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/29.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPReusableControllerConst.h"

@interface YPStyleBar : UIView

/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *items;

/** 文字内边距 */
@property (nonatomic, assign) CGFloat textInset;

/** 文字字体 */
@property (nonatomic, strong) UIFont *textFont;


@end
