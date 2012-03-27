//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// This file is part of PTImageAlbumViewController.
// modify it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// PTImageAlbumViewController is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PTImageAlbumViewController. If not, see <http://www.gnu.org/licenses/>.
// PTImageAlbumViewController is free software: you can redistribute it and/or
//

#import "PTImageAlbumViewController.h"

#import "PTImageAlbumView.h"

@interface PTImageAlbumViewController () <NIPhotoAlbumScrollViewDataSource, NIPhotoScrubberViewDataSource>

@property (nonatomic, assign) NSInteger initialIndex;

- (UIImage *)loadThumbnailImageAtIndex:(NSInteger)index;

@end

@implementation PTImageAlbumViewController

@synthesize initialIndex = _initialIndex;
@synthesize imageAlbumView = _imageAlbumView;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _initialIndex = 0;
        _imageAlbumView = [[PTImageAlbumView alloc] init];
        _imageAlbumView.imageAlbumDataSource = self;
    }
    return self;
}

- (id)initWithImageAtIndex:(NSInteger)index
{
    self = [self init];
    if (self) {
        // Custom initialization
        _initialIndex = index;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Internal
    self.photoAlbumView.dataSource = self;
    self.photoScrubberView.dataSource = self;
    
    // Set the default loading image
    self.photoAlbumView.loadingImage = [UIImage imageWithContentsOfFile:
                                        NIPathForBundleResource(nil, @"NimbusPhotos.bundle/gfx/default.png")];

    [self.imageAlbumView reloadData];
    [self.photoAlbumView reloadData];

    // Load all thumbnails
    for (NSInteger i = 0; i < [self.imageAlbumView numberOfImages]; i++) {
        [self loadThumbnailImageAtIndex:i];
    }
    [self.photoScrubberView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.initialIndex > 0) {
        [self.photoAlbumView moveToPageAtIndex:self.initialIndex animated:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.imageAlbumView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return interfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
    
    return YES;
}

#pragma mark - Private

- (UIImage *)loadThumbnailImageAtIndex:(NSInteger)index
{
    NSString *photoIndexKey = [NSString stringWithFormat:@"%d", index];
    
    UIImage *image = [self.highQualityImageCache objectWithName:photoIndexKey];
    if (image == nil) {
        NSString *source = [self.imageAlbumView thumbnailSourceForImageAtIndex:index];

        // TODO remove duplicate
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        NSURL *url = nil;
        
        // Check for file URLs.
        if ([source hasPrefix:@"/"]) {
            // If the url starts with / then it's likely a file URL, so treat it accordingly.
            url = [NSURL fileURLWithPath:source];
        }
        else {
            // Otherwise we assume it's a regular URL.
            url = [NSURL URLWithString:source];
        }
        // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        [self requestImageFromSource:[url absoluteString]
                           photoSize:NIPhotoScrollViewPhotoSizeThumbnail
                          photoIndex:index];
    }
    
    return image;
}

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView
{
    return [self.imageAlbumView numberOfImages];
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex
{
    // TODO enhance by replacing it with a captioned photo view
    return [self.photoAlbumView pagingScrollView:pagingScrollView pageViewForIndex:pageIndex];
}

#pragma mark - NIPhotoAlbumScrollViewDataSource

- (UIImage *)photoAlbumScrollView:(NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex:(NSInteger)photoIndex
                        photoSize:(NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading:(BOOL *)isLoading
          originalPhotoDimensions:(CGSize *)originalPhotoDimensions
{
    // Let the photo album view know how large the photo will be once it's fully loaded.
    *originalPhotoDimensions = [self.imageAlbumView originalSizeForImageAtIndex:photoIndex];
    
    NSString *photoIndexKey = [NSString stringWithFormat:@"%d", photoIndex];
    
    UIImage *image = [self.highQualityImageCache objectWithName:photoIndexKey];
    if (image) {
        *photoSize = NIPhotoScrollViewPhotoSizeOriginal;
    }
    else {
        NSString *source = [self.imageAlbumView originalSourceForImageAtIndex:photoIndex];

        // TODO remove duplicate
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        NSURL *url = nil;
        
        // Check for file URLs.
        if ([source hasPrefix:@"/"]) {
            // If the url starts with / then it's likely a file URL, so treat it accordingly.
            url = [NSURL fileURLWithPath:source];
        }
        else {
            // Otherwise we assume it's a regular URL.
            url = [NSURL URLWithString:source];
        }
        // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        [self requestImageFromSource:[url absoluteString]
                           photoSize:NIPhotoScrollViewPhotoSizeOriginal
                          photoIndex:photoIndex];
        *isLoading = YES;

        // Try to return the thumbnail image if we can.
        image = [self.thumbnailImageCache objectWithName:photoIndexKey];
        if (image) {
            *photoSize = NIPhotoScrollViewPhotoSizeThumbnail;
        }
        else {
            // Load the thumbnail as well.
            
            NSString *source = [self.imageAlbumView thumbnailSourceForImageAtIndex:photoIndex];

            // TODO remove duplicate
            // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            NSURL *url = nil;
            
            // Check for file URLs.
            if ([source hasPrefix:@"/"]) {
                // If the url starts with / then it's likely a file URL, so treat it accordingly.
                url = [NSURL fileURLWithPath:source];
            }
            else {
                // Otherwise we assume it's a regular URL.
                url = [NSURL URLWithString:source];
            }
            // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            
            [self requestImageFromSource:[url absoluteString]
                               photoSize:NIPhotoScrollViewPhotoSizeThumbnail
                              photoIndex:photoIndex];
        }
    }
    
    return image;
}

- (void)photoAlbumScrollView:(NIPhotoAlbumScrollView *)photoAlbumScrollView stopLoadingPhotoAtIndex:(NSInteger)photoIndex
{
    for (NIOperation *op in self.queue.operations) {
        if (op.tag == photoIndex) {
            [op cancel];
            
            [self didCancelRequestWithPhotoSize:NIPhotoScrollViewPhotoSizeOriginal
                                     photoIndex:photoIndex];
        }
    }
}

#pragma mark - NIPhotoScrubberViewDataSource

- (NSInteger)numberOfPhotosInScrubberView:(NIPhotoScrubberView *)photoScrubberView
{
    return [self.imageAlbumView numberOfImages];
}

- (UIImage *)photoScrubberView:(NIPhotoScrubberView *)photoScrubberView thumbnailAtIndex:(NSInteger)thumbnailIndex
{
    return [self loadThumbnailImageAtIndex:thumbnailIndex];
}

#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView
{
    NSAssert(NO, @"missing required method implementation 'numberOfItemsInImageAlbumView:'");
    return -1;
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index
{
    NSAssert(NO, @"missing required method implementation 'imageAlbumView:sourceForImageAtIndex:'");
    return nil;
}

- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index
{
    NSAssert(NO, @"missing required method implementation 'imageAlbumView:sizeForImageAtIndex:'");
    return CGSizeZero;
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index
{
    NSAssert(NO, @"missing required method implementation 'imageAlbumView:sourceForThumbnailImageAtIndex:'");
    return nil;
}

@end
