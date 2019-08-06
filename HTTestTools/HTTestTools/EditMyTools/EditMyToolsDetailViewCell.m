//
//  EditMyToolsDetailViewCell.m
//  HTTestTools
//
//  Created by longfei on 2019/8/5.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import "EditMyToolsDetailViewCell.h"
#import "EditMyToolsCollectionViewCell.h"

static NSInteger ApplicationColumnNum = 5;

@interface  EditMyToolsDetailViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UIImageView *bgImageView;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation EditMyToolsDetailViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColor_f1f4f2;
        _dataSource = [[NSArray alloc] init];
        [self loadUI];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)loadUI{
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(20*kWidthScale);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EditMyToolsCollectionViewCell class]) forIndexPath:indexPath];
    EditMyToolsModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.editState = EditMyToolsCollectionViewCellEditStateDetail;
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = main_Width/ApplicationColumnNum-10*kWidthScale;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*kWidthScale;
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*kWidthScale;
    
}

#pragma mark - 自定义


#pragma mark - 懒加载
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage resizeImageWithName:@"home_bg_shadow"]];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        
        _titleLabel = [UILabel ht_labelWithText:@" " color:kBlackColor fontSize:kFontSize_36];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        // 设置布局信息
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.userInteractionEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        // 注册cell
        [_collectionView registerClass:[EditMyToolsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EditMyToolsCollectionViewCell class])];
    
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
