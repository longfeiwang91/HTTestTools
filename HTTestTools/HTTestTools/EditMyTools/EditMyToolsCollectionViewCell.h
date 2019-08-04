//
//  EditMyToolsCollectionViewCell.h
//  HTTestTools
//
//  Created by longfei on 2019/8/1.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditMyToolsModel;

typedef void(^EditMyToolsCollectionViewCellBlock)(EditMyToolsModel *model);


typedef NS_ENUM(NSInteger, EditMyToolsCollectionViewCellEditButtonState) {
    
    EditMyToolsCollectionViewCellEditButtonStateNone,
    EditMyToolsCollectionViewCellEditButtonStateAdd,
    EditMyToolsCollectionViewCellEditButtonStateRemove,
    EditMyToolsCollectionViewCellEditButtonStateNonRemove,
    
};

@interface EditMyToolsCollectionViewCell : UICollectionViewCell

@property(nonatomic, copy) EditMyToolsCollectionViewCellBlock buttonClickBlock;

@property(nonatomic, strong) EditMyToolsModel *model;

//- (void)updateUIWithApplicationModel:(EditMyToolsModel *)model;
//- (void)setEditState:(EditMyToolsCollectionViewCellEditButtonState )state;

@end
