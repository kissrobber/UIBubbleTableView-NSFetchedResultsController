#import <UIKit/UIKit.h>

#import "UIBubbleTableView.h"
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData+FRC.h"

typedef NSBubbleData* (^FRCBubbleTableConverterBlock)(id);

@interface FRCBubbleTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

- (void) scrollBubbleViewToBottomAnimated:(BOOL)animated;
- (void) configureWithSnapInterval:(int)interval
                       showAvatars:(BOOL)showAvatars
                         converter:(FRCBubbleTableConverterBlock)converter
                       managedObjectContext:(NSManagedObjectContext*)managedObjectContext
                      fetchRequest:(NSFetchRequest*)fetchRequest;

@end
