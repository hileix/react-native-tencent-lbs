//
//  RNTQMap.m
//  newColleagueLatest
//
//  Created by 肖磊 on 2023/9/3.
//

#import <React/RCTComponent.h>
#import <MapKit/MapKit.h>
#import <React/RCTViewManager.h>
#import "RNTQMapView.h"
#import <QMapKit/QMapKit.h>
#import <QMapKit/QMSSearchKit.h>
#import <UIKit/UIKit.h>
#import <React/RCTUIManager.h>

@interface RNTQMapManager : RCTViewManager <QMapViewDelegate>
@end


@implementation RNTQMapManager

// 导出 QMap UI 组件，在 RN 中，这样可以通过 <QMap /> 渲染地图
RCT_EXPORT_MODULE(RNTQMap);

// 地图自带的 showsCompass 属性
RCT_EXPORT_VIEW_PROPERTY(showsCompass, BOOL)

// 开启定位并展示位置图标
RCT_EXPORT_VIEW_PROPERTY(showsUserLocation, BOOL)

// 自定义属性：logoScale，控制 logo 的缩放
RCT_CUSTOM_VIEW_PROPERTY(logoScale, float, QMapView)
{
  [view setLogoScale:json ? [RCTConvert float:json] : 0.7]; // 缩放有效范围：0.7~1.3
};

// 自定义属性：center，控制中心点的位置。
RCT_CUSTOM_VIEW_PROPERTY(center, NSDictionary, QMapView)
{
  NSNumber *latitude = json[@"lat"];
  NSNumber *longitude = json[@"lon"];
  [view setCenterCoordinate:CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue) animated:YES];
}

// 自定义属性：点标记，可以绘制多个点标记
RCT_CUSTOM_VIEW_PROPERTY(annotations, NSArray, QMapView)
{
  for (NSDictionary *point in json) {
    NSNumber *latitude = point[@"lat"];
    NSNumber *longitude = point[@"lon"];
    
    NSString *title = point[@"title"];
    NSString *subTitle = point[@"subTitle"];
    
    QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
    // 点标记经纬度
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    // 点标注的标题
    pointAnnotation.title = title;
    // 副标题
    pointAnnotation.subtitle = subTitle;
    
    [view addAnnotation:pointAnnotation];
  }
}
// 实现<QMapViewDelegate>协议的mapView:viewForAnnotation:方法，创建点标注：https://lbs.qq.com/mobile/iOSMapSDK/mapGuide/overlayAnnotation
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *annotationIdentifier = @"pointAnnotation";
        QPinAnnotationView *pinView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pinView == nil) {
            pinView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            pinView.canShowCallout = YES;
        }
        
        return pinView;
    }
    
    return nil;
}

// 自定义属性：绘制圆形，可以绘制多个圆形
RCT_CUSTOM_VIEW_PROPERTY(circles, NSArray, QMapView)
{
  for (NSDictionary *point in json) {
    NSNumber *latitude = point[@"lat"];
    NSNumber *longitude = point[@"lon"];
    NSNumber *radius = point[@"radius"];
    QCircle *circle = [QCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue) radius:radius.floatValue];

    [view addOverlay:circle];
  }
}
// 实现<QMapViewDelegate>的mapView: viewForOverlay:方法，创建QCircleView：https://lbs.qq.com/mobile/iOSMapSDK/mapGuide/overlayPolygon
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QCircle class]])
    {
        QCircleView *circleView = [[QCircleView alloc] initWithCircle:overlay];
        circleView.lineWidth   = 1;
        circleView.strokeColor = [UIColor colorWithRed:.2 green:.1 blue:.1 alpha:.8];
        circleView.fillColor   = [[UIColor greenColor] colorWithAlphaComponent:0.2];
        
        return circleView;
    }
    
    return nil;
}

- (UIView *)view
{
    RNTQMapView* mapView = [RNTQMapView new];
    mapView.delegate = self; // 设置 delegate

    return mapView;
}

#pragma mark - Delegate


