//
//  EditMyToolsHeaerView.h
//  HTTestTools
//
//  Created by longfei on 2019/8/2.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditMyToolsHeaderView;

@protocol EditMyToolsHeaderViewDelegate <NSObject>

-(void)editMyToolsHeaderView:(EditMyToolsHeaderView *)headerView deleteCellWithImageView:(UIImageView *)imageView frame:(CGRect )frame index:(NSUInteger )index;

@end

@interface EditMyToolsHeaderView : UICollectionReusableView

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (strong, nonatomic) UICollectionView *collectionView;

//向上移动 获取frame
- (CGRect)getFrame;

@property(nonatomic, weak) id<EditMyToolsHeaderViewDelegate> delegate;

@end

