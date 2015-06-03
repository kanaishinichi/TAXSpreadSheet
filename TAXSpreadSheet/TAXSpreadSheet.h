//
//  TAXspreadSheet.h
//  InfusionTable
//
//  Created by 金井 慎一 on 2013/07/25.
//  Copyright (c) 2013年 Twelve Axis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TAXSpreadSheet;

@protocol TAXSpreadSheetDataSource <NSObject>
@required
// Getting spreadsheet metrics.
- (NSUInteger)numberOfRowsInSpreadSheet:(TAXSpreadSheet *)spreadSheet;
- (NSUInteger)numberOfColumnsInSpreadSheet:(TAXSpreadSheet *)spreadSheet;

// Getting views for cells.
- (UICollectionViewCell*)spreadSheet:(TAXSpreadSheet *)spreadSheet cellAtRow:(NSUInteger)row column:(NSUInteger)column ;
@end

@protocol TAXSpreadSheetDelegate <UICollectionViewDelegate>
@optional
// Specifying individual cell heights/widths and spacing.
// In case of using default value, return NSNotFound.
- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet heightAtRow:(NSUInteger)row;
- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet widthAtColumn:(NSUInteger)column;

- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet bottomSpacingBelowRow:(NSUInteger)row;
- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet trailingSpacingAfterColumn:(NSUInteger)column;

- (UICollectionReusableView *)spreadSheet:(TAXSpreadSheet *)spreadSheet interRowViewBelowRow:(NSUInteger)row;
- (UICollectionReusableView *)spreadSheet:(TAXSpreadSheet *)spreadSheet interColumnViewAfterColumn:(NSUInteger)column;

@end

@interface TAXSpreadSheet : UICollectionViewCell

@property (nonatomic, weak) IBOutlet id <TAXSpreadSheetDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <TAXSpreadSheetDelegate> delegate;

@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator, showsVerticalScrollIndicator;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic) BOOL bounces;

// default YES
@property (nonatomic, assign) BOOL bounces;

/// Size of cells.
/// Default: (50.0, 50.0)
@property (nonatomic, assign) CGSize cellSize;

/// Content insets.
/// Default: UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets insets;

/// Value for inter-row spacing.
/// Default: 0.0
@property (nonatomic, assign) CGFloat interRowSpacing;

/// Value for inter-column spacing.
/// Default: 0.0
@property (nonatomic, assign) CGFloat interColumnSpacing;

// Register class/nib for cell.
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forRow:(NSUInteger)column column:(NSUInteger)row;

// Register class/nib for inter-row view.
- (void)registerClass:(Class)viewClass forInterRowViewWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forInterRowViewWithReuseIdentifier:(NSString *)identifier;

// Register class/nib for inter-column view.
- (void)registerClass:(Class)viewClass forInterColumnViewWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forInterColumnViewWithReuseIdentifier:(NSString *)identifier;

// Dequeue Inter-Row/Column View
- (id)dequeueReusableInterRowViewWithIdentifier:(NSString *)identifier belowRow:(NSUInteger)row;
- (id)dequeueReusableInterColumnViewWithIdentifier:(NSString *)identifier afterColumn:(NSUInteger)column;

# pragma mark - UICollectionView/Layout compatible methods.

- (void)invalidateLayout;

# pragma mark Reloading Content
- (void)reloadData;
- (void)reloadRows:(NSIndexSet *)rows;
- (void)reloadColumns:(NSIndexSet *)columns;

# pragma mark Inserting, Moving, and Deleting Rows
- (void)insertRows:(NSIndexSet *)rows;
- (void)moveRow:(NSInteger)fromRow toRow:(NSInteger)toRow;
- (void)deleteRows:(NSIndexSet *)rows;

# pragma mark Inserting, Moving, and Deleting Columns
- (void)insertColumns:(NSIndexSet *)columns;
- (void)moveColumn:(NSInteger)fromColumn toColumn:(NSInteger)toColumn;
- (void)deleteColumns:(NSIndexSet *)columns;

# pragma mark Managing the Selection
@property (nonatomic, assign) BOOL allowsSelection;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
- (NSArray *)indexPathsForSelectedCells;
- (void)selectCellAtRow:(NSUInteger)row column:(NSUInteger)column animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;

# pragma mark Locating Cells in the Spread Sheet
- (NSIndexPath *)indexPathForCellAtPoint:(CGPoint)point;
- (NSArray *)indexPathsForVisibleCells;
- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell;
- (UICollectionViewCell *)cellAtRow:(NSUInteger)row column:(NSUInteger)column;

# pragma mark Scrolling a Cell Into View
- (void)scrollToCellAtRow:(NSUInteger)row column:(NSUInteger)column atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

# pragma mark Animating Multiple Changes to the Spread Sheet
- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion;

@end
