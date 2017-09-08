//
//  WaterFlowLayout.m
//  瀑布流By-LW
//
//  Created by 刘伟 on 2017/9/7.
//  Copyright © 2017年 刘伟. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout ()

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

/** 这个字典用来存储每一列最大的Y值(每一列的高度)   其实也就是最底下那个item的height 这个值是为了比较
 key:列,vlaue:列高
 
 */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;

@end

@implementation WaterFlowLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(30, 10, 10, 10);//上左下右
        self.columnsCount = 3;
    }
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

-(NSMutableDictionary *)maxYDict{
    if (!_maxYDict) {
        self.maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}

//滚动时是否重新计算
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

/**
 *  每次布局之前的准备 最先调用
 */
- (void)prepareLayout{

    NSLog(@"prepareLayout");//调一次
    // 1.清空最大的Y值 清空是为了防止滚动个计算出问题
    for (int i = 0; i<self.columnsCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        //NSLog(@"self.sectionInset.top: %f",self.sectionInset.top);//10
        self.maxYDict[column] = @(self.sectionInset.top);//sectionInset有上下左右
    }
    
    // 2.计算所有cell的属性
    [self.attrsArray removeAllObjects];
    //获得有多少个item
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0 ; i< count; i++) {
        //这个获取属性方法下面有重写
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

//重写 计算item属性方法 2 思路从需要的值往前推 这个方法最重要
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"self.maxYDict %@",self.maxYDict);
//    {
//        0 = 30;
//        1 = 30;
//        2 = 30;
//    }

    //假设一个最小值
    __block NSString *minColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString * column, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //找到每一行最短的那个列 0/1/2 后面往这个列加下一张图片的height
        if ([obj floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    //计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount -1)*self.columnMargin)/self.columnsCount;
    //CGFloat height = 100 + arc4random_uniform(100);//先随机给个高度 这样做滚动时会出现烟花缭乱的
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];//让代理去帮忙计算
    
    //NSLog(@"height %f",height);
    //计算位置
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) *[minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue] + self.rowMargin;
    self.maxYDict[minColumn] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}

//重写 返回collectionView的 Size方法 这个要计算完所有item才知道
//这个方法子类和父类都会调一次 所以会调2次 不奇怪
-(CGSize)collectionViewContentSize{
    //[super prepareLayout];
    
    __block NSString *maxCloumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] > [self.maxYDict[maxCloumn] floatValue]) {
            maxCloumn = key;
        }
    }];
    NSLog(@"collectionViewContentSize - %f",[self.maxYDict[maxCloumn] floatValue]);//一次全部item布局调2次
    return CGSizeMake(0, [self.maxYDict[maxCloumn] floatValue]);//0表示不支持水平滚动,最大y值可以遍历
    
}

//重写返回所有item属性方法
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"layoutAttributesForElementsInRect");
    //在prepare一次性算好 然后扔过来
    return self.attrsArray;
}


@end























