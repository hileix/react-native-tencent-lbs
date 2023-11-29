//
//  Header.h
//  newColleagueLatest
//
//  Created by 肖磊 on 2023/9/3.
//

#import <React/RCTComponent.h>
#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>

@interface RNTQMapView : QMapView

@property (nonatomic, copy) RCTBubblingEventBlock onMapViewInitComplete;

@property (nonatomic, copy) RCTBubblingEventBlock onMapViewWillStartLocatingUser;

@property (nonatomic, copy) RCTBubblingEventBlock onMapViewAuthenticationDidComplete;

@property (nonatomic, copy) RCTBubblingEventBlock onMapViewAuthentication;

@property (nonatomic, copy) RCTBubblingEventBlock onMapViewDidFailLoadingMap;

@property (nonatomic, copy) RCTBubblingEventBlock onMapViewDidStopLocatingUser;

@property (nonatomic, copy) RCTBubblingEventBlock onDidUpdateUserLocation;

@property (nonatomic, copy) RCTBubblingEventBlock onDidFailToLocateUserWithError;

@property (nonatomic, copy) RCTBubblingEventBlock onLocationManagerDidChangeAuthorization;

@property (nonatomic, copy) RCTBubblingEventBlock onDidTapAtCoordinate;


@end

