//
//  ViewController.m
//  瀑布流By-LW
//
//  Created by 刘伟 on 2017/9/7.
//  Copyright © 2017年 刘伟. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "Goods.h"
#import "WaterFlowLayout.h"
#import "goodCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterflowLayoutDelegate>

@property(nonatomic,strong)NSMutableArray *goods;
@property(nonatomic,weak)UICollectionView *collectionView;

@end

@implementation ViewController

static NSString *const ID = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.初始化数据
    NSArray *goodArray = [Goods objectArrayWithFilename:@"1.plist"];
    [self.goods addObjectsFromArray:goodArray];
    
    //2.setUpUI
    WaterFlowLayout *waterLayout = [[WaterFlowLayout alloc]init];
    waterLayout.delegate=self;
    
//    //系统自带的UICollectionViewFlowLayout 而不是UICollectionViewLayout
//    UICollectionViewFlowLayout *waterLayout = [[UICollectionViewFlowLayout alloc]init];
//    waterLayout.itemSize = CGSizeMake(100, 300);
//    waterLayout.minimumLineSpacing = 5;
//    waterLayout.minimumInteritemSpacing = 5;
//    waterLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"goodCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    //3.增加刷新控件
}

#pragma mark - 懒加载
-(NSMutableArray *)goods{
    if (_goods == nil) {
        self.goods = [NSMutableArray array];
    }
    return _goods;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"self.goods.count: %ld",self.goods.count);
    return self.goods.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    goodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.good = self.goods[indexPath.item];
    return cell;

}

#pragma mark -  WaterflowLayoutDelegate 让self代替计算图片的高度
- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    Goods *good = self.goods[indexPath.item];
    return good.h * width / good.w ;
}


















@end
