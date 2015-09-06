//
//  AZLeftImageView.m
//  27_28textFieldDZ
//
//  Created by admin on 04.06.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "AZLeftView.h"

@implementation AZLeftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(AZLeftView*) viewWithImage:(UIImage*) icon andFrame:(CGRect) rectImageView andRectParentView:(CGRect) rectParent  andColor:(UIColor*) color{
    
    UIImageView* v = [[UIImageView alloc]initWithFrame:rectImageView];
    AZLeftView* leftView = [[AZLeftView alloc] initWithFrame:rectParent];
    
    [v setImage:icon];
    v.backgroundColor = color;
    [v setContentMode:UIViewContentModeScaleAspectFit];
    
    [leftView addSubview:v];
    
    v.center = leftView.center;
    return leftView;
}

@end
