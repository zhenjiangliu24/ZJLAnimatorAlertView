//
//  ZJLAlertView.m
//  ZJLAnimatorAlertView
//
//  Created by ZhongZhongzhong on 16/6/13.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLAlertView.h"
static const CGFloat AlertViewWidth = 270.0f;
static const CGFloat AlertViewHeight = 100.0f;
static const CGFloat FontSize = 15.0f;

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ZJLAlertView()
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *message;
@property (nonatomic, readwrite, copy) NSString *buttonTitle;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation ZJLAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        _buttonTitle = buttonTitle;
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    self.backgroundView                 = [[UIView alloc] initWithFrame:keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f]; // Determined empirically
    self.backgroundView.alpha           = 0.0f;
    [self addSubview:self.backgroundView];
    self.frame = keyWindow.bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertViewWidth, AlertViewHeight)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 10.0f;
    self.alertView.layer.masksToBounds = YES;
    self.alertView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [self.alertView addSubview:[self titleLabel]];
    [self.alertView addSubview:[self messageLabel]];
    [self.alertView.layer addSublayer:[self subLayerLine]];
    [self.alertView addSubview:[self okButton]];
    [self addSubview:self.alertView];
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [keyWindow tintColorDidChange];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}

- (UILabel *)titleLabel
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]};
    CGSize expectedLabelSize = [self.title sizeWithAttributes:attributes];
    UILabel *label = [[UILabel alloc] init];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = self.title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake((AlertViewWidth-expectedLabelSize.width)/2, 10, expectedLabelSize.width, expectedLabelSize.height);
    [label sizeToFit];
    return label;
}

- (UILabel *)messageLabel
{
    CGRect lastFrame = [self lastAddedUIFrame];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]};
    CGSize expectedLabelSize = [self.message sizeWithAttributes:attributes];
    UILabel *label = [[UILabel alloc] init];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = self.message;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake((AlertViewWidth-expectedLabelSize.width)/2, lastFrame.origin.y+lastFrame.size.height, expectedLabelSize.width, expectedLabelSize.height);
    [label sizeToFit];
    return label;
}

- (UIButton *)okButton
{
    CGRect lastFrame = [self lastAddedUIFrame];
    UIButton *ok = [UIButton buttonWithType:UIButtonTypeSystem];
    [ok setTitle:self.buttonTitle forState:UIControlStateNormal];
    ok.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize];
    ok.backgroundColor = [UIColor whiteColor];
    ok.layer.cornerRadius = 10.0f;
    ok.frame = CGRectMake(0, lastFrame.origin.y+lastFrame.size.height+0.5, AlertViewWidth, (AlertViewHeight-lastFrame.origin.y-lastFrame.size.height));
    [ok addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    return ok;
}

- (CALayer *)subLayerLine
{
    CGRect lastFrame = [self lastAddedUIFrame];
    
    CGFloat posYLine = lastFrame.origin.y+lastFrame.size.height;
    if(!self.alertView){
        posYLine += 10;
    }
    
    CALayer *keylineLayer = [CALayer layer];
    keylineLayer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.29f] CGColor];
    keylineLayer.frame = CGRectMake(
                                    0,
                                    posYLine,
                                    AlertViewWidth,
                                    0.5f);
    
    return keylineLayer;
}

- (CGRect)lastAddedUIFrame
{
    CGRect frame;
    NSArray *subviews = [self.alertView subviews];
    if ([subviews count]>0) {
        UIView *lastView = [subviews objectAtIndex:(subviews.count-1)];
        frame = CGRectMake(lastView.frame.origin.x, lastView.frame.origin.y, lastView.frame.size.width, lastView.frame.size.height);
    }
    return frame;
}

- (void)dismissAlertView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.alertView]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertView]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.alertView];
    [self.animator addBehavior:itemBehaviour];
    
    // Animate out our background blind
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0.0f;
        keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        [keyWindow tintColorDidChange];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // Very important!
    }];
}

- (void)showAlertView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0.6f;
    }];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.alertView snapToPoint:CGPointMake(160, 284)];
    snap.damping = 0.65f;
    [self.animator addBehavior:snap];
    
}


@end
