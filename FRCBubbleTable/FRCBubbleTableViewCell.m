#import "FRCBubbleTableViewCell.h"
#import "NSBubbleData+FRC.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface UIBubbleTableViewCell()

- (void) setupInternalData;
@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;

@end

@implementation FRCBubbleTableViewCell{
    UILabel *_dateLabel;
    UILabel *_readLabel;
}

- (void) setupInternalData
{
    CGFloat addtionalHeight = [self.data additionalHeight];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
        self.bubbleImage = [[UIImageView alloc] init];
        [self addSubview:self.bubbleImage];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    
    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar && self.data.avatarUrl != nil)
    {
        [self.avatarImage removeFromSuperview];
        
        //        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatarUrl ? self.data.avatarUrl : [UIImage imageNamed:@"missingAvatar.png"])];
        [self.avatarImage setImageWithURL:[NSURL URLWithString:self.data.avatarUrl]
                         placeholderImage:[UIImage imageNamed:@"missingAvatar.png"]];
        
        self.avatarImage.layer.cornerRadius = 9.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 2 : self.frame.size.width - 52;
        CGFloat avatarY = self.frame.size.height - 50;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY + (self.data.hasAddition ? -addtionalHeight : 0), 50, 50);
        [self addSubview:self.avatarImage];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == BubbleTypeSomeoneElse) x += 54;
        if (type == BubbleTypeMine) x -= 54;
    }
    
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left,
                                       y + self.data.insets.top + (self.data.hasAddition ? -addtionalHeight : 0),
                                       width, height);
    [self.contentView addSubview:self.customView];
    
    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    }
    
    self.bubbleImage.frame = CGRectMake(x, y + (self.data.hasAddition ? -addtionalHeight : 0),
                                        width + self.data.insets.left + self.data.insets.right,
                                        height + self.data.insets.top + self.data.insets.bottom);
    
    if(self.data.groupTop){
        [self showDate];
    } else {
        [self hideDate];
    }
    
    if(self.data.showRead){
        [self showRead];
    } else {
        [self hideRead];
    }
}

- (void)showDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *text = [dateFormatter stringFromDate:self.data.date];
    
    if(_dateLabel){
        _dateLabel.text = text;
    } else {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 28)];
        _dateLabel.text = text;
        _dateLabel.font = [UIFont boldSystemFontOfSize:12];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.shadowOffset = CGSizeMake(0, 1);
        _dateLabel.shadowColor = [UIColor whiteColor];
        _dateLabel.textColor = [UIColor darkGrayColor];
        _dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_dateLabel];
        
    }

    _dateLabel.frame = CGRectMake(_dateLabel.frame.origin.x,
                                  self.customView.frame.origin.y + self.customView.frame.size.height + (self.data.showRead ? 15 : 0),
                              _dateLabel.frame.size.width,
                            _dateLabel.frame.size.height);
}

- (void)hideDate{
    if(_dateLabel){
        _dateLabel.text = @"";
    }
}

- (void)showRead
{
    if(_readLabel == nil){
        _readLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
        _readLabel.text = @"read";
        _readLabel.font = [UIFont boldSystemFontOfSize:10];
        _readLabel.textAlignment = NSTextAlignmentRight;
        _readLabel.shadowOffset = CGSizeMake(0, 1);
        _readLabel.shadowColor = [UIColor whiteColor];
        _readLabel.textColor = [UIColor darkGrayColor];
        _readLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_readLabel];
        _readLabel.frame = CGRectMake(_readLabel.frame.origin.x - 62,
                                      self.customView.frame.origin.y + self.customView.frame.size.height + 3,
                                      _readLabel.frame.size.width, _readLabel.frame.size.height);
    } else {
        _readLabel.frame = CGRectMake(_readLabel.frame.origin.x,
                                      self.customView.frame.origin.y + self.customView.frame.size.height + 3,
                                      _readLabel.frame.size.width, _readLabel.frame.size.height);
    }
}

- (void)hideRead{
    if(_readLabel){
        _readLabel.text = @"";
        _readLabel = nil;
    }
}

@end
