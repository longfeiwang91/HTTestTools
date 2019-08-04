//
//  EditMyToolsHeaerView.m
//  HTTestTools
//
//  Created by longfei on 2019/8/2.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import "EditMyToolsHeaderView.h"
#import "EditMyToolsModel.h"
#import "EditMyToolsCollectionViewCell.h"


static NSInteger ApplicationColumnNum = 5;

static CGFloat ApplicationSectionHeight = 10;

@interface EditMyToolsHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) UILabel *leftTitleLabel;

@property(nonatomic, strong) UILabel *leftInfoLabel;

@property(nonatomic, strong) UILabel *rightInfoLabel;

@property(nonatomic, strong) UILabel *footLabel;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;
@property (nonatomic, weak) UIView *tempMoveCell;
@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation EditMyToolsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _dataArray = [[NSMutableArray alloc] init];
        NSArray *array = @[];
        NSArray *imgArray = @[];
        for (NSUInteger i=0; i<array.count; i++)
        {
 
                EditMyToolsModel *model = [[EditMyToolsModel alloc] init];
                model.title = array[i];
                model.imageStr = imgArray[i];
                
                model.row = i;
                model.section = 0;
            
            [_dataArray addObject:model];
        }
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 设置界面
- (void)setupUI {
    
    self.isEditing = NO;
    
    [self addSubview:self.leftTitleLabel];
    [self addSubview:self.leftInfoLabel];
    [self addSubview:self.rightInfoLabel];
    [self addSubview:self.collectionView];
    
    [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20*kWidthScale);
    }];
    
    [_leftInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTitleLabel.mas_right).offset(10*kWidthScale);
        make.bottom.mas_equalTo(self.leftTitleLabel);
    }];
    
    [_rightInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20*kWidthScale);
        make.top.mas_equalTo(20*kWidthScale);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.leftTitleLabel.mas_bottom);
        CGFloat height = (main_Width-20*kWidthScale)/ApplicationColumnNum-10*kWidthScale;
        make.height.mas_equalTo((height +10*kWidthScale)*2);
    }];
    
    [self addSubview:self.footLabel];
    [_footLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10*kWidthScale);
        make.bottom.mas_equalTo(self);
    }];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMoving:)];
    _longPress.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:_longPress];
}

#pragma mark - event
// 长按应用进入编辑状态，可以进行移动删除操作
- (void)longPressMoving:(UILongPressGestureRecognizer *)longPress {
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.originalIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            NSLog(@"UIGestureRecognizerStateBegan : %ld,%ld",self.originalIndexPath.section,self.originalIndexPath.row);
            
            if (self.originalIndexPath.section == 0) {
                
                
                //获取到手指所在cell
                EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.originalIndexPath];
                UIImage *image = [self captureImageFromViewLow:cell];
                UIImageView * captureImageView = [[UIImageView alloc] initWithImage:image];
                
                self.tempMoveCell = captureImageView;
                CGRect frame = [self convertRect:cell.frame fromView:self.collectionView];
                self.tempMoveCell.frame = frame;
                cell.hidden = YES;
                [self addSubview:self.tempMoveCell];
                self.lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            NSLog(@"UIGestureRecognizerStateChanged : %ld,%ld",indexPath.section,indexPath.row);
            CGFloat tranX = [longPress locationOfTouch:0 inView:longPress.view].x - self.lastPoint.x;
            CGFloat tranY = [longPress locationOfTouch:0 inView:longPress.view].y - self.lastPoint.y;
            self.tempMoveCell.center = CGPointApplyAffineTransform(self.tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
            self.lastPoint = [longPress locationOfTouch:0 inView:longPress.view];

            [self moveCell];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            
            EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.originalIndexPath];
            
            cell.hidden = NO;
            cell.alpha = 0.0;
            
//            [UIView animateWithDuration:0.001 animations:^{
                self.tempMoveCell.center = cell.center;
                self.tempMoveCell.alpha = 0.0;
                cell.alpha = 1.0;
                
//            } completion:^(BOOL finished) {
                [self.tempMoveCell removeFromSuperview];
                self.originalIndexPath = nil;
                self.tempMoveCell = nil;
                self.collectionView.userInteractionEnabled = YES;
                
//            }];
        }
            break;
        default:
            break;
    }
}

