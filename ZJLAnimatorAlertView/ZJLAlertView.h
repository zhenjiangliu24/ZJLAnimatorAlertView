//
//  ZJLAlertView.h
//  ZJLAnimatorAlertView
//
//  Created by ZhongZhongzhong on 16/6/13.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJLAlertView : UIView
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, readonly, copy) NSString *buttonTitle;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
- (void)showAlertView;
- (void)dismissAlertView;
@end
