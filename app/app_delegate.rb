class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @loadingViewController = LoadingViewController.alloc.init
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(@loadingViewController)
    @window.makeKeyAndVisible
    true
  end
end
