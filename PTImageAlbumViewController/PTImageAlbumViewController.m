//
//  PTImageAlbumViewController.m
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 16.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import "PTImageAlbumViewController.h"

#import "PTImageAlbumView.h"

@interface PTImageAlbumViewController () <NIPhotoAlbumScrollViewDataSource>

@end

@implementation PTImageAlbumViewController

@synthesize imageAlbumView = _imageAlbumView;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _imageAlbumView = [[PTImageAlbumView alloc] init];
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
    
    self.imageAlbumView.imageAlbumDataSource = self;
    
    // Internal
    self.photoAlbumView.dataSource = self;

    self.scrubberIsEnabled = NO;

    // Set the default loading image.
    self.photoAlbumView.loadingImage = [UIImage imageWithContentsOfFile:
                                        NIPathForBundleResource(nil, @"NimbusPhotos.bundle/gfx/default.png")];
    
    [self.photoAlbumView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - NIPhotoAlbumScrollViewDataSource

- (UIImage *)photoAlbumScrollView:(NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex:(NSInteger)photoIndex
                        photoSize:(NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading:(BOOL *)isLoading
          originalPhotoDimensions:(CGSize *)originalPhotoDimensions
{
    UIImage *img = [self.imageAlbumView.imageAlbumDataSource imageAlbumView:self.imageAlbumView imageAtIndex:photoIndex];
    
    *originalPhotoDimensions = CGSizeMake(img.size.width, img.size.height);
    *photoSize = NIPhotoScrollViewPhotoSizeOriginal;

    return img;
}

/*
- (void)photoAlbumScrollView:(NIPhotoAlbumScrollView *)photoAlbumScrollView stopLoadingPhotoAtIndex:(NSInteger)photoIndex
{
}
*/

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView
{
    return [self.imageAlbumView.imageAlbumDataSource numberOfImagesInAlbumView:self.imageAlbumView];
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex
{
    // TODO enhance by replacing it with a captioned photo view
    return [self.photoAlbumView pagingScrollView:pagingScrollView pageViewForIndex:pageIndex];
}

#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView
{
    NSAssert(NO, @"missing required method implementation 'numberOfItemsInImageAlbumView:'");
    return -1;
}

- (UIImage *)imageAlbumView:(PTImageAlbumView *)imageAlbumView imageAtIndex:(NSInteger)index
{
    NSAssert(NO, @"missing required method implementation 'imageAlbumView:imageAtIndex:'");
    return nil;
}

@end
