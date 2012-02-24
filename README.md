Intro
=====

Not much to see here, don't hold your breath until a good ol' README comes up! ;-)

Example Screenshots
===================

A nice image scrubber, just like in Photos.app by Apple on the iPad.

![A nice image scrubber, just like in Photos.app by Apple on the iPad.](http://exalted.github.com/PTImageAlbumViewController/ss-00.png "A nice image scrubber, just like in Photos.app by Apple on the iPad.")

One tap on the screen and all the chrome goes away!

![One tap on the screen and all the chrome goes away!](http://exalted.github.com/PTImageAlbumViewController/ss-01.png "One tap on the screen and all the chrome goes away!")

Double tap to fit to screen by zooming in...

![Double tap to fit to screen by zooming in...](http://exalted.github.com/PTImageAlbumViewController/ss-02.png "Double tap to fit to screen by zooming in...")

Flip from one image to another with multi–touch gestures you already know and love.

![Flip from one image to another with multi–touch gestures you already know and love.](http://exalted.github.com/PTImageAlbumViewController/ss-03.png "Flip from one image to another with multi–touch gestures you already know and love.")

Pinch to zoom in and out to take a much closer look.

![Pinch to zoom in and out to take a much closer look.](http://exalted.github.com/PTImageAlbumViewController/ss-04.png "Pinch to zoom in and out to take a much closer look.")

How To Make It All Work
=======================

```bash
$ cd <somewhere>
$ git clone git://github.com/exalted/PTImageAlbumViewController.git PTImageAlbumViewController-exalted
$ cd PTImageAlbumViewController-exalted/
$ git submodule init
$ git submodule update
$ open Examples/AlbumDemo/AlbumDemo.xcodeproj
```

Easy As A Roller Coaster ;-)
============================

1. Create a new subclass of `PTImageAlbumViewController`, say `YourAwesomeViewController`
2. Implement `PTImageAlbumViewDataSource`
  * Number of images
  * Path or URL for each of'em (high–definition and thumbnail)
  * Size (width & height) for high–definition images

```objective-c
// YourAwesomeViewController.h

#import "PTImageAlbumViewController.h"

@interface YourAwesomeViewController : PTImageAlbumViewController

// ...

@end
```

```objective-c
// YourAwesomeViewController.m

#import "YourAwesomeViewController.h"

@implementation PTDemoViewController

//...

#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView {
    #warning missing implementation
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index {
    #warning missing implementation
}

- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index {
    #warning missing implementation
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index {
    #warning missing implementation
}

//...

@end
```
