//
//  ENDynamicListView.m
//  DynamicArrange
//
//  Created by ccpg_it on 17/2/15.
//  Copyright © 2017年 ccpg_it. All rights reserved.
//

#import "ENDynamicListView.h"
#import "ENDynamicButton.h"
#import "UIView+TPFrameExtension.h"


#define dynamicButtonTag  1000
@interface ENDynamicListView()<ENDynamicButtonDelegate>

@property (nonatomic , strong) NSArray *data;

@property (nonatomic , strong) NSMutableArray *buttonArray;


//添加拖动手势
@property (nonatomic , strong) UIPanGestureRecognizer *pan;

//添加长按手势
@property (nonatomic , strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic , assign) CGPoint oriCenter;

@property (nonatomic , assign) CGRect finalRect;

@property (nonatomic , assign) BOOL isEditting;

@property (nonatomic , strong) UIButton *finishButton;

@end

@implementation ENDynamicListView

- (instancetype)initWithDataArray:(NSArray *)dataArray{
    if (self = [super init]) {
        self.data = dataArray;
        [self setup];
    }
    return self;
}

- (void)setup{
    self.buttonArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.data.count; ++i) {
        
        ENDynamicButton *button = [ENDynamicButton dynamicButtonWithTitle:self.data[i]];
        
        //button.titleName = self.data[i];
        
        button.delegate = self;
        
        button.tag = dynamicButtonTag + i;
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handPan:)];
        
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [button addGestureRecognizer:_pan];
        [button addGestureRecognizer:_longPress];
        
        [self.buttonArray addObject:button];
        
        [self addSubview:button];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickFinish:) forControlEvents:UIControlEventTouchUpInside];
    self.finishButton = button;
    [self addSubview:button];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self updateButtonFrame];
    self.finishButton.frame = CGRectMake(self.width - 90, self.height - 30, 90, 30);
}
/*
 * 删除标签
 */
- (void)didClickDeleteButton:(ENDynamicButton *)dynamicButton{
    NSLog(@"delete");
    [dynamicButton removeFromSuperview];
    [self.buttonArray removeObject:dynamicButton];
    [self updateTag];
    [self updateButtonFrame];
}
/*
 * 点击标签
 */
- (void)didClickENDynamicButton:(ENDynamicButton *)dynamicButton{
    NSLog(@"click");

}

#pragma mark - event response

- (void)clickFinish:(UIButton *)sender{
    [self setButtonEditEnable:NO];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    NSLog(@"long--press");
    [self setButtonEditEnable:YES];
}

- (void)handPan:(UIPanGestureRecognizer *)pan{
    
    if (!self.isEditting) return;
    
    CGPoint point = [pan translationInView:self];
    
    //当前的按钮
    ENDynamicButton *curButton = (ENDynamicButton *)pan.view;

    //记录开始的原始位置
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.oriCenter = pan.view.center;
    }
    
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    
    //正在拖拽时
    if (pan.state == UIGestureRecognizerStateChanged) {
        //当前按钮的中心店在哪个按钮之上
        ENDynamicButton *coverredButton = [self getCoverredButton:curButton];
        
        //假如按钮不为空
        if (coverredButton) {
            //将插入的角标
            NSInteger insert_i = coverredButton.tag - dynamicButtonTag;
            //当前拖拽的角标
            //NSInteger cur_i = curButton.tag - dynamicButtonTag;
            
            //记录即将插入的位置
            _finalRect = coverredButton.frame;
            
            //更新按钮数组
            [self.buttonArray removeObject:curButton];
            [self.buttonArray insertObject:curButton atIndex:insert_i];
            
            //更新按钮的tag
            [self updateTag];
            
            //更新位置
            [UIView animateWithDuration:0.25 animations:^{
                [self updateButtonFrame];
            }];
            
        }
    }
    
    //当拖拽结束时
    if (pan.state == UIGestureRecognizerStateEnded) {
        //如果中心点位置过了被覆盖按钮的区域,那么就更新布局,未过就在原来的位置
        [UIView animateWithDuration:0.25 animations:^{
            if (_finalRect.size.width <= 0) {
                curButton.center = self.oriCenter;
            }else{
                curButton.frame = _finalRect;
            }
        } completion:^(BOOL finished) {
            _finalRect = CGRectZero;
        }];
    }
    
     [pan setTranslation:CGPointMake(0, 0) inView:self];
}

#pragma mark - private methods
/*
 * 开启编辑模式
 */
- (void)setButtonEditEnable:(BOOL)isEnable{
    self.isEditting = isEnable;
    for (ENDynamicButton *button in self.buttonArray) {
        button.deleteImageView.hidden = isEnable ? NO : YES;
    }
}

//更新按钮的布局

- (void)updateButtonFrame{
    CGFloat w = 90;
    CGFloat h = 40;
    NSInteger colCount = 3;
    CGFloat marginX = (self.width - colCount * w) / (colCount + 1);
    CGFloat marginY = 20;
    for (NSInteger i = 0; i < self.buttonArray.count; ++i) {
        
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        
        [self.buttonArray[i] setFrame:CGRectMake(marginX + col * (w + marginX), marginY + row * (marginY + h), w, h)];
        
    }
}


// 更新标签
- (void)updateTag
{
    NSInteger count = self.buttonArray.count;
    for (int i = 0; i < count; i++) {
        UIButton *tagButton = self.buttonArray[i];
        tagButton.tag = dynamicButtonTag + i;
    }
}


- (ENDynamicButton *)getCoverredButton:(ENDynamicButton *)curButton{
    for (ENDynamicButton *button in self.buttonArray) {
        if (button  == curButton) continue;
        if (CGRectContainsPoint(button.frame, curButton.center)) {
            return button;
        }
    }
    return nil;
}

#pragma mark - getter


@end