RCT_EXPORT_VIEW_PROPERTY(onMapViewAuthenticationDidComplete, RCTBubblingEventBlock)
- (void)mapViewAuthenticationDidComplete:(RNTQMapView *)mapView
{
  if (mapView.onMapViewAuthenticationDidComplete) {
    mapView.onMapViewAuthenticationDidComplete(@{});
  }
}

RCT_EXPORT_VIEW_PROPERTY(onMapViewAuthentication, RCTBubblingEventBlock)
- (void)mapViewAuthentication:(RNTQMapView *)mapView didFailWithError:(NSError *)error;
{
  if (mapView.onMapViewAuthentication) {
    mapView.onMapViewAuthentication(@{
      @"code": @(error.code),
      @"message": error.localizedDescription
    });
  }
}

RCT_EXPORT_VIEW_PROPERTY(onMapViewInitComplete, RCTBubblingEventBlock)
- (void)mapViewInitComplete:(RNTQMapView *)mapView
{
  if (mapView.onMapViewInitComplete) {
    mapView.onMapViewInitComplete(@{});
  }
}

RCT_EXPORT_VIEW_PROPERTY(onMapViewDidFailLoadingMap, RCTBubblingEventBlock)
- (void)mapViewDidFailLoadingMap:(RNTQMapView *)mapView withError:(NSError *)error;
{
  if (mapView.onMapViewDidFailLoadingMap) {
    mapView.onMapViewDidFailLoadingMap(@{
      @"code": @(error.code),
      @"message": error.localizedDescription
    });
  }
}

RCT_EXPORT_VIEW_PROPERTY(onMapViewWillStartLocatingUser, RCTBubblingEventBlock)
- (void)mapViewWillStartLocatingUser:(RNTQMapView *)mapView
{
  if (mapView.onMapViewWillStartLocatingUser) {
    mapView.onMapViewWillStartLocatingUser(@{});
  }
}

RCT_EXPORT_VIEW_PROPERTY(onMapViewDidStopLocatingUser, RCTBubblingEventBlock)
- (void)mapViewDidStopLocatingUser:(RNTQMapView *)mapView
{
  if (mapView.onMapViewDidStopLocatingUser) {
    mapView.onMapViewDidStopLocatingUser(@{});
  }
}

RCT_EXPORT_VIEW_PROPERTY(onDidUpdateUserLocation, RCTBubblingEventBlock)
- (void)mapView:(RNTQMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation fromHeading:(BOOL)fromHeading;
{
  if (mapView.onDidUpdateUserLocation) {
    NSNumber *fromHeadingBool = [NSNumber numberWithBool:fromHeading];
    // TODO: 添加 userLocation.heading 参数
    mapView.onDidUpdateUserLocation(@{
      @"location": @{
        @"latitude": @(userLocation.location.coordinate.latitude),
        @"longitude": @(userLocation.location.coordinate.longitude),
      },
      @"fromHeading": fromHeadingBool,
    });
  }
}

RCT_EXPORT_VIEW_PROPERTY(onDidFailToLocateUserWithError, RCTBubblingEventBlock)
- (void)mapView:(RNTQMapView *)mapView didFailToLocateUserWithError:(NSError *)error;
{
  if (mapView.onDidFailToLocateUserWithError) {
    mapView.onDidFailToLocateUserWithError(@{
      @"code": @(error.code),
      @"message": error.localizedDescription
    });
  }
}

RCT_EXPORT_VIEW_PROPERTY(onLocationManagerDidChangeAuthorization, RCTBubblingEventBlock)
- (void)locationManagerDidChangeAuthorization:(RNTQMapView *)mapView;
{
  if (mapView.onLocationManagerDidChangeAuthorization) {
    mapView.onLocationManagerDidChangeAuthorization(@{});
  }
}

RCT_EXPORT_VIEW_PROPERTY(onDidTapAtCoordinate, RCTBubblingEventBlock)
- (void)mapView:(RNTQMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
  if (mapView.onDidTapAtCoordinate) {
    mapView.onDidTapAtCoordinate(@{
      @"latitude": @(coordinate.latitude),
      @"longitude": @(coordinate.longitude),
    });
  }
}

@end

