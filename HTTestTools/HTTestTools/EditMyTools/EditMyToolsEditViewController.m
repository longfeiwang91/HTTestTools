//
//  RootViewController.m
//  HTTestTools
//
//  Created by longfei on 2019/7/30.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import "EditMyToolsEditViewController.h"
#import "EditMyToolsModel.h"
#import "EditMyToolsCollectionViewCell.h"
#import "EditMyToolsCollectionReusableView.h"

#import "EditMyToolsHeaderView.h"

#import "EditMyToolsModel.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define KWidth  [[UIScreen mainScreen] bounds].size.width

static NSInteger ApplicationColumnNum = 5;

static CGFloat ApplicationSectionHeight = 20;

@interface EditMyToolsEditViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,EditMyToolsHeaderViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataSourceArray;

@property(nonatomic, strong) NSMutableArray * tempDataSourceArray;

@property(nonatomic, strong) NSMutableArray *myApplicationTitleArray;

@property(nonatomic, weak) EditMyToolsHeaderView *headerView;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isEditing;

@property(nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton * finishBtn;

@end

@implementation EditMyToolsEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    [self loadNavigation];
}

#pragma mark - CommonInit
// 设置UI界面
- (void)setupUI{
    
    self.isEditing = NO;
    
    [self.view addSubview:self.collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}
- (void)loadNavigation
{
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.title = @"编辑我的工具";
    
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
    self.navigationItem.leftBarButtonItems = @[cancleItem];
    
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc]initWithCustomView:self.finishBtn];
    self.navigationItem.rightBarButtonItems = @[finishItem];
    
    
    
}

#pragma mark - editMyToolsHeaderViewDelegate
-(void)editMyToolsHeaderView:(EditMyToolsHeaderView *)headerView deleteCellWithImageView:(UIImageView *)imageView frame:(CGRect)frame index:(NSUInteger)index
{
    [self.view addSubview:imageView];
    
    EditMyToolsModel *model = [headerView.dataArray objectAtIndex:index];
    
    int row = 0,section = 0;
    
    for (int i = 0; i<self.dataSourceArray.count; i++) {
        
        NSArray *tempArr = self.dataSourceArray[i];
        
        for (int j = 0; j<tempArr.count; j++) {
            EditMyToolsModel *toolModel = tempArr[j];
            if ([model.title isEqualToString:toolModel.title]) {
                
                row = j;
                section = i;
                break;
            }
        }
    }
    
    NSMutableArray *secArray = [self.tempDataSourceArray[section] mutableCopy];
    NSUInteger insertRow = 0;
    
    int count = 0;
    for (int i=0; i<secArray.count; i++) {
        EditMyToolsModel *toolModel = secArray[i];
        if (toolModel.row>row) {
            insertRow = i;
            break;
        }
        count ++;
    }
    
    if (count == secArray.count) {
        insertRow = secArray.count;
    }
    
    EditMyToolsModel *insertModel = [[EditMyToolsModel alloc] init];
    insertModel.title = @"";
    insertModel.imageStr = @"";
    
    NSMutableArray *tempArray = [self.tempDataSourceArray[section] mutableCopy];
    [tempArray insertObject:insertModel atIndex:insertRow];
    
    [self.tempDataSourceArray replaceObjectAtIndex:section withObject:tempArray];
    
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:insertRow inSection:section]]];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.headerView.dataArray removeObjectAtIndex:index];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.headerView.collectionView reloadData];
        });
        
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:insertRow inSection:section];
        
        EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:lastIndex];
        
        imageView.frame = [self.collectionView convertRect:cell.frame toView:[UIApplication sharedApplication].delegate.window];

    } completion:^(BOOL finished) {

        
        EditMyToolsModel *inModel = self.dataSourceArray[section][row];
        
        NSMutableArray *temArray = [self.tempDataSourceArray[section] mutableCopy];
        [temArray replaceObjectAtIndex:insertRow withObject:inModel];
        
        [self.tempDataSourceArray replaceObjectAtIndex:section withObject:temArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            [self.collectionView reloadData];
            
            [imageView removeFromSuperview];
        });
        
        

    }];
    

}

