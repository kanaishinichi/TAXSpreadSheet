TAXSpreadSheet
============
A view that display cells like spreadsheet.

![Screen Shot](http://flic.kr/p/h51caQ)

##Requirements

 iOS 6.0 or later

##Installation
via CocoaPods

```Podfile
pod 'TAXSpreadSheet'
```

##Usage

Import header

```objectivec
#import "TAXSpreadSheet.h"
```

Instantiate TAXSpreadSheet and register UICollectionViewCell or subclass for cells the same as UICollectionView.

```objectivec
TAXSpreadSheet *spreadSheet = [[TAXSpreadSheet alloc] initWithFrame:CGRectMake(0.0. 0.0. 100.0, 100.0)];
[spreadSheet registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
```
Set DataSource and Delegate objects and implement those methods.

```objectivec
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
    UICollectionViewCell *cell = [spreadSheet dequeueReusableCellWithReuseIdentifier:@"Cell" forRow:row column:column];

    // Customize cells.

    return cell;
}
```
You should return dequeued UICollectionViewCell subclass from SpreadSheet in ```spreadSheet:cellAtRow:column```

##Customize

###Specifying individual metrics
You can specify individual heights of row, width of column, inter-row/column spacing by implementing delegate methods.
In case of using default value, return NSNotFound.

```objectivec
- (CGFloat)spreadSheet:(TAXSpreadSheet *)spreadSheet heightAtRow:(NSUInteger)row
{
	if (row == 0) {
		return 100.0;
	} else {
		return 50.0;
	}
}
```

###Use custom views for inter-row/column.
You can use custom UICollectionReusableView subclass for inter-row/column by implementing delegate methods.
You should register class and dequeue view from SpreadSheet.
In case of not using view, return nil.

```objectivec
- (UICollectionReusableView *)spreadSheet:(TAXSpreadSheet *)spreadSheet interRowViewBelowRow:(NSUInteger)row
{
	if (row == 0) {
		UICollectionReusableView *view = [spreadSheet dequeueReusableInterRowViewWithIdentifier:@"View" belowRow:row];
		return view;
	} else {
		return nil;
	}
}
```

##License

MIT License