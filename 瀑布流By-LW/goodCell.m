//
//  goodCell.m
//  瀑布流By-LW
//
//  Created by 刘伟 on 2017/9/7.
//  Copyright © 2017年 刘伟. All rights reserved.
//

#import "goodCell.h"
#import "UIImageView+WebCache.h"

@implementation goodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setGood:(Goods *)good{
    _good = good;
    self.goodLabel.text = good.price;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:good.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}






















@end
