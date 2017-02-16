//
//  ENDynamicButton.h
//  DynamicArrange
//
//  Created by ccpg_it on 17/2/15.
//  Copyright © 2017年 ccpg_it. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ENDynamicButton;
@protocol ENDynamicButtonDelegate <NSObject>

- (void)didClickENDynamicButton:(ENDynamicButton *)dynamicButton;

- (void)didClickDeleteButton:(ENDynamicButton *)dynamicButton;


@end

@interface ENDynamicButton : UIView
+ (instancetype)dynamicButtonWithTitle:(NSString *)titleName;

@property (nonatomic , weak) id<ENDynamicButtonDelegate> delegate;

@property (nonatomic , assign) CGPoint point;

@property (nonatomic , weak) UIImageView *deleteImageView;

@end
