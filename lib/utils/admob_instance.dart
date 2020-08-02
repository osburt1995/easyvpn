import 'dart:async';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:rxdart/rxdart.dart';

import 'screen.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-8846782544598831~8245254787';
const String AD_CHA_YE = 'ca-app-pub-8846782544598831/2801356416';
const String AD_JI_LI = 'ca-app-pub-8846782544598831/9125708722';
const String AD_HENG_FU = 'ca-app-pub-8846782544598831/3649078817';
const String testDevice = "43014E620DCCF2881D396AFB70B4BAE2";

class AdmobInstance {
  // 单例公开访问点
  factory AdmobInstance() => _getInstance();

  // 静态私有成员，没有初始化
  static AdmobInstance _vadInstance;

  static AdmobInstance get instance => _getInstance();

  // 激励广告监听变量
  BehaviorSubject<bool> _loadedAsBehaviorSubject = BehaviorSubject();

  ///Native Ad
  NativeAd _nativeAd;

  NativeAd createNativeAd() {
    return NativeAd(
      adUnitId: NativeAd.testAdUnitId,
      factoryId: 'adFactoryExample',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          _nativeAd = createNativeAd();
        }
        if (event == MobileAdEvent.closed) {
          _nativeAd = createNativeAd();
        }
      },
    )..load();
  }

  ///banner_ad
  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: AD_HENG_FU,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          _bannerAd = createBannerAd();
        }
        if (event == MobileAdEvent.closed) {
          _bannerAd = createBannerAd();
        }
      },
    )..load();
  }

  /*   ======================   插页式广告部分开始   ======================   */
  InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: AD_CHA_YE,
        //adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.failedToLoad) {
            _interstitialAd = createInterstitialAd();
          }
          if (event == MobileAdEvent.closed) {
            _interstitialAd = createInterstitialAd();
          }
        })
      ..load();
  }

  /*   ======================   插页式广告部分结束   ======================   */

  // 私有构造函数
  AdmobInstance._() {
    // 初始化 firebase_admob
    FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);
    _bannerAd = createBannerAd();
    _nativeAd = createNativeAd();
    _interstitialAd = createInterstitialAd();
    /*   ======================   激励广告部分开始   ======================   */
    RewardedVideoAd.instance
        .load(adUnitId: AD_JI_LI, targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        _loadedAsBehaviorSubject.value = true;
      }
      if (event == RewardedVideoAdEvent.closed) {
        _loadedAsBehaviorSubject.value = false;
      }
      if (event == RewardedVideoAdEvent.failedToLoad) {
        _loadedAsBehaviorSubject.value = false;
      }
    };
    _loadedAsBehaviorSubject.listen((loaded) {
      if (!loaded) {
        RewardedVideoAd.instance
            .load(adUnitId: AD_JI_LI, targetingInfo: targetingInfo);
      }
    });
    /*   ======================   激励广告部分结束   ======================   */
  }

  // 静态、同步、私有访问点
  static AdmobInstance _getInstance() {
    if (_vadInstance == null) {
      _vadInstance = AdmobInstance._();
    }
    return _vadInstance;
  }

  static final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    //keywords: <String>['video', 'videos'],
    //contentUrl: 'https://flutter.io',
    //birthday: DateTime.now(),
    //testDevices: <String>['43014E620DCCF2881D396AFB70B4BAE2'],
  );

  Future<bool> showBannerlAd() async {
    if (await _bannerAd.isLoaded()) {
      print('-banner加载成功');
      _bannerAd.show(
          anchorOffset: Screen.navigationBarHeight, anchorType: AnchorType.top);
    } else {
      print('-banner加载失败');
      // 没加载出来广告
    }
  }

  // 页面中用户点击操作后调取 VadInstance.instance.showBannerlAd(); 即可显示BannerAd
  Future<bool> showNativeAd() async {
    if (await _nativeAd.isLoaded()) {
      _nativeAd.show(
        anchorOffset: Screen.navigationBarHeight,
      );
    } else {
      // 没加载出来广告
    }
  }

  // 页面中用户点击操作后调取 VadInstance.instance.showRewardedVideoAd(); 即可
  Future<bool> showRewardedVideoAd() {
    if (_loadedAsBehaviorSubject.hasValue && _loadedAsBehaviorSubject.value) {
      print('视频广告加载成功');
      RewardedVideoAd.instance.show();
    } else {
      print('视频广告加载失败');
      // 没加载出来广告
    }
  }

  // 页面中用户点击操作后调取 VadInstance.instance.showInterstitialAd(); 即可
  Future<bool> showInterstitialAd() async {
    if (await _interstitialAd.isLoaded()) {
      _interstitialAd.show();
    } else {
      // 没加载出来广告
    }
  }
}
