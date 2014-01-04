#import "NSBubbleData+FRC.h"
#import <objc/runtime.h>

static void *NSBubbleDataFRCGroupTopKey;
static void *NSBubbleDataFRCReadKey;
static void *NSBubbleDataFRCShowReadKey;
static void *NSBubbleDataFRCAvatarUrlKey;

@implementation NSBubbleData (FRC)

-(void) setGroupTop:(BOOL)groupTop{
    objc_setAssociatedObject(self, &NSBubbleDataFRCGroupTopKey, [NSNumber numberWithBool:groupTop], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL) groupTop{
    return [objc_getAssociatedObject(self, &NSBubbleDataFRCGroupTopKey) boolValue];
}

-(void) setRead:(BOOL)read{
    objc_setAssociatedObject(self, &NSBubbleDataFRCReadKey, [NSNumber numberWithBool:read], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL) read{
    return [objc_getAssociatedObject(self, &NSBubbleDataFRCReadKey) boolValue];
}

-(void) setShowRead:(BOOL)showRead{
    objc_setAssociatedObject(self, &NSBubbleDataFRCShowReadKey, [NSNumber numberWithBool:showRead], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL) showRead{
    return [objc_getAssociatedObject(self, &NSBubbleDataFRCShowReadKey) boolValue];
}

-(void) setAvatarUrl:(NSString *)avatarUrl{
    objc_setAssociatedObject(self, &NSBubbleDataFRCAvatarUrlKey, avatarUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *) avatarUrl{
    return objc_getAssociatedObject(self, &NSBubbleDataFRCAvatarUrlKey);
}

-(BOOL) hasAddition
{
    return self.groupTop || self.read;
}

- (float)additionalHeight
{
    CGFloat height = 0;
    if(self.groupTop){
        height += 20;
    }
    if(self.read){
        height += 15;
    }
    return height;
}

- (float)originalHeightForSelf
{
    return MAX(self.insets.top + self.view.frame.size.height + self.insets.bottom, self.avatarUrl != nil ? 52 : 0);
}

- (float)heightForSelf
{
    CGFloat height = [self originalHeightForSelf];
    return height + [self additionalHeight];
}

@end
