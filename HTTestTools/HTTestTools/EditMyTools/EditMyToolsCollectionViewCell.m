//
//  EditMyToolsCollectionViewCell.m
//  HTTestTools
//
//  Created by longfei on 2019/8/1.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import "EditMyToolsCollectionViewCell.h"

#import "EditMyToolsModel.h"

@interface EditMyToolsCollectionViewCell ()

@property (nonatomic, strong)  UIImageView *imageView;
@property (nonatomic, strong)  UILabel *titlelabel;
@property (nonatomic, strong)  UIButton *editButton;

@end

@implementation EditMyToolsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        [self loadUI];
        
    }
    return self;
}

-(void)loadUI{
    [self addSubview:self.imageView];
    [self addSubview:self.titlelabel];
    [self addSubview:self.editButton];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(5*kWidthScale);
        make.right.mas_equalTo(self).offset(-5*kWidthScale);
        make.bottom.mas_equalTo(self).offset(-5*kWidthScale);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.titlelabel);
        make.bottom.mas_equalTo(self.titlelabel.mas_top).offset(5*kWidthScale);
    }];
    
}

-(void)setModel:(EditMyToolsModel *)model{
    _model = model;
    _titlelabel.text = model.title;
    _imageView.image = [UIImage imageNamed:model.imageStr];
    
    if (model.imageStr.length == 0) {
        _imageView.hidden = YES;
    }else{
        _imageView.hidden = NO;
    }
    
    if (model.title.length == 0) {
        _titlelabel.hidden = YES;
        _editButton.hidden = YES;
    }else{
        _titlelabel.hidden = NO;
        _editButton.hidden = NO;
    }
    
    if (model.isFirstSection) {
        [_editButton setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    }else{
        [_editButton setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
        
    }
    
    if (!model.isFirstSection && [model.title isEqualToString:@""] && [model.imageStr isEqualToString:@""]) {
        self.layer.borderWidth = 0;
    }else{
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
    }
}

-(void)buttonClick:(UIButton *)sender{
    if (_buttonClickBlock) {
        _buttonClickBlock(_model);
    }
}

- (UIImageView *)imageView {
    
    if (_imageView == nil) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"icon_bus_manage"];
    }
    return _imageView;
}

- (UILabel *)titlelabel {
    
    if (_titlelabel == nil) {
        
        _titlelabel = [UILabel ht_labelWithText:@"" color:kBlackColor fontSize:18*kWidthScale];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}

- (UIButton *)editButton{
    if (!_editButton) {
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.adjustsImageWhenHighlighted = NO;
        [_editButton setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

@end
