//
//  TAXspreadSheet.m
//  InfusionTable
//
//  Created by 金井 慎一 on 2013/07/25.
//  Copyright (c) 2013年 Twelve Axis. All rights reserved.
//

#import "TAXSpreadSheet.h"
#import "TAXSpreadSheetLayout.h"

@interface TAXSpreadSheet () <UICollectionViewDataSource, TAXSpreadSheetLayoutDataSource, TAXSpreadSheetLayoutDelegate>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) TAXSpreadSheetLayout *layout;
@end

@implementation TAXSpreadSheet

static NSString * const EmptyViewIdentifier = @"EmptyView";
const CGFloat defaultCellWidth = 50.0;
const CGFloat defaultCellHeight = 50.0;
const CGFloat defaultSpacing = 0.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self p_init];
}

- (void)layoutSubviews
{
    [_layout invalidateLayout];
}

- (void)p_init
{
    // Initialization code
    TAXSpreadSheetLayout *layout = [[TAXSpreadSheetLayout alloc] init];
    layout.dataSource = self;
    layout.delegate = self;
    self.layout = layout;

    self.contentOffset = CGPointZero;
    self.cellSize = CGSizeMake(defaultCellWidth, defaultCellHeight);
    self.insets = UIEdgeInsetsZero;
    self.interColumnSpacing = defaultSpacing;
    self.interRowSpacing = defaultSpacing;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self.delegate;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // Register Dummy View
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:TAXSpreadSheetLayoutInterColumnView withReuseIdentifier:EmptyViewIdentifier];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:TAXSpreadSheetLayoutInterRowView withReuseIdentifier:EmptyViewIdentifier];

    self.collectionView = collectionView;
    
    [self addSubview:collectionView];
}

# pragma mark - Properties of UICollectionView

- (void)setDelegate:(id<TAXSpreadSheetDelegate>)delegate
{
    _delegate = delegate;
    self.collectionView.delegate = delegate;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.collectionView.scrollEnabled = scrollEnabled;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    self.collectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    self.collectionView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    self.collectionView.contentOffset = contentOffset;
}

- (void)setCellSize:(CGSize)cellSize
{
    _cellSize = cellSize;
    self.layout.cellSize = cellSize;
}

- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    self.layout.insets = insets;
}

- (void)setInterColumnSpacing:(CGFloat)interColumnSpacing
{
    _interColumnSpacing = interColumnSpacing;
    self.layout.interColumnSpacing = interColumnSpacing;
}

- (void)setInterRowSpacing:(CGFloat)interRowSpacing
{
    _interRowSpacing = interRowSpacing;
    self.layout.interRowSpacing = interRowSpacing;
}

# pragma mark - Register Classes

// Register Class for Cell
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

// Register Class for Inter Row View
- (void)registerClass:(Class)viewClass forInterRowViewWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:TAXSpreadSheetLayoutInterRowView withReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forInterRowViewWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:TAXSpreadSheetLayoutInterRowView withReuseIdentifier:identifier];
}

// Register Class for Inter Column View
- (void)registerClass:(Class)viewClass forInterColumnViewWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:TAXSpreadSheetLayoutInterColumnView withReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forInterColumnViewWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:TAXSpreadSheetLayoutInterColumnView withReuseIdentifier:identifier];
}

# pragma mark - Dequeue Views

// Dequeue Cell
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forRow:(NSUInteger)row column:(NSUInteger)column
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:row];
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

// Dequeue Inter-Row/Column View
- (id)dequeueReusableSupplementaryViewOfKind:(NSString*)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath
{
    UICollectionReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:indexPath];
    return reusableView;
}

- (id)dequeueReusableInterColumnViewWithIdentifier:(NSString *)identifier afterColumn:(NSUInteger)column
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:0];
    UICollectionReusableView *interColumnView = [self.collectionView dequeueReusableSupplementaryViewOfKind:TAXSpreadSheetLayoutInterColumnView withReuseIdentifier:identifier forIndexPath:indexPath];
    return interColumnView;
}

- (id)dequeueReusableInterRowViewWithIdentifier:(NSString *)identifier belowRow:(NSUInteger)row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:row];
    UICollectionReusableView *interRowView = [self.collectionView dequeueReusableSupplementaryViewOfKind:TAXSpreadSheetLayoutInterRowView withReuseIdentifier:identifier forIndexPath:indexPath];
    return interRowView;
}

- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell
{
    return [_collectionView indexPathForCell:cell];
}

# pragma mark - CollectionView DataSource

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource spreadSheet:self
                              cellAtRow:indexPath.section
                                 column:indexPath.item];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if ([kind isEqualToString:TAXSpreadSheetLayoutInterColumnView] &&
        [self.delegate respondsToSelector:@selector(spreadSheet:interColumnViewAfterColumn:)]) {
        view = [self.delegate spreadSheet:self interColumnViewAfterColumn:indexPath.item];
    } else if ([kind isEqualToString:TAXSpreadSheetLayoutInterRowView] &&
               [self.delegate respondsToSelector:@selector(spreadSheet:interRowViewBelowRow:)]) {
        view = [self.delegate spreadSheet:self interRowViewBelowRow:indexPath.section];
    }
    
    if (view) {
        return view;
    } else {
        return [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:EmptyViewIdentifier forIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfRows;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfColumns;
}

# pragma mark - SpreadSheetLayout DataSource

- (NSUInteger)numberOfRows
{
    return [self.dataSource numberOfRowsInSpreadSheet:self];
}

- (NSUInteger)numberOfColumns
{
    return [self.dataSource numberOfColumnsInSpreadSheet:self];
}

# pragma mark - SpreadSheetLayout Delegate

- (CGFloat)widthAtColumn:(NSUInteger)column
{
    if ([self.delegate respondsToSelector:@selector(spreadSheet:widthAtColumn:)] &&
        [self.delegate spreadSheet:self widthAtColumn:column] != NSNotFound) {
        return [self.delegate spreadSheet:self widthAtColumn:column];
    } else {
        return self.cellSize.width;
    }
}

- (CGFloat)heightAtRow:(NSUInteger)row
{
    if ([self.delegate respondsToSelector:@selector(spreadSheet:heightAtRow:)] &&
        [self.delegate spreadSheet:self heightAtRow:row] != NSNotFound) {
        return [self.delegate spreadSheet:self heightAtRow:row];
    } else {
        return self.cellSize.height;
    }
}

- (CGFloat)trailingSpacingAfterColumn:(NSUInteger)column
{
    if ([self.delegate respondsToSelector:@selector(spreadSheet:trailingSpacingAfterColumn:)] &&
        [self.delegate spreadSheet:self trailingSpacingAfterColumn:column] != NSNotFound) {
        return [self.delegate spreadSheet:self trailingSpacingAfterColumn:column];
    } else {
        return self.interColumnSpacing;
    }
}

- (CGFloat)bottomSpacingBelowRow:(NSUInteger)row
{
    if ([self.delegate respondsToSelector:@selector(spreadSheet:bottomSpacingBelowRow:)] &&
        [self.delegate spreadSheet:self bottomSpacingBelowRow:row] != NSNotFound) {
        return [self.delegate spreadSheet:self bottomSpacingBelowRow:row];
    } else {
        return self.interRowSpacing;
    }
}

@end
