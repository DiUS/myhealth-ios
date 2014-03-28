class LoadingViewController < UIViewController

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    self.view.addSubview(spinner)
    self.navigationController.interactivePopGestureRecognizer.enabled = false
  end

  def spinner
    spinner = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
    spinner.frame = CGRectMake(self.view.bounds.size.width / 3, self.view.bounds.size.height / 3, 100, 100)
    spinner.color = UIColor.blackColor
    spinner.startAnimating
    spinner
  end

  def viewDidAppear(animated)
    super(animated)
    Dispatch::Queue.concurrent.async do
      begin
        p "Loading data ..."
        errorPointer = Pointer.new(:object)
        data = NSData.alloc.initWithContentsOfURL(
          NSURL.URLWithString("http://rds-health.herokuapp.com/users/1/mobile_info/"), options:NSDataReadingUncached, error:errorPointer)
        raise 'No data' unless data
        json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:errorPointer)
        raise 'No data' unless json
        # errorPointer = Pointer.new(:object)
        # qrcode = NSData.alloc.initWithContentsOfURL(
        #   NSURL.URLWithString("http://rds-health.herokuapp.com/users/1/img_qrcode/"), options:NSDataReadingUncached, error:errorPointer)
        # raise 'No QR image' unless qrcode
        Dispatch::Queue.main.sync { qrcodeImage = nil; onDataDidLoad(Health.fromJson(json, qrcodeImage)) }
      rescue => e
        Dispatch::Queue.main.sync { onDataDidFailLoad(e.message) }
      end
    end
  end

  def viewDidDisappear(animated)
    self.view = nil
  end

  def onDataDidLoad(health)
    @tabBarController = UITabBarController.alloc.init
    @tabBarController.title = 'MyHealth'
    summaryController = Formotion::FormController.alloc.initWithForm(Health.formFrom(health))
    summaryController.title = "Summary"
    summaryController.tabBarItem.image = UIImage.imageNamed('summaryTab.png')
    @tabBarController.viewControllers = [summaryController, ImageTabController.alloc.initWithData(health)]
    self.navigationController.pushViewController(@tabBarController,animated: true)
    @tabBarController.navigationItem.hidesBackButton = true
  end

  def onDataDidFailLoad(error)
    alert = UIAlertView.alloc.initWithTitle('Oops ...', message:error,
      delegate:nil, cancelButtonTitle:'Close', otherButtonTitles:nil)
    alert.delegate = self
    alert.show
  end

  def alertView(alertView, didDismissWithButtonIndex:buttonIndex)
    exit(0)
  end

end