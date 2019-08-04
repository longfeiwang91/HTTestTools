//
//  EditMyToolsCollectionReusableView.m
//  HTTestTools
//
//  Created by longfei on 2019/8/1.
//  Copyright © 2019 LongfeiWang. All rights reserved.
//

#import "EditMyToolsCollectionReusableView.h"

@implementation EditMyToolsCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        if(![self.subviews containsObject:self.label])
        {
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(10*kWidthScale, 0, frame.size.width, frame.size.height)];
            self.label.textColor = kBlackColor;
            self.label.font = [UIFont systemFontOfSize:36*kWidthScale];
            [self addSubview:self.label];
        }
        
    }
    return self;
}

@end
