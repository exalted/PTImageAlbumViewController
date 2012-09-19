//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "PTImageAlbumViewController.h"

#import "CaptionedPhotoView.h"

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

    [self.photoAlbumView reloadData];

    // Load all thumbnails
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
    // Check in-memory cache for a previously saved image
    UIImage *image = [self.thumbnailImageCache objectWithName:[NSString stringWithFormat:@"%d", index]];
    if (image == nil) {
        // We don't have thumbnail image yet, let's download it
        NSString *source = [self.imageAlbumView sourceForThumbnailImageAtIndex:index];
        
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
    UIView<NIPagingScrollViewPage> *pageView;

    NSString *caption = [self.imageAlbumView captionForImageAtIndex:pageIndex];
    if (caption == nil || [caption length] == 0) {
        pageView = [self.photoAlbumView pagingScrollView:pagingScrollView pageViewForIndex:pageIndex];
    }
    else {
        static NSString *reuseIdentifier = @"CaptionedPhotoView";

        pageView = [pagingScrollView dequeueReusablePageWithIdentifier:reuseIdentifier];
        if (pageView == nil) {
            pageView = [[CaptionedPhotoView alloc] init];
            pageView.reuseIdentifier = reuseIdentifier;
        }

        NIPhotoScrollView *photoScrollView = (NIPhotoScrollView *)pageView;
        photoScrollView.photoScrollViewDelegate = self.photoAlbumView;
        photoScrollView.zoomingAboveOriginalSizeIsEnabled = [self.photoAlbumView isZoomingAboveOriginalSizeEnabled];

        CaptionedPhotoView *captionedView = (CaptionedPhotoView *)pageView;
        captionedView.caption = caption;
    }

    return pageView;
}

#pragma mark - NIPhotoAlbumScrollViewDataSource

- (UIImage *)photoAlbumScrollView:(NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex:(NSInteger)photoIndex
                        photoSize:(NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading:(BOOL *)isLoading
          originalPhotoDimensions:(CGSize *)originalPhotoDimensions
{
    // Let the photo album view know how large the photo will be once it's fully loaded.
    *originalPhotoDimensions = [self.imageAlbumView sizeForImageAtIndex:photoIndex];
    
    UIImage *image = [self.highQualityImageCache objectWithName:[NSString stringWithFormat:@"%d", photoIndex]];
    if (image) {
        *photoSize = NIPhotoScrollViewPhotoSizeOriginal;
    }
    else {
        NSString *source = [self.imageAlbumView sourceForImageAtIndex:photoIndex];
        
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
        image = [self loadThumbnailImageAtIndex:photoIndex];

        if (image) {
            *photoSize = NIPhotoScrollViewPhotoSizeThumbnail;
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
    abort();
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index
{
    NSAssert(NO, @"missing required method implementation 'imageAlbumView:sourceForImageAtIndex:'");
    abort();
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index
{
    NSAssert(NO, @"missing required method implementation 'imageAlbumView:sourceForThumbnailImageAtIndex:'");
    abort();
}

@end
