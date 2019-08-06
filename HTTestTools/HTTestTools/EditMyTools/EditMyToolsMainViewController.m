//
//  EditMyToolsMainViewController.m
//  HTTestTools
//
//  Created by longfei on 2019/8/5.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import "EditMyToolsMainViewController.h"
#import "EditMyToolsModel.h"
#import "EditMyToolsDetailViewCell.h"

#import "EditToolsDetailHeaderView.h"

#import "EditMyToolsEditViewController.h"


#import "EditMyToolsModel.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

static NSInteger ApplicationColumnNum = 5;

static NSString *editMyToolsMainCellId = @"MainCellId";

@interface EditMyToolsMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataSourceArray;

@property(nonatomic, strong) NSMutableArray * tempDataSourceArray;

@property(nonatomic, strong) NSMutableArray *myApplicationTitleArray;

@property(nonatomic, strong) EditToolsDetailHeaderView *headerView;

@property (strong, nonatomic) UITableView *tableView;


@end

@implementation EditMyToolsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor_f1f4f2;
    
    [self setupUI];

}

#pragma mark - 设置UI界面
- (void)setupUI{
    
    [self.view addSubview:self.tableView];
    
    [_tableView layoutIfNeeded];
    _tableView.tableHeaderView = self.headerView;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView\
{
   return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataSourceArray[indexPath.section];
    
    if (array.count == 0) {
        return 100*kWidthScale;
    }
    NSUInteger count = array.count;
    NSUInteger lineNumber = count%ApplicationColumnNum==0?(count/ApplicationColumnNum):(count/ApplicationColumnNum+1);

    return lineNumber *(main_Width/ApplicationColumnNum-10*kWidthScale)+(lineNumber>1?(lineNumber-1)*10*kWidthScale:0) + 100*kWidthScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditMyToolsDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editMyToolsMainCellId forIndexPath:indexPath];
    NSArray *array = self.dataSourceArray[indexPath.section];
    cell.dataSource = array;
    cell.title = self.myApplicationTitleArray[indexPath.section];
    return cell;
    
}


#pragma mark - 懒加载

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [UITableView ht_tableViewWithStyle:UITableViewStylePlain delegate:self dataSource:self rowHeight:443*kWidthScale];
        
        _tableView.backgroundColor = kColor_f1f4f2;
        
        [_tableView registerClass:[EditMyToolsDetailViewCell class] forCellReuseIdentifier:editMyToolsMainCellId];

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        
    }
    return _tableView;
}

- (EditToolsDetailHeaderView *)headerView{
    if (!_headerView) {
        
        _headerView = [[EditToolsDetailHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, main_Width, 260*kWidthScale);
        @weakify(self);
        _headerView.buttonClickBlock = ^{
            @strongify(self);
            EditMyToolsEditViewController *editVC = [[EditMyToolsEditViewController alloc] init];
            [self.navigationController pushViewController:editVC animated:YES];
            self.navigationController.navigationBar.hidden = NO;
            self.navigationController.navigationBar.barTintColor = kThemeColor;
        };
    }
    return _headerView;
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
