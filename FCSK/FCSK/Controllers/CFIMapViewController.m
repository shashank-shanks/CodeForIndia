//
//  CFIMapViewController.m
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CFIGetRoute.h"
#import "CFILocation.h"
#import "CFIShareRegionInfo.h"
#import "CFICurrentBooth.h"
#import "CFIBooth.h"

@interface CFIMapViewController ()

@property (nonatomic, strong)GMSMapView *mapView;
@property (nonatomic, strong)NSTimer *animateTimer;
@property (nonatomic, strong)NSMutableArray *locationCircleArray;

@end

@implementation CFIMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationCircleArray = [NSMutableArray array];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:30.73
                                                            longitude:79.07
                                                                 zoom:10];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.view = self.mapView;
    
    [[CFIShareRegionInfo sharedInstance].currentRegion.booths enumerateObjectsUsingBlock:^(CFIBooth *obj, NSUInteger idx, BOOL *stop) {
        
            [self addMarkerAtLatitude:[obj.latitude floatValue] Longitude:[obj.longitude floatValue] title:obj.name snippet:obj.name];
        
        if(idx == 1)
            [self addCircleAtLatitude:[obj.latitude floatValue] Longitude:[obj.longitude floatValue] circleColor:[UIColor redColor] fillColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4] circleWidth:2 radius:9000 animate:YES];
        else if (idx == 0)
            [self addCircleAtLatitude:[obj.latitude floatValue] Longitude:[obj.longitude floatValue] circleColor:[UIColor greenColor] fillColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.4] circleWidth:2 radius:9000 animate:YES];
            
    }];
    //[self addMarkerAtLatitude:12.96 Longitude:77.56 title:@"Bangalore" snippet:@"Karnataka"];
    //[self addCircleAtLatitude:12.96 Longitude:77.56 circleColor:[UIColor redColor] fillColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4] circleWidth:2 radius:50000 animate:YES];
    
    self.title = @"Map";
    
    //self.animateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(animateCircles) userInfo:nil repeats:YES];
    
    /*CFILocation *location = [[CFILocation alloc]init];
    location.latitude = @12.96;
    location.longitude = @77.56;
    
    CFILocation *location1 = [[CFILocation alloc]init];
    location1.latitude = @15.36;
    location1.longitude = @75.08;
    
    CFIGetRoute *route = [[CFIGetRoute alloc]init];
    [route getRouteFrom:location to:location1 callback:^(NSString *responseData, NSError *error, BOOL success) {
        
        GMSMutablePath *path = [GMSMutablePath pathFromEncodedPath:responseData];
        dispatch_async(dispatch_get_main_queue(), ^{
            GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
            rectangle.strokeWidth = 2.;
            rectangle.map = self.mapView;
        });
    }];*/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.animateTimer invalidate];
    self.animateTimer = nil;
}


- (void)addMarkerAtLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude title:(NSString *) title snippet:(NSString *)snippet
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = title;
    marker.snippet = snippet;
    marker.map = self.mapView;
}

- (void)addCircleAtLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude circleColor:(UIColor *)color fillColor:(UIColor *)fillcolor circleWidth:(CGFloat)width radius:(CGFloat)radius animate:(BOOL)animate
{
    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(latitude, longitude);
    GMSCircle *circle = [GMSCircle circleWithPosition:circleCenter radius:radius];
    circle.strokeColor = color;
    circle.fillColor = fillcolor;
    circle.strokeWidth = width;
    circle.map = self.mapView;
    
    //if(animate)
       //[self.locationCircleArray addObject:circle];
}

- (void)animateCircles
{
    if(!self.locationCircleArray.count)
        return;
    
    [self.locationCircleArray enumerateObjectsUsingBlock:^(GMSCircle *obj, NSUInteger idx, BOOL *stop) {
        CGFloat originalRadius = obj.radius;
        [UIView animateWithDuration:0.25 animations:^{
            obj.radius+=obj.radius;
        } completion:^(BOOL finished) {
            obj.radius = originalRadius;
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
