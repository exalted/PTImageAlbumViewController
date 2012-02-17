//
//  PTDemoViewController.m
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 17.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import "PTDemoViewController.h"

@implementation PTDemoViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photos";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    ////////////////////////////////////////////////////////////////////////////
    
    /*
     * Decide which interface orientations do you want to support (we can handle
     * them all!)
     */
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    return YES;
}

#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView
{
    return 7;
}

- (UIImage *)imageAlbumView:(PTImageAlbumView *)imageAlbumView imageAtIndex:(NSInteger)index
{
    NSArray *urls = [NSArray arrayWithObjects:
                     @"http://farm8.staticflickr.com/7053/6885649635_7d29d75a31_b.jpg",
                     @"http://farm8.staticflickr.com/7052/6859587887_2f2df80989_z.jpg",
                     @"http://farm1.staticflickr.com/188/417924629_6832e79c98_z.jpg?zz=1",
                     @"http://farm4.staticflickr.com/3338/3274183756_10411ace99_z.jpg",
                     @"http://farm8.staticflickr.com/7040/6888124857_df14f44fd7_z.jpg",
                     @"http://farm4.staticflickr.com/3503/3266055425_eed1ecc779_z.jpg",
                     @"http://farm1.staticflickr.com/10/11621713_3ac2d1c5d7_z.jpg",
                     nil];
    
    NSURL *url = [NSURL URLWithString:[urls objectAtIndex:index]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];

    return img;
}

@end
