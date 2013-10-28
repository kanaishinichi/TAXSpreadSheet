//
//  TAXSpreadSheetLayout.m
//  InfusionTable
//
//  Created by 金井 慎一 on 2013/07/25.
//  Copyright (c) 2013年 Twelve Axis. All rights reserved.
//

#import "TAXSpreadSheetLayout.h"

@interface TAXSpreadSheetLayout ()
@property (nonatomic) NSMutableArray *leadingEdges, *trailingEdges, *topEdges, *bottomEdges;

@property (nonatomic, readwrite) NSMutableArray *widths;
@property (nonatomic, readwrite) NSMutableArray *heights;

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) NSUInteger numberOfColumns;

@end

@implementation TAXSpreadSheetLayout

NSString * const TAXSpreadSheetLayoutInterColumnView = @"InterColumnView";
NSString * const TAXSpreadSheetLayoutInterRowView = @"InterRowView";

- (NSUInteger)numberOfColumns
{
    return [self.dataSource numberOfColumns];
}

- (NSUInteger)numberOfRows
{
    return [self.dataSource numberOfRows];
}

- (CGFloat)p_widthAtColumn:(NSUInteger)column
{
    if ([self.delegate respondsToSelector:@selector(widthAtColumn:)]) {
        return [self.delegate widthAtColumn:column];
    } else {
        return self.cellSize.width;
    }
}

- (CGFloat)p_heightAtRow:(NSUInteger)row
{
    if ([self.delegate respondsToSelector:@selector(heightAtRow:)]) {
        return [self.delegate heightAtRow:row];
    } else {
        return self.cellSize.height;
    }
}

- (CGFloat)p_spacingAfterColumn:(NSUInteger)column
{
    if ([self.delegate respondsToSelector:@selector(trailingSpacingAfterColumn:)]) {
        return [self.delegate trailingSpacingAfterColumn:column];
    } else {
        return self.interColumnSpacing;
    }
}

- (CGFloat)p_spacingBelowRow:(NSUInteger)row
{
    if ([self.delegate respondsToSelector:@selector(bottomSpacingBelowRow:)]) {
        return [self.delegate bottomSpacingBelowRow:row];
    } else {
        return self.interRowSpacing;
    }
}

- (void)prepareLayout
{
    self.leadingEdges = [[NSMutableArray alloc] initWithCapacity:self.numberOfColumns];
    self.trailingEdges = [[NSMutableArray alloc] initWithCapacity:self.numberOfColumns];
    self.topEdges = [[NSMutableArray alloc] initWithCapacity:self.numberOfRows];
    self.bottomEdges = [[NSMutableArray alloc] initWithCapacity:self.numberOfRows];
    _leadingEdges[0] = @0.0;
    _topEdges[0] = @0.0;
    
    // X axis
    for (NSUInteger idx = 0; idx < self.numberOfColumns; idx ++) {
        CGFloat previousLeadingEdge = [_leadingEdges[idx] doubleValue];
        CGFloat trailingEdge = previousLeadingEdge + [self p_widthAtColumn:idx];
        CGFloat leadingEdge = trailingEdge + [self p_spacingAfterColumn:idx];
        _leadingEdges[idx+1] = @(leadingEdge);
        _trailingEdges[idx] = @(trailingEdge);
    }
    
    // Y axis
    for (NSUInteger idx = 0; idx < self.numberOfRows; idx++) {
        CGFloat previousTopEdge = [_topEdges[idx] doubleValue];
        CGFloat bottomEdge = previousTopEdge + [self p_heightAtRow:idx];
        CGFloat topEdge = bottomEdge+ [self p_spacingBelowRow:idx];
        _topEdges[idx+1] = @(topEdge);
        _bottomEdges[idx] = @(bottomEdge);
    }
}

- (CGSize)collectionViewContentSize
{
    CGFloat horizontalPadding = _insets.left + _insets.right;
    CGFloat verticalPadding = _insets.top + _insets.bottom;
    return CGSizeMake([[_leadingEdges lastObject] doubleValue] + horizontalPadding,
                      [[_topEdges lastObject] doubleValue] + verticalPadding);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSUInteger column = indexPath.item;
    NSUInteger row = indexPath.section;
    CGFloat leading = [_leadingEdges[column] doubleValue];
    CGFloat top = [_topEdges[row] doubleValue];
    CGFloat width = [self p_widthAtColumn:column];
    CGFloat height = [self p_heightAtRow:row];
    
    CGRect rawFrame = CGRectMake(leading, top, width, height);
    attributes.frame = CGRectOffset(rawFrame, _insets.left, _insets.top);
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributesArray = [NSMutableArray array];
    
    // Items
    for (NSInteger row = 0 ; row < self.numberOfRows; row ++) {
        for (NSInteger column = 0; column < self.numberOfColumns; column ++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:column inSection:row];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesArray addObject:attributes];
            }
        }
    }
    
    // InterColumnViews
    for (NSInteger column = 0; column < self.numberOfColumns -1; column ++) {
        NSIndexPath *columnPath = [NSIndexPath indexPathForItem:column inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:TAXSpreadSheetLayoutInterColumnView atIndexPath:columnPath];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }
    
    // InterRowViews
    for (NSInteger row = 0; row < self.numberOfRows -1; row ++) {
        NSIndexPath *rowPath = [NSIndexPath indexPathForItem:0 inSection:row];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:TAXSpreadSheetLayoutInterRowView atIndexPath:rowPath];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:TAXSpreadSheetLayoutInterColumnView]) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        
        NSUInteger column = indexPath.item;
        CGFloat leading = [_trailingEdges[column] doubleValue];
        CGFloat top = [_topEdges[0] doubleValue];
        CGFloat width = [self p_spacingAfterColumn:column];
        CGFloat height = [[_bottomEdges lastObject] doubleValue];
        CGRect frame = CGRectMake(leading, top, width, height);
        attributes.frame = CGRectOffset(frame, _insets.left, _insets.top);
        return attributes;
    } else if ([kind isEqualToString:TAXSpreadSheetLayoutInterRowView]) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        
        NSUInteger row = indexPath.section;
        CGFloat leading = [_leadingEdges[0] doubleValue];
        CGFloat top = [_bottomEdges[row] doubleValue];
        CGFloat width = [[_trailingEdges lastObject] doubleValue];
        CGFloat height = [self p_spacingBelowRow:row];
        CGRect frame = CGRectMake(leading, top, width, height);
        attributes.frame = CGRectOffset(frame, _insets.left, _insets.top);
        return attributes;
    }
    return nil;
}

@end