- (void)moveCell{
    for (EditMyToolsCollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        if (indexPath == self.originalIndexPath || indexPath.section != 0) {
            continue;
        }
        NSLog(@"moveCell : %ld,%ld",indexPath.section,indexPath.row);
        //计算中心距
        
        CGRect frame = [self convertRect:self.tempMoveCell.frame toView:self.collectionView];
        CGFloat centerX = (CGRectGetMinX(frame)+ CGRectGetMaxX(frame))/2.0;
        CGFloat centerY = (CGRectGetMinY(frame) + CGRectGetMaxY(frame))/2.0;
        CGFloat spacingX = fabs(centerX - cell.center.x);
        CGFloat spacingY = fabs(centerY - cell.center.y);
        if (spacingX <= frame.size.width / 2.0f && spacingY <= frame.size.height / 2.0f) {
            self.moveIndexPath = [self.collectionView indexPathForCell:cell];
            if (self.moveIndexPath.row <  self.dataArray.count) {
                [self reArrangApplication];
                //移动
                [self.collectionView moveItemAtIndexPath:self.originalIndexPath toIndexPath:self.moveIndexPath];
                //设置移动后的起始indexPath
                self.originalIndexPath = self.moveIndexPath;
            }
            
            break;
        }
    }
    
}


- (CGRect)getFrame{
    
    EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count inSection:0]];
    
    CGRect frame = [self.collectionView convertRect:cell.frame toView:[UIApplication sharedApplication].delegate.window];
    return frame;
}

-(UIImage *)captureImageFromViewLow:(UIView *)orgView {
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(orgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [orgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//更新数据源
- (void)reArrangApplication{
    NSMutableArray *tempApplicationArray = [[NSMutableArray alloc] init];
    [tempApplicationArray addObjectsFromArray:self.dataArray];
    if (self.moveIndexPath.item > self.originalIndexPath.item) {
        for (NSUInteger i = self.originalIndexPath.item; i < self.moveIndexPath.item ; i ++) {
            [tempApplicationArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
        }
    }else{
        for (NSUInteger i = self.originalIndexPath.item; i > self.moveIndexPath.item ; i --) {
            [tempApplicationArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
        }
    }
    self.dataArray = tempApplicationArray.mutableCopy;

    
}

#pragma  mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EditMyToolsCollectionViewCell class]) forIndexPath:indexPath];
    
    EditMyToolsModel * model;
    if (self.dataArray.count >0 && indexPath.row <= self.dataArray.count-1) {
        model = self.dataArray[indexPath.row];
    }else{
        model = [[EditMyToolsModel alloc] init];
    }
    
    model.isFirstSection = YES;
    cell.model = model;
    
    cell.buttonClickBlock = ^(EditMyToolsModel *model){
        
        if (model.title.length == 0) {
            return ;
        }
        
        NSUInteger row = [self.dataArray indexOfObject:model];
        
        EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        
        UIImage *image = [self captureImageFromViewLow:cell];
        UIImageView * captureImageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect frame = [self.collectionView convertRect:cell.frame toView:[UIApplication sharedApplication].delegate.window];
        captureImageView.frame = frame;
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(editMyToolsHeaderView:deleteCellWithImageView:frame:index:)]) {
            [self.delegate editMyToolsHeaderView:self deleteCellWithImageView:captureImageView frame:frame index:row];
        }
    };
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (main_Width-20*kWidthScale)/ApplicationColumnNum-10*kWidthScale;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10*kWidthScale, 10*kWidthScale, 10*kWidthScale,10*kWidthScale);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*kWidthScale;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*kWidthScale;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
{
    return CGSizeMake(main_Width, ApplicationSectionHeight);
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        // 设置布局信息
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.scrollEnabled = NO;
        // 注册cell
        [_collectionView registerClass:[EditMyToolsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EditMyToolsCollectionViewCell class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UILabel *)leftTitleLabel {
    
    if (_leftTitleLabel == nil) {
        
        _leftTitleLabel = [UILabel ht_labelWithText:@"首页工具" color:kBlackColor fontSize:36*kWidthScale];
        _leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftTitleLabel;
}

- (UILabel *)leftInfoLabel {
    
    if (_leftInfoLabel == nil) {
        
        _leftInfoLabel = [UILabel ht_labelWithText:@"(按住拖动调整排序)" color:[UIColor grayColor] fontSize:16*kWidthScale];
        _leftInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftInfoLabel;
}

- (UILabel *)rightInfoLabel {
    
    if (_rightInfoLabel == nil) {
        
        _rightInfoLabel = [UILabel ht_labelWithText:@"恢复默认" color:[UIColor greenColor] fontSize:16*kWidthScale];
        _rightInfoLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightInfoLabel;
}

- (UILabel *)footLabel {
    
    if (_footLabel == nil) {
        
        _footLabel = [UILabel ht_labelWithText:@"家园共育" color:kBlackColor fontSize:36*kWidthScale];
        _footLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _footLabel;
}

@end
