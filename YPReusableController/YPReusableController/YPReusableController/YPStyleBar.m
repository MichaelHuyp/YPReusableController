//
//  YPStyleBar.m
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/29.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "YPStyleBar.h"
#import "YPStyleBtn.h"

@interface YPStyleBar()

/** 左侧按钮 */
@property (nonatomic, weak) UIButton *leftBtn;
/** 右侧按钮 */
@property (nonatomic, weak) UIButton *rightBtn;
/** 所有的选项标题都在这个ScrollView上 */
@property (nonatomic, weak) UIScrollView *itemContainerView;

@end

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
        self.yp_height = YPStyleBarHeight;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.itemContainerView.frame = CGRectMake(0, 20, self.yp_right, 44);
    
    self.leftBtn.frame = CGRectMake(0, 20, 44, 44);
    self.rightBtn.frame = CGRectMake(self.yp_right - 44, 20, 44, 44);
    
    for (UIView *view in self.itemContainerView.subviews) {
        if ([view isKindOfClass:[YPStyleBtn class]]) {
            view.yp_height = view.superview.yp_height;
        }
    }
}

#pragma mark - Private
- (void)prepare
{
    // self
    self.backgroundColor = [UIColor clearColor];
    // 初始化内边距为10
    _textInset = 10.0f;
    // 初始化文字字体
    _textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    // container
    UIScrollView *itemContainerView = [[UIScrollView alloc] init];
    self.itemContainerView = itemContainerView;
    [self addSubview:itemContainerView];
    itemContainerView.showsHorizontalScrollIndicator = NO;
    itemContainerView.showsVerticalScrollIndicator = NO;
    itemContainerView.backgroundColor = YPYellowColor;
    
    // leftBtn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn = leftBtn;
    [self addSubview:leftBtn];
    leftBtn.hidden = NO;
    [leftBtn addTarget:self action:@selector(leftBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.backgroundColor = YPWhiteColor;
    
    // rightBtn
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightBtn;
    [self addSubview:rightBtn];
    rightBtn.hidden = NO;
    [rightBtn addTarget:self action:@selector(rightBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.backgroundColor = YPWhiteColor;
}

/**
 *  根据标题文字数组得到按钮宽度数组
 *
 *  @param titles 文字数组
 *
 *  @return 按钮宽度数组
 */
- (NSArray *)getBtnWidthArrWithTitles:(NSArray *)titles
{
    NSMutableArray *widths = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (NSString *title in titles) {
        CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = _textFont;
        size = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        NSNumber *width = [NSNumber numberWithFloat:size.width + 2 * _textInset];
        [widths addObject:width];
    }
    return widths;
}

/**
 *  放置按钮方法
 *
 *  @param widths 装有按钮宽度的数组
 *
 *  @return 返回总长度
 */
- (CGFloat)setUpBtnWithBtnWidthArr:(NSArray *)widths
{
    CGFloat buttonX = 0.0f;
    CGFloat totalWidth = 0.0f;
    
    for (NSUInteger index = 0; index < widths.count; index++)
    {
        YPStyleBtn *styleBtn = [YPStyleBtn styleBtn];
        [self.itemContainerView addSubview:styleBtn];
        styleBtn.frame = CGRectMake(44 + buttonX, 0, [widths[index] floatValue], styleBtn.superview.yp_height);
        [styleBtn setTitle:_items[index] forState:UIControlStateNormal];
        [styleBtn addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        styleBtn.titleLabel.font = _textFont;
        
        buttonX += [widths[index] floatValue];
        
        if (index == widths.count - 1) {
            totalWidth = styleBtn.yp_right;
        }
    }
    
    return totalWidth;
}

/**
 *  刷新数据源
 */
- (void)reloadData
{
    // 先移除容器上得所有按钮
    for (UIView *view in self.itemContainerView.subviews) {
        if ([view isKindOfClass:[YPStyleBtn class]]) {
            [view removeFromSuperview];
        }
    }
    
    // 按钮宽度数组
    NSArray *widths = [self getBtnWidthArrWithTitles:[_items copy]];
    
    // 放置按钮
    CGFloat totalWidth = [self setUpBtnWithBtnWidthArr:widths];
    
    // 设置容器scrollView的contentSize
    self.itemContainerView.contentSize = CGSizeMake(totalWidth, 0);
}

- (void)leftBtnTouch
{
    YPLog(@"左侧按钮被点击");
}

- (void)rightBtnTouch
{
    YPLog(@"右侧按钮被点击");
}

- (void)itemPressed:(UIButton *)button
{
    YPLog(@"中间按钮被点击拉");
}

#pragma mark - setter
- (void)setItems:(NSMutableArray *)items
{
    if (!items || items.count == 0 || [_items isEqualToArray:items]) return;
    
    _items = items;
    
    // 刷新数据源
    [self reloadData];
}

- (void)setTextInset:(CGFloat)textInset
{
    _textInset = textInset;
    
    // 刷新数据源
    [self reloadData];
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    // 刷新数据源
    [self reloadData];
}

@end































