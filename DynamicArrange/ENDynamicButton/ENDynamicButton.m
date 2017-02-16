//
//  ENDynamicButton.m
//  DynamicArrange
//
//  Created by ccpg_it on 17/2/15.
//  Copyright © 2017年 ccpg_it. All rights reserved.
//

#import "ENDynamicButton.h"
#import "UIView+TPFrameExtension.h"

@interface ENDynamicButton()



@property (nonatomic , weak) UIImageView *iconView;

@property (nonatomic , weak) UILabel *titleLabel;

//添加点击手势

@property (nonatomic , strong) UITapGestureRecognizer *tap;

//添加删除点击手势
@property (nonatomic , strong) UITapGestureRecognizer *tapDelete;


@property (nonatomic , strong) NSMutableDictionary *dic;

@property (nonatomic , strong) NSString *titleName;

@end

@implementation ENDynamicButton

+ (instancetype)dynamicButtonWithTitle:(NSString *)titleName{
    return [[self alloc] initWithTitleName:titleName];
}

- (instancetype)initWithTitleName:(NSString *)titleName
{
    self = [super init];
    if (self) {
        self.titleName = titleName;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    [self addGestureRecognizer:self.tap];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = [UIColor purpleColor];
    iconView.userInteractionEnabled = YES;
    self.iconView = iconView;
    [self addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.titleName;
    titleLabel.font = [UIFont systemFontOfSize:9];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UIImageView *deleteImageView = [[UIImageView alloc] init];
    deleteImageView.backgroundColor = [UIColor redColor];
    deleteImageView.layer.cornerRadius = 5;
    deleteImageView.layer.masksToBounds = YES;
    deleteImageView.userInteractionEnabled = YES;
    [deleteImageView addGestureRecognizer:self.tapDelete];
    deleteImageView.hidden = YES;
    
    self.deleteImageView = deleteImageView;
    [self addSubview:deleteImageView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.deleteImageView.frame = CGRectMake(self.width - 10, 0, 10, 10);
    
    self.iconView.frame = CGRectMake(0, 0, self.width, self.height - 15);
    
    self.titleLabel.frame = CGRectMake(0, self.height - 15, self.width, 15);
}

#pragma mark - response event

- (void)tapIconView{
    if ([self.delegate respondsToSelector:@selector(didClickENDynamicButton:)]) {
        [self.delegate didClickENDynamicButton:self];
    }
}

- (void)tapDeleteImageView{
    if ([self.delegate respondsToSelector:@selector(didClickDeleteButton:)]) {
        [self.delegate didClickDeleteButton:self];
    }
}


#pragma mark - getter

- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconView)];
    }
    return _tap;
}

- (UITapGestureRecognizer *)tapDelete{
    if (!_tapDelete) {
        _tapDelete = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDeleteImageView)];
        
    }
    return _tapDelete;
}

- (NSDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

@end