#pragma mark -  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.tempDataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray * array = self.tempDataSourceArray[section];
    return array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 0)
    {
        EditMyToolsHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EditMyToolsHeaderView class]) forIndexPath:indexPath];
        header.delegate = self;
        _headerView = header;
        return header;
    }else if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        EditMyToolsCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EditMyToolsCollectionReusableView class]) forIndexPath:indexPath];
        header.label.text = self.myApplicationTitleArray[indexPath.section];
        
        return header;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EditMyToolsCollectionViewCell class]) forIndexPath:indexPath];
EditMyToolsModel *model = self.tempDataSourceArray[indexPath.section][indexPath.row];
    model.isFirstSection = NO;
    cell.model = model;
    cell.editState = EditMyToolsCollectionViewCellEditStateEdit;
    
    cell.buttonClickBlock =^(EditMyToolsModel *model){
        
        if (self.headerView.dataArray.count >8) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多选择9个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
        
        int row = 0,section = 0;
        
        for (int i = 0; i<self.tempDataSourceArray.count; i++) {
            
            NSArray *tempArr = self.tempDataSourceArray[i];
            
            for (int j = 0; j<tempArr.count; j++) {
                EditMyToolsModel *toolModel = tempArr[j];
                if ([model.title isEqualToString:toolModel.title]) {
                    
                    row = j;
                    section = i;
                    break;
                }
            }
        }
        
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:row inSection:section];
        
        EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:lastIndex];
        
        UIImage *image = [self captureImageFromViewLow:cell];
        UIImageView * captureImageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = [self.view convertRect:cell.frame fromView:self.collectionView];
        captureImageView.frame = frame;
        
        [self.view addSubview:captureImageView];
        
        NSMutableArray *tempArray = [self.tempDataSourceArray[lastIndex.section] mutableCopy];
        [tempArray removeObjectAtIndex:lastIndex.row];
        
        [self.tempDataSourceArray replaceObjectAtIndex:lastIndex.section withObject:tempArray];
        
        
        [self.collectionView deleteItemsAtIndexPaths:@[lastIndex]];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = [self.headerView getFrame];
            
            captureImageView.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [captureImageView removeFromSuperview];
            
            [self.headerView.dataArray addObject:model];
            
            [self.headerView.collectionView reloadData];
            
        }];
    
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.headerView.dataArray.count >8) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多选择9个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    EditMyToolsModel *model = self.tempDataSourceArray[indexPath.section][indexPath.row];
    

    EditMyToolsCollectionViewCell *cell = (EditMyToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    UIImage *image = [self captureImageFromViewLow:cell];
    UIImageView * captureImageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = [self.view convertRect:cell.frame fromView:self.collectionView];
    captureImageView.frame = frame;
    
    [self.view addSubview:captureImageView];
    
    NSMutableArray *tempArray = [self.tempDataSourceArray[indexPath.section] mutableCopy];
    [tempArray removeObjectAtIndex:indexPath.row];
    
    [self.tempDataSourceArray replaceObjectAtIndex:indexPath.section withObject:tempArray];
    
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = [self.headerView getFrame];
        
        captureImageView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [captureImageView removeFromSuperview];
        
        [self.headerView.dataArray addObject:model];
        
        [self.headerView.collectionView reloadData];
        
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (main_Width-20*kWidthScale)/ApplicationColumnNum-10*kWidthScale;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10*kWidthScale, 10*kWidthScale, 10*kWidthScale, 10*kWidthScale);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*kWidthScale;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*kWidthScale;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat height = (main_Width-20*kWidthScale)/ApplicationColumnNum-10*kWidthScale;
        return CGSizeMake(main_Width, (height +20*kWidthScale)*2 + 50*kWidthScale +60);
    }
    return CGSizeMake(main_Width, ApplicationSectionHeight);
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

#pragma mark - 点击事件
-(void)cancelClick{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finishClick{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载

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
        _collectionView.userInteractionEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        // 注册cell
        [_collectionView registerClass:[EditMyToolsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EditMyToolsCollectionViewCell class])];
        [_collectionView registerClass:[EditMyToolsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EditMyToolsCollectionReusableView class])];
        [_collectionView registerClass:[EditMyToolsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EditMyToolsHeaderView class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.bounds = CGRectMake(0, 0, 44, 44);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:30*kWidthScale];
        [_cancelBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];

        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _cancelBtn;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        
        _finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _finishBtn.bounds = CGRectMake(0, 0, 44, 44);
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:30*kWidthScale];
        [_finishBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}


- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray){
        NSArray *array = @[@[@"通知管理",@"每周评语",@"亲子作业",@"每周课程",@"班级相册",@"成长档案",@"通讯录",@"消息留言",@"微官网",@"积分商城"],@[@"晨检管理",@"每周食谱",@"叮嘱"],@[@"设备管理",@"校车管理",@"内部办公",@"补卡管理",@"在线缴费"],@[@"学生考勤",@"请假管理",@"宝贝在线"],@[@"教师管理",@"考勤管理",@"请假管理"]];
        NSArray *imgArray = @[@[@"icon_inform_manage",@"icon_weekly_comment",@"icon_home_work",@"icon_weekly_course",@"icon_class_album",@"icon_grow_file",@"icon_phone_list",@"icon_mesage_news",@"icon_mirco_web",@"icon_points_mall"],@[@"icon_morning_inspection",@"icon_weekly_cookbook",@"icon_weekly_warn"],@[@"icon_equipment_manage",@"icon_bus_manage",@"icon_Internal_office",@"icon_card_add",@"icon_pay_online"],@[@"icon_student_attendance",@"icon_leave_manage",@"icon_baby_online"],@[@"icon_teacher_manage",@"icon_attendance_manage",@"icon_leave_manage"]];
        _dataSourceArray = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<array.count; i++)
        {
            NSArray *arr = array[i];
            NSArray *imgArr = imgArray[i];
            NSMutableArray *sourceArray = [[NSMutableArray alloc] init];
            for (NSUInteger j=0; j<arr.count; j++)
            {
                EditMyToolsModel *model = [[EditMyToolsModel alloc] init];
                model.title = arr[j];
                model.imageStr = imgArr[j];
                
                model.row = j;
                model.section = i;
                
                [sourceArray addObject:model];
            }
            
            [_dataSourceArray addObject:sourceArray];
        }

    }
    return _dataSourceArray;
}

- (NSMutableArray *)tempDataSourceArray
{
    if (!_tempDataSourceArray) {
        NSArray *array = @[@[@"通知管理",@"每周评语",@"亲子作业",@"每周课程",@"班级相册",@"成长档案",@"通讯录",@"消息留言",@"微官网",@"积分商城"],@[@"晨检管理",@"每周食谱",@"叮嘱"],@[@"设备管理",@"校车管理",@"内部办公",@"补卡管理",@"在线缴费"],@[@"学生考勤",@"请假管理",@"宝贝在线"],@[@"教师管理",@"考勤管理",@"请假管理"]];
        NSArray *imgArray = @[@[@"icon_inform_manage",@"icon_weekly_comment",@"icon_home_work",@"icon_weekly_course",@"icon_class_album",@"icon_grow_file",@"icon_phone_list",@"icon_mesage_news",@"icon_mirco_web",@"icon_points_mall"],@[@"icon_morning_inspection",@"icon_weekly_cookbook",@"icon_weekly_warn"],@[@"icon_equipment_manage",@"icon_bus_manage",@"icon_Internal_office",@"icon_card_add",@"icon_pay_online"],@[@"icon_student_attendance",@"icon_leave_manage",@"icon_baby_online"],@[@"icon_teacher_manage",@"icon_attendance_manage",@"icon_leave_manage"]];
        _tempDataSourceArray = [[NSMutableArray alloc] init];
        for (NSUInteger i=0; i<array.count; i++)
        {
            NSArray *arr = array[i];
            NSArray *imgArr = imgArray[i];
            NSMutableArray *sourceArray = [[NSMutableArray alloc] init];
            for (NSUInteger j=0; j<arr.count; j++)
            {
                EditMyToolsModel *model = [[EditMyToolsModel alloc] init];
                model.title = arr[j];
                model.imageStr = imgArr[j];
                model.row = j;
                model.section = i;
                
                [sourceArray addObject:model];
            }
            
            [_tempDataSourceArray addObject:sourceArray];
        }

    }
    return  _tempDataSourceArray;
}

- (NSMutableArray *)myApplicationTitleArray
{
    if(!_myApplicationTitleArray)
    {
        _myApplicationTitleArray =[[NSMutableArray alloc] initWithArray:@[@"家园共育",@"营养保健",@"园务管理",@"平安院所",@"教师管理"]];
    }
    return _myApplicationTitleArray;
}


@end
