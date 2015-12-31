//
//  YPStyleBar.h
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/29.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPReusableControllerConst.h"
@class YPStyleBar;

@protocol YPStyleBarDelegate <NSObject>

@optional
/** 当选项被选择时候的回调代理方法 */
- (void)itemDidSelectedWithIndex:(YPStyleBar *)navTabBar index:(NSUInteger)index;

@end

@interface YPStyleBar : UIView

@property (nonatomic, assign) id<YPStyleBarDelegate> myDelegate;

/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *items;

/** 文字内边距 */
@property (nonatomic, assign) CGFloat textInset;

/** 文字字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 文字普通状态下的颜色 */
@property (nonatomic, strong) UIColor *textColor_normal;


@end
