#import "NSBubbleData.h"

@interface NSBubbleData (FRC)

@property (nonatomic) BOOL groupTop;
@property (nonatomic) BOOL read;
@property (nonatomic) BOOL showRead;
@property (nonatomic) NSString *avatarUrl;

- (float)additionalHeight;
- (float)heightForSelf;
- (BOOL) hasAddition;
- (float)originalHeightForSelf;

@end
