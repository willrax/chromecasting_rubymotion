class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    controller = ViewController.alloc.init
    navigation = UINavigationController.alloc.initWithRootViewController(controller)
    @window.rootViewController = navigation
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
