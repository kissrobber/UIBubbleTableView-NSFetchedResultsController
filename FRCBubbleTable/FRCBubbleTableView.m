#import "FRCBubbleTableView.h"
#import "NSBubbleData+FRC.h"
#import "FRCBubbleTableViewCell.h"

@interface FRCBubbleTableView()<NSFetchedResultsControllerDelegate>

@property (nonatomic) BOOL showAvatars;
@property (nonatomic) int snapInterval;
@property (nonatomic, assign) FRCBubbleTableConverterBlock converter;
@property (nonatomic, assign) NSFetchRequest *fetchRequest;
@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;

@end

@implementation FRCBubbleTableView{
    NSFetchedResultsController *_fetchedResultsController;
}

#pragma mark - Initializators

- (void)initializator
{
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[FRCBubbleTableViewCell class] forCellReuseIdentifier:@"FRCBubbleTableViewCell"];
    self.dataSource = self;
    self.delegate = self;
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}

- (void)configureWithSnapInterval:(int)interval showAvatars:(BOOL)showAvatars converter:(FRCBubbleTableConverterBlock)converter  managedObjectContext:(NSManagedObjectContext*)managedObjectContext fetchRequest:(NSFetchRequest*)fetchRequest
{
    self.showAvatars = showAvatars;
    self.snapInterval = interval;
    self.converter = converter;
    self.fetchRequest = fetchRequest;
    self.managedObjectContext = managedObjectContext;

    _fetchedResultsController = [self fetchedResultsController];
    NSError *error;
	if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
	}
    [self scrollBubbleViewToBottomAnimated:NO];
}

#pragma mark - Table view

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfMessages];
}

- (void)configureCell:(UIBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.showAvatar = YES;
    NSBubbleData* data = [self dataForRowAtIndexPath:indexPath];
    cell.data = data;
}

- (NSBubbleData*) dataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id message = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSBubbleData *data = self.converter(message);
    if(indexPath.row > 0){
        NSBubbleData *preMessage = self.converter([_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]]);
        data.groupTop = [data.date timeIntervalSinceDate:preMessage.date] > self.snapInterval;
        
        if(data.type == BubbleTypeMine){
            BOOL read;
            if(indexPath.row == [self numberOfMessages] - 1){
                read = data.read;
            } else {
                NSBubbleData *nextMessage = nil;
                long idx = indexPath.row;
                do {
                    nextMessage = self.converter([_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:idx + 1 inSection:indexPath.section]]);
                    if(nextMessage.type == BubbleTypeSomeoneElse){
                        nextMessage = nil;
                    }
                    idx++;
                } while (nextMessage == nil && idx < [self numberOfMessages] - 1);
                
                read = (nextMessage == nil || (nextMessage != nil && !nextMessage.read)) && data.read;
            }
            data.showRead = read;
        }
    }
    return data;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSBubbleData *data = [self dataForRowAtIndexPath:indexPath];;
    return [data heightForSelf];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FRCBubbleTableViewCell";
    UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma fetch results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self scrollBubbleViewToBottomAnimated:YES];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}

- (unsigned long)numberOfMessages
{
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}

#pragma mark - Public interface

- (void) scrollBubbleViewToBottomAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:[self numberOfMessages] - 1 inSection: 0];
        [self scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    });
}


@end
