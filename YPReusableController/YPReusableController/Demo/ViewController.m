//
//  ViewController.m
//  YPReusableController
//
//  Created by MichaelPPP on 15/12/28.
//  Copyright (c) 2015年 tyiti. All rights reserved.
//

#import "ViewController.h"
#import "YPReusableController.h"
#import "TestViewControllerOne.h"
#import "TestViewControllerTwo.h"
#import "TestViewControllerThree.h"
#import "TestViewControllerFour.h"
#import "TestViewControllerFive.h"
#import "TestViewControllerSix.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestViewControllerOne *oneVc = [[TestViewControllerOne alloc] init];
    oneVc.yp_Title = @"要闻";
    TestViewControllerTwo *twoVc = [[TestViewControllerTwo alloc] init];
    twoVc.yp_Title = @"视频";
    TestViewControllerThree *threeVc = [[TestViewControllerThree alloc] init];
    threeVc.yp_Title = @"北京";
    TestViewControllerFour *fourVc = [[TestViewControllerFour alloc] init];
    fourVc.yp_Title = @"辽宁";
    TestViewControllerFive *fiveVc = [[TestViewControllerFive alloc] init];
    fiveVc.yp_Title = @"财经";
    TestViewControllerSix *sixVc = [[TestViewControllerSix alloc] init];
    sixVc.yp_Title = @"娱乐";
    TestViewControllerSix *sixVc1 = [[TestViewControllerSix alloc] init];
    sixVc1.yp_Title = @"娱乐";
    
    
    YPReusableController *resusableVc = [[YPReusableController alloc] initWithParentViewController:self];
    resusableVc.subViewControllers = @[oneVc,twoVc,threeVc,fourVc,fiveVc,sixVc];
}


@end








































