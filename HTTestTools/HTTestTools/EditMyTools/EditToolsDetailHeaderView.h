//
//  EditToolsDetailHeaderView.h
//  HTTestTools
//
//  Created by longfei on 2019/8/5.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditEditToolsDetailHeaderViewBlock)(void);

@interface EditToolsDetailHeaderView : UIView

@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, copy) EditEditToolsDetailHeaderViewBlock buttonClickBlock;

@end
