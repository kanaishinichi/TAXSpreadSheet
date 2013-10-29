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

- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell;

@end
