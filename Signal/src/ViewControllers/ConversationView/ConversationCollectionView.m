//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

#import "ConversationCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

@implementation ConversationCollectionView

- (void)setFrame:(CGRect)frame
{
    if (frame.size.width == 0 || frame.size.height == 0) {
        // Ignore iOS Auto Layout's tendency to temporarily zero out the
        // frame of this view during the layout process.
        //
        // The conversation view has an invariant that the collection view
        // should always have a "reasonable" (correct width, non-zero height)
        // size.  This lets us manipulate scroll state at all times, especially
        // before the view has been presented for the first time.  This
        // invariant also saves us from needing all sorts of ugly and incomplete
        // hacks in the conversation view's code.
        return;
    }
    BOOL isChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    if (isChanging) {
        [self.layoutDelegate collectionViewWillChangeLayout];
    }
    [super setFrame:frame];
    if (isChanging) {
        [self.layoutDelegate collectionViewDidChangeLayout];
    }
}

- (void)setBounds:(CGRect)bounds
{
    if (bounds.size.width == 0 || bounds.size.height == 0) {
        // Ignore iOS Auto Layout's tendency to temporarily zero out the
        // frame of this view during the layout process.
        //
        // The conversation view has an invariant that the collection view
        // should always have a "reasonable" (correct width, non-zero height)
        // size.  This lets us manipulate scroll state at all times, especially
        // before the view has been presented for the first time.  This
        // invariant also saves us from needing all sorts of ugly and incomplete
        // hacks in the conversation view's code.
        return;
    }
    BOOL isChanging = !CGSizeEqualToSize(bounds.size, self.bounds.size);
    if (isChanging) {
        [self.layoutDelegate collectionViewWillChangeLayout];
    }
    [super setBounds:bounds];
    if (isChanging) {
        [self.layoutDelegate collectionViewDidChangeLayout];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    if (self.contentSize.height < 1 && CGPointEqualToPoint(CGPointZero, contentOffset)) {
        // [UIScrollView _adjustContentOffsetIfNecessary] resets the content
        // offset to zero under a number of undocumented conditions.  We don't
        // want this behavior; we want fine-grained control over the default
        // scroll state of the message view.
        //
        // [UIScrollView _adjustContentOffsetIfNecessary] is called in
        // response to many different events; trying to prevent them all is
        // whack-a-mole.
        //
        // It's not safe to override [UIScrollView _adjustContentOffsetIfNecessary],
        // since its a private API.
        //
        // We can avoid the issue by simply ignoring attempt to reset the content
        // offset to zero before the collection view has determined its content size.
        return;
    }

    [super setContentOffset:contentOffset];
}

- (void)reloadData
{
    DDLogVerbose(@"%@ reloadData", self.logTag);
    [super reloadData];
}

- (void)reloadSections:(NSIndexSet *)sections
{
    DDLogVerbose(@"%@ reloadSections", self.logTag);
    [super reloadSections:sections];
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    DDLogVerbose(@"%@ reloadItemsAtIndexPaths", self.logTag);
    [super reloadItemsAtIndexPaths:indexPaths];
}

#pragma mark - Logging

+ (NSString *)logTag
{
    return [NSString stringWithFormat:@"[%@]", self.class];
}

- (NSString *)logTag
{
    return self.class.logTag;
}

@end

NS_ASSUME_NONNULL_END
