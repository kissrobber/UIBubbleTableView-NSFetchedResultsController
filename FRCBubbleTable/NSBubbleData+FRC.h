#import "NSBubbleData.h"

@interface NSBubbleData (FRC)

@property (nonatomic, assign) BOOL groupTop;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, assign) BOOL showRead;
@property (nonatomic, assign) NSString *avatarUrl;

- (float)additionalHeight;
- (float)heightForSelf;
- (BOOL) hasAddition;
- (float)originalHeightForSelf;

@end
