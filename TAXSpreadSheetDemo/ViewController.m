//
//  ViewController.m
//  TAXSpreadSheetDemo
//
//  Created by 金井 慎一 on 2013/10/28.
//  Copyright (c) 2013年 Twelve Axis. All rights reserved.
//

#import "ViewController.h"
#import "TAXSpreadSheet.h"
#import "TAXLabelCell.h"

@interface ViewController () <TAXSpreadSheetDataSource, TAXSpreadSheetDelegate>
{
    IBOutlet TAXSpreadSheet *_spreadSheet;
}
@property (nonatomic, assign) NSUInteger numberOfRows, numberOfColumns;
@property (nonatomic, assign) CGFloat widthOfColumn0;
- (IBAction)insertRowDidTap:(id)sender;
- (IBAction)deleteRowDidTap:(id)sender;
- (IBAction)moveRowDidTap:(id)sender;
- (IBAction)expandColumnDidTap:(id)sender;
- (IBAction)insertColumnDidTap:(id)sender;
@end

static NSString * const CellIdentifier = @"Cell";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberOfRows = 20;
    self.numberOfColumns = 10;
    self.widthOfColumn0 = 20;
    _spreadSheet.interColumnSpacing = 1.0;
    _spreadSheet.interRowSpacing = 1.0;
    [_spreadSheet registerClass:[TAXLabelCell class] forCellWithReuseIdentifier:CellIdentifier];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - TAXSpreadSheet DetaSource
    
- (NSUInteger)numberOfColumnsInSpreadSheet:(TAXSpreadSheet *)spreadSheet
{
    return _numberOfColumns;
}
    
- (NSUInteger)numberOfRowsInSpreadSheet:(TAXSpreadSheet *)spreadSheet
{
    return _numberOfRows;
}
    
- (UICollectionViewCell *)spreadSheet:(TAXSpreadSheet *)spreadSheet cellAtRow:(NSUInteger)row column:(NSUInteger)column
{
    TAXLabelCell *cell = (TAXLabelCell *)[_spreadSheet dequeueReusableCellWithReuseIdentifier:CellIdentifier forRow:row column:column];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %d", row, column];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

# pragma mark - TAXSpreadSheet Delegate

- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet widthAtColumn:(NSUInteger)column
{
    if (column == 0) {
        return _widthOfColumn0;
    } else return NSNotFound;
}

# pragma mark - Handler

- (IBAction)insertRowDidTap:(id)sender
{
    self.numberOfRows += 1;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [_spreadSheet insertRows:indexSet];
}

- (IBAction)expandColumnDidTap:(id)sender
{
    self.widthOfColumn0 += 10;
    [_spreadSheet invalidateLayout];
}

- (IBAction)moveRowDidTap:(id)sender
{
    [_spreadSheet moveRow:3 toRow:0];
}

- (IBAction)deleteRowDidTap:(id)sender
{
    self.numberOfRows -= 1;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [_spreadSheet deleteRows:indexSet];
}

- (IBAction)insertColumnDidTap:(id)sender
{
    NSRange range;
    range.location = 2;
    range.length = 2;
    self.numberOfColumns += range.length;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [_spreadSheet insertColumns:indexSet];
}

@end
