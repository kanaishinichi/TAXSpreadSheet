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

@end

static NSString * const CellIdentifier = @"Cell";

@implementation ViewController
{
    IBOutlet TAXSpreadSheet *_spreadSheet;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    return 10;
}
    
- (NSUInteger)numberOfRowsInSpreadSheet:(TAXSpreadSheet *)spreadSheet
{
    return 20;
}
    
- (UICollectionViewCell *)spreadSheet:(TAXSpreadSheet *)spreadSheet cellAtRow:(NSUInteger)row column:(NSUInteger)column
{
    TAXLabelCell *cell = (TAXLabelCell *)[_spreadSheet dequeueReusableCellWithReuseIdentifier:CellIdentifier forRow:row column:column];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %d", row, column];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

@end
