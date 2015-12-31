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
/** 横线指示条 */
@property (nonatomic, weak) UIView *ellipseIndicateView;
/** 保存所有Item文字高度的数组 */
@property (nonatomic, strong) NSMutableArray *allItemTextHeightArr;

@end

@implementation YPStyleBar

#pragma mark - Lazy

- (NSMutableArray *)allItemTextHeightArr
{
    if (!_allItemTextHeightArr) {
        _allItemTextHeightArr = [NSMutableArray array];
    }
    return _allItemTextHeightArr;
}

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
    
    self.ellipseIndicateView.yp_centerY = self.itemContainerView.yp_height * 0.5 - 2.0f;
    
    self.leftBtn.frame = CGRectMake(0, 20, YPStyleBarLeftOrRightBtnWH, YPStyleBarLeftOrRightBtnWH);
    self.rightBtn.frame = CGRectMake(self.yp_right - YPStyleBarLeftOrRightBtnWH, 20, YPStyleBarLeftOrRightBtnWH, YPStyleBarLeftOrRightBtnWH);
    
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
    _textFont = [UIFont fontWithName:@"DIN Condensed" size:18];
    // 初始化文字普通状态时的颜色
    _textColor_normal = [UIColor grayColor];
    
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
        NSNumber *height = [NSNumber numberWithFloat:size.height];
        [widths addObject:width];
        [self.allItemTextHeightArr addObject:height];
    }
    
    
    return widths;
}

/**
 *  放置按钮方法
 *
 *  @param widths 装有按钮宽度的数组
 *
 *  @return 返回总长度(作为scrollView的contentsize)
 */
- (CGFloat)setUpBtnWithBtnWidthArr:(NSArray *)widths andBtnHeightArr:(NSArray *)heights
{
    CGFloat buttonX = 0.0f;
    CGFloat totalWidth = 0.0f;
    
    for (NSUInteger index = 0; index < widths.count; index++)
    {
        YPStyleBtn *styleBtn = [YPStyleBtn styleBtn];
        [self.itemContainerView addSubview:styleBtn];
        styleBtn.frame = CGRectMake(YPStyleBarLeftOrRightBtnWH + buttonX, 0, [widths[index] floatValue], styleBtn.superview.yp_height);
        [styleBtn setTitle:_items[index] forState:UIControlStateNormal];
        [styleBtn addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        styleBtn.titleLabel.font = _textFont;
        [styleBtn setTitleColor:_textColor_normal forState:UIControlStateNormal];
        
        buttonX += [widths[index] floatValue];
        
        if (index == widths.count - 1) {
            totalWidth = styleBtn.yp_right;
        }
    }
    
    // 显示圆圈指示条
    [self showEllipseIndicateViewWithButtonWidth:[widths[0] floatValue] andHeight:[heights[0] floatValue]];
    
    return totalWidth + YPStyleBarLeftOrRightBtnWH;
}

/**
 *  显示圆圈指示条
 *
 *  @param width 给定的指示条宽度
 */
- (void)showEllipseIndicateViewWithButtonWidth:(CGFloat)width andHeight:(CGFloat)height
{
    // container.subview -> indicateView
    UIView *ellipseIndicateView = [[UIView alloc] init];
    self.ellipseIndicateView = ellipseIndicateView;
    [self.itemContainerView addSubview:ellipseIndicateView];
    ellipseIndicateView.layer.cornerRadius = 10;
    ellipseIndicateView.backgroundColor = YPColor_RGBA(200, 200, 200, 0.3);
    ellipseIndicateView.hidden = NO;
    
    
    self.ellipseIndicateView.yp_x = YPStyleBarLeftOrRightBtnWH + 2.0f;
    self.ellipseIndicateView.yp_width = width - 4.0f;
    self.ellipseIndicateView.yp_height = height + YPPadding;
}

/**
 *  刷新数据源
 */
- (void)reloadData
{
    // 清空旧数据
    [self.allItemTextHeightArr removeAllObjects];
    [self.itemContainerView removeAllSubviews];
    
    // 按钮宽度数组
    NSArray *widths = [self getBtnWidthArrWithTitles:[_items copy]];
    NSArray *heights = [self.allItemTextHeightArr copy];
    
    // 放置按钮
    CGFloat totalWidth = [self setUpBtnWithBtnWidthArr:widths andBtnHeightArr:heights];
    
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

- (void)setTextColor_normal:(UIColor *)textColor_normal
{
    _textColor_normal = textColor_normal;
    
    // 刷新数据源
    [self reloadData];
}

@end


























