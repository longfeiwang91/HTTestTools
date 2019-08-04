//
//  EditMyToolsModel.h
//  HTTestTools
//
//  Created by longfei on 2019/8/1.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditMyToolsModel : NSObject


@property (nonatomic,copy) NSString * imageStr;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,assign) BOOL     canEdit;

@property (nonatomic,copy) NSString * sortOrder;

@property(nonatomic, assign) NSUInteger section;

@property(nonatomic, assign) NSUInteger row;

@property(nonatomic, assign) BOOL isFirstSection;



@end
