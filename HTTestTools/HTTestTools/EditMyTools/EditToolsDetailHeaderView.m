//
//  EditToolsDetailHeaderView.m
//  HTTestTools
//
//  Created by longfei on 2019/8/5.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import "EditToolsDetailHeaderView.h"

static NSInteger ApplicationColumnNum = 9;

@interface EditToolsDetailHeaderView ()

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;

@property(nonatomic, strong) UIButton *editBtn;

@end

@implementation EditToolsDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor_f1f4f2;
        [self loadUI];
    }
    return self;
}

#pragma mark - 设置界面
-(void)loadUI{
    UIView *bgView = [UIView ht_viewWithBackgroundColor:kWhiteColor];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(200*kWidthScale);
    }];
    
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20*kWidthScale);
    }];
    
    CGFloat width = (main_Width-20*2*kWidthScale +10*kWidthScale)/9-10*kWidthScale;
    for (int i=0; i<ApplicationColumnNum; i++) {
        UIImageView *imageView = self.imageViewArray[i];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*kWidthScale +width*i +10*kWidthScale*i);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
    
    [self addSubview:self.editBtn];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(bgView.mas_bottom);
        make.width.mas_equalTo(320*kWidthScale);
        make.height.mas_equalTo(80*kWidthScale);
    }];
}

-(void)buttonClick{
    if (self.buttonClickBlock) {
        self.buttonClickBlock();
    }
}

#pragma mark - 懒加载
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        
        _titleLabel = [UILabel ht_labelWithText:@"首页工具" color:kBlackColor fontSize:36*kWidthScale];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(NSMutableArray *)imageViewArray{
    if (!_imageViewArray) {
        _imageViewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<ApplicationColumnNum; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_inform_manage"]];
            [_imageViewArray addObject:imageView];
        }
    }
    return _imageViewArray;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.adjustsImageWhenHighlighted = NO;
        [_editBtn setTitle:@"编　辑" forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_28];
        _editBtn.backgroundColor = kThemeColor;
        _editBtn.layer.cornerRadius = 5*kWidthScale;
        _editBtn.layer.masksToBounds = YES;
        [_editBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

@end
