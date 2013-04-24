//
//  StatsViewController.m
//  PointTracker
//
//  Created by Andrew Moore on 4/17/13.
//  Copyright (c) 2013 SE4910I. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

#define BAR_POSITION @"POSITION"
#define BAR_HEIGHT @"HEIGHT"
#define COLOR @"COLOR"
#define CATEGORY @"CATEGORY"

#define AXIS_START 0
#define AXIS_END 50

CGFloat const CPTBarInitialX = 1;
CPTColor *colors[10];
NSNumber *maxPoints = 0;
NSNumber *minPoints = 0;

@synthesize data = _data;
@synthesize graph = _graph;
@synthesize hostingView = _hostingView;
@synthesize annotation = _annotation;
@synthesize loadingIndicator = _loadingIndicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        self.tabBarItem.image = [UIImage imageNamed:@"Stats"];
        [self createColors];
        [self refreshPlot];
    }
    
    
    return self;
}

-(void)createColors
{
    colors[0] = [CPTColor redColor];
    colors[1] = [CPTColor blueColor];
    colors[2] = [CPTColor yellowColor];
    colors[3] = [CPTColor purpleColor];
    colors[4] = [CPTColor orangeColor];
    colors[5] = [CPTColor greenColor];
    colors[6] = [CPTColor colorWithComponentRed:arc4random() % 250
                                          green:arc4random() % 250
                                           blue:arc4random() % 250
                                          alpha:1];
    colors[7] = [CPTColor colorWithComponentRed:arc4random() % 250
                                          green:arc4random() % 250
                                           blue:arc4random() % 250
                                          alpha:1];
    colors[8] = [CPTColor colorWithComponentRed:arc4random() % 250
                                          green:arc4random() % 250
                                           blue:arc4random() % 250
                                          alpha:1];
    colors[9] = [CPTColor colorWithComponentRed:arc4random() % 250
                                          green:arc4random() % 250
                                           blue:arc4random() % 250
                                          alpha:1];
    
}

-(void)refreshPlot
{
    [_loadingIndicator startAnimating];
    dispatch_queue_t thread = dispatch_queue_create(nil, NULL);
    dispatch_async(thread, ^{
        [self getData];
        [self generateBarPlot];
        [_loadingIndicator stopAnimating];
    });

}

/**
 * This method is querying the table with non-blocking gets. You should probably
 * use this method only when already in another thread.
 */
-(void)getData
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"People"];
    [query orderByDescending:@"points"];
    query.limit = 10;
    _data = [query findObjects];
    if([_data count] > 0)
    {
        maxPoints = [[_data objectAtIndex:0] objectForKey:@"points"];
        minPoints = [[_data objectAtIndex:[_data count]-1] objectForKey:@"points"];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generateBarPlot
{
    [self prepareGraph];
    
    [self configurePlotArea];
    
    [self configureAxes];
    
    [self configurePlot];
}

-(void)prepareGraph
{
    //Create host view
    self.hostingView = [[CPTGraphHostingView alloc]
                        initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view addSubview:self.hostingView];
    
    
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.hostingView.bounds];
    self.graph.delegate = self;
    [self.hostingView setHostedGraph:self.graph];
    
}

-(void)configurePlotArea{
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = 25.0f;
    self.graph.plotAreaFrame.paddingRight = 5.0f;
    self.graph.plotAreaFrame.paddingBottom = 10.0f;
    self.graph.plotAreaFrame.paddingLeft = 10.0f;
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    
    //set axes ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    int temp = _data.count;
    plotSpace.xRange = [CPTPlotRange
                        plotRangeWithLocation:CPTDecimalFromFloat(AXIS_START)
                        length:CPTDecimalFromInt(temp + CPTBarInitialX)];
    plotSpace.yRange = [CPTPlotRange
                        plotRangeWithLocation:CPTDecimalFromFloat(AXIS_START)
                        length:CPTDecimalFromInt([maxPoints intValue])];
    
}

-(void)configureAxes
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    //set axes' title, labels and their text styles
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 14;
    textStyle.color = [CPTColor whiteColor];
    axisSet.xAxis.title = @"";
    axisSet.yAxis.title = @"";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = 10.0f;
    axisSet.yAxis.titleOffset = 40.0f;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 3.0f;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 3.0f;
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(0);
    axisSet.xAxis.majorTickLength = 0;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTicksPerInterval = 0;
    axisSet.xAxis.minorTickLength = 0;
    
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(0);
    axisSet.yAxis.majorTickLength = 0;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTicksPerInterval = 0;
    axisSet.yAxis.minorTickLength = 0;
}

-(void)configurePlot
{
    // Create bar plot and add it to the graph
    CPTBarPlot *plot = [[CPTBarPlot alloc] init] ;
    plot.dataSource = self;
    plot.delegate = self;
    plot.barWidth = [[NSDecimalNumber decimalNumberWithString:@"1.0"]
                     decimalValue];
    plot.barOffset = CPTDecimalFromDouble(CPTBarInitialX);
    plot.barCornerRadius = 5.0;
    // Remove bar outlines
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor clearColor];
    plot.lineStyle = borderLineStyle;
    // Identifiers are handy if you want multiple plots in one graph
    plot.identifier = @"top10";
    
    [self.graph addPlot:plot];
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot.identifier isEqual:@"top10"] )
        return [self.data count];
    
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual:@"top10"] )
    {
        PFObject *person = [self.data objectAtIndex:index];
        
        if(fieldEnum == CPTBarPlotFieldBarLocation)
            return [NSNumber numberWithInt:index];
        else if(fieldEnum ==CPTBarPlotFieldBarTip)
            return [person objectForKey:@"points"];
    }
    return [NSNumber numberWithFloat:0];
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    if ( [barPlot.identifier isEqual:@"top10"] )
    {
        CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor]
                                                            endingColor:colors[index]
                                                      beginningPosition:0.0 endingPosition:0.3 ];
        [gradient setGradientType:CPTGradientTypeAxial];
        [gradient setAngle:320.0];
        
        CPTFill *fill = [CPTFill fillWithGradient:gradient];
        
        return fill;
        
    }
    return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
}



#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    if (_annotation)
    {
        [_graph.plotAreaFrame.plotArea removeAnnotation:_annotation];
        _annotation = nil;
    }
    
    CPTMutableTextStyle *annotationTextStyle = [CPTMutableTextStyle textStyle];
    annotationTextStyle.color = [CPTColor whiteColor];
    annotationTextStyle.fontSize = 12.0f;
    annotationTextStyle.fontName = @"Helvetica";
    
    PFObject *person = [self.data objectAtIndex:index];
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[self constructNameAndPointsString:person]
                                                       style:annotationTextStyle];
    // 7 - Get the anchor point for annotation
    CGFloat x = index + CPTBarInitialX;
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = [[person objectForKey:@"points"] floatValue] + [maxPoints floatValue]/100 + 1;
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    _annotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    
    NSArray *anchorPoint = [NSArray arrayWithObjects: anchorX, anchorY, nil];
    
    _annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:_graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    _annotation.contentLayer = label;
    _annotation.displacement = CGPointMake(0.0f, 0.0f);
    [_graph.plotAreaFrame.plotArea addAnnotation:_annotation];

    
}

-(NSString*)constructNameAndPointsString:(PFObject*) person
{
    NSString *nameAndPoints = [person objectForKey:@"firstName"];
    nameAndPoints = [nameAndPoints
                     stringByAppendingFormat:(@" %@, %@"),
                     [person objectForKey:@"lastName"],
                     [person objectForKey:@"points"]];
    return nameAndPoints;
}



@end
