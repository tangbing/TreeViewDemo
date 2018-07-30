//
//  ContactCell.m
//  Epipe
//
//  Created by EderKaw on 2017/7/20.
//  Copyright © 2017年 Epipe-iOS. All rights reserved.
//

#define SCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)

#import "ContactCell.h"
#import <UIImageView+WebCache.h>

@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 8, 32, 32)];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = 16;
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.headImageView];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.headImageView.frame.origin.x + self.headImageView.bounds.size.width + 10, 0, SCREEN_WIDTH - self.headImageView.frame.origin.x - self.headImageView.bounds.size.width - 10, 48)];
        self.nameLab.textColor = [UIColor blackColor];
        //[MyControl colorWithHexString:@"#333333"];
        self.nameLab.font = [UIFont systemFontOfSize:16];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLab];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(45, 50 - 0.5, SCREEN_WIDTH - 15, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        //[MyControl colorWithHexString:@"#D9D9D9"];
        [self addSubview:lineView];
        
    }
    return self;
}

- (void)setStaffModel:(Staffs *)staffModel
{
    _staffModel = staffModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:staffModel.profileImg] placeholderImage:[UIImage imageNamed:@"portrait-pho"]];
    self.nameLab.text = staffModel.name;
}



@end
