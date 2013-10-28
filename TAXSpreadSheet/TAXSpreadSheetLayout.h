//
//  TAXSpreadSheetLayout.h
//  InfusionTable
//
//  Created by 金井 慎一 on 2013/07/25.
//  Copyright (c) 2013年 Twelve Axis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TAXSpreadSheetLayoutDataSource <NSObject>

@required
- (NSUInteger)numberOfRows;
- (NSUInteger)numberOfColumns;

@end

@protocol TAXSpreadSheetLayoutDelegate <NSObject>

@optional
- (CGFloat)widthAtColumn:(NSUInteger)column;
- (CGFloat)heightAtRow:(NSUInteger)row;
- (CGFloat)trailingSpacingAfterColumn:(NSUInteger)column;
- (CGFloat)bottomSpacingBelowRow:(NSUInteger)row;

@end

@interface TAXSpreadSheetLayout : UICollectionViewLayout

extern NSString * const TAXSpreadSheetLayoutInterColumnView;
extern NSString * const TAXSpreadSheetLayoutInterRowView;

@property (nonatomic, weak) IBOutlet id <TAXSpreadSheetLayoutDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <TAXSpreadSheetLayoutDelegate> delegate;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat interColumnSpacing;
@property (nonatomic, assign) CGFloat interRowSpacing;
@property (nonatomic, assign) UIEdgeInsets insets;

@end
