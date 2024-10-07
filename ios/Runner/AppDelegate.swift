import UIKit
import Flutter
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 네이버 로그인 코드
    NaverThirdPartyLoginConnection.getSharedInstance()?.isNaverAppOauthEnable = true
    NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true

    let thirdConn = NaverThirdPartyLoginConnection.getSharedInstance()
    thirdConn?.setValue("auctionShopurlscheme", forKey:"serviceUrlScheme")
    thirdConn?.setValue("mM6xnsnae5MCpC_PWp_i", forKey:"consumerKey")
    thirdConn?.setValue("Mg11Nw3wrX", forKey:"consumerSecret")
    thirdConn?.setValue("auction-shop", forKey:"appName")
    //

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    var applicationResult = false
    if (!applicationResult) {
       applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }
    // if you use other application url process, please add code here.
    
    if (!applicationResult) {
       applicationResult = super.application(app, open: url, options: options)
    }
    return applicationResult
}
}
