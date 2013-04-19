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

@synthesize data;
@synthesize graph;
@synthesize hostingView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        self.tabBarItem.image = [UIImage imageNamed:@"Stats"];
        self.data = [NSMutableArray array];
        
        int bar_heights[] = {20,30,10,40};
        UIColor *colors[] = {
            [UIColor redColor],
            [UIColor blueColor],
            [UIColor orangeColor],
            [UIColor purpleColor]};
        NSString *categories[] = {@"Plain Milk", @"Milk + Caramel", @"White", @"Dark"};
        
        for (int i = 0; i < 4 ; i++){
            double position = i*10; //Bars will be 10 pts away from each other
            double height = bar_heights[i];
            
            NSDictionary *bar = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithDouble:position],BAR_POSITION,
                                 [NSNumber numberWithDouble:height],BAR_HEIGHT,
                                 colors[i],COLOR,
                                 categories[i],CATEGORY,
                                 nil];
            [self.data addObject:bar];
            
        }
        [self generateBarPlot];
    }
    return self;
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
    
    // Create bar plot and add it to the graph
    CPTBarPlot *plot = [[CPTBarPlot alloc] init] ;
    plot.dataSource = self;
    plot.delegate = self;
    plot.barWidth = [[NSDecimalNumber decimalNumberWithString:@"5.0"]
                     decimalValue];
    plot.barOffset = [[NSDecimalNumber decimalNumberWithString:@"10.0"]
                      decimalValue];
    plot.barCornerRadius = 5.0;
    // Remove bar outlines
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor clearColor];
    plot.lineStyle = borderLineStyle;
    // Identifiers are handy if you want multiple plots in one graph
    plot.identifier = @"chocoplot";
    [self.graph addPlot:plot];
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
    self.graph.plotAreaFrame.paddingTop = 15.0f;
    self.graph.plotAreaFrame.paddingRight = 5.0f;
    self.graph.plotAreaFrame.paddingBottom = 10.0f;
    self.graph.plotAreaFrame.paddingLeft = 40.0f;
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    
    //set axes ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat((AXIS_END - AXIS_START)+5)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat((AXIS_END - AXIS_START)+5)];
    
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
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 3.0f;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(0);
    axisSet.xAxis.majorTickLength = 0;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTicksPerInterval = 0;
    axisSet.xAxis.minorTickLength = 0;
    
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(5.0f);
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 5.0f;
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot.identifier isEqual:@"chocoplot"] )
        return [self.data count];
    
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual:@"chocoplot"] )
    {
        NSDictionary *bar = [self.data objectAtIndex:index];
        
        if(fieldEnum == CPTBarPlotFieldBarLocation)
            return [bar valueForKey:BAR_POSITION];
        else if(fieldEnum ==CPTBarPlotFieldBarTip)
            return [bar valueForKey:BAR_HEIGHT];
    }
    return [NSNumber numberWithFloat:0];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual: @"chocoplot"] )
    {
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontName = @"Helvetica";
        textStyle.fontSize = 14;
        textStyle.color = [CPTColor whiteColor];
        
        NSDictionary *bar = [self.data objectAtIndex:index];
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@", [bar valueForKey:@"CATEGORY"]]];
        label.textStyle =textStyle;
        
        return label;
    }
    
    CPTTextLayer *defaultLabel = [[CPTTextLayer alloc] initWithText:@"Label"];
    return defaultLabel;
    
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    if ( [barPlot.identifier isEqual:@"chocoplot"] )
    {
        NSDictionary *bar = [self.data objectAtIndex:index];
        CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor]
                                                            endingColor:[bar valueForKey:@"COLOR"]
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
    
}


@end
