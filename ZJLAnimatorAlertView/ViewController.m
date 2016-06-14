//
//  ViewController.m
//  ZJLAnimatorAlertView
//
//  Created by ZhongZhongzhong on 16/6/13.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ViewController.h"
#import "ZJLAlertView.h"

@interface ViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *snap;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showAlert:(id)sender {
    ZJLAlertView *alert = [[ZJLAlertView alloc]initWithTitle:@"This is an alert" message:@"Click ok to dismiss it" buttonTitle:@"OK"];
    [alert showAlertView];
//    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    test.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:test];
//    CGPoint temp = self.view.center;
//    self.snap = [[UISnapBehavior alloc] initWithItem:test snapToPoint:self.view.center];
//    [self.animator addBehavior:self.snap];
}

@end
