//
//  WaterFlowLayout.h
//  瀑布流By-LW
//
//  Created by 刘伟 on 2017/9/7.
//  Copyright © 2017年 刘伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowLayout;

@protocol WaterflowLayoutDelegate <NSObject>

- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFlowLayout : UICollectionViewLayout
//整块的4个方向间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;

@property(nonatomic,weak)id<WaterflowLayoutDelegate>delegate;
@end
