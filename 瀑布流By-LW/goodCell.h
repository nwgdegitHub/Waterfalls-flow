//
//  goodCell.h
//  瀑布流By-LW
//
//  Created by 刘伟 on 2017/9/7.
//  Copyright © 2017年 刘伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"
@interface goodCell : UICollectionViewCell
@property(nonatomic,strong)Goods *good;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;


@end
