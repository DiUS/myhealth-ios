class ImageTabController < UIViewController

  def initWithData(health)
    self.init
    self.title = "Export"
    @health = health
    self.tabBarItem.image = UIImage.imageNamed('imageTab.png')
    self
  end

  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    view.addSubview(button)
    # view.addSubview(label)
  end

  # def viewDidDisappear(animated)
  #   self.view = nil
  # end

  def barButtonItems
    flexibleSpace = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    barButtonItems = []
    barButtonItems << UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed("alarm.png"), style:UIBarButtonItemStylePlain, target:self, action:'onChooseWallpaper')
    barButtonItems << flexibleSpace
    barButtonItems
  end

  def button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = CGRectMake(0, 0, 200, 200)
    button.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2)
    button.setTitle("Select Wallpaper", forState:UIControlStateNormal)
    button.setTitle("Working ...", forState:UIControlStateHighlighted)
    button.addTarget(self, action:'onSelectWallpaper', forControlEvents:UIControlEventTouchUpInside)
    button
  end

  def onSelectWallpaper
    controller = UIImagePickerController.alloc.init
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    requiredMediaType = KUTTypeImage
    controller.mediaTypes = [requiredMediaType]
    controller.delegate = self
    self.navigationController.presentModalViewController(controller, animated:true)
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)
    # wallpaper
    frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)
    imageView = UIView.alloc.initWithFrame(frame)
    imageView.addSubview(UIImageView.alloc.initWithImage(info.objectForKey(UIImagePickerControllerOriginalImage)))
    # myhealth data
    imageView.addSubview label
    image = captureImage(imageView)
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    view.addSubview(imageView)

    picker.dismissModalViewControllerAnimated(true)

    alert = UIAlertView.alloc.initWithTitle('Wallpaper Saved', message:nil,
      delegate:nil, cancelButtonTitle:'Close', otherButtonTitles:nil)
    alert.show
  end

  # def alertView(alertView, didDismissWithButtonIndex:buttonIndex)
  #   p 'do nothing'
  # end

  def imagePickerControllerDidCancel(picker)
    p "imagePickerControllerDidCancel"
    picker.dismissModalViewControllerAnimated(true)
  end

  def captureImage(imageView)
    UIGraphicsBeginImageContext(imageView.bounds.size)
    imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
    result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    result
  end

  def label
    frame = CGRectMake(10, (view.bounds.size.height / 3) - 20, view.bounds.size.width - 20, 280)
    label = UILabel.alloc.initWithFrame(frame)
    label.font = regularStandardFont(14)
    label.text = "
  In case of emergency call:
\t#{@health.emergencyName} #{@health.emergencyTel}

  My name is:
\t#{@health.name}

  I suffer from:
\t#{format(@health.conditions)}

  Don't give me:
\t#{format(@health.allergies)}

"

    attributedText = NSMutableAttributedString.alloc.initWithString(label.text)
    range = [label.text.index('In case of emergency call'), 'In case of emergency call'.length]
    attributedText.addAttribute(NSFontAttributeName, value:boldStandardFont(18), range:range)
    range = [label.text.index('My name is'), 'My name is'.length]
    attributedText.addAttribute(NSFontAttributeName, value:boldStandardFont(18), range:range)
    range = [label.text.index('I suffer from'), 'I suffer from'.length]
    attributedText.addAttribute(NSFontAttributeName, value:boldStandardFont(18), range:range)
    range = [label.text.index("Don't give me"), "Don't give me".length]
    attributedText.addAttribute(NSFontAttributeName, value:boldStandardFont(18), range:range)
    label.attributedText = attributedText
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:0.5)
    label.lineBreakMode = NSLineBreakByWordWrapping
    label.numberOfLines = 0
    # label.sizeToFit
    label
  end

  def format(listItems)
    listItems.join("\n\t")
    # return "" if listItems.nil? || listItems.length == 0
    # result = ""
    # listItems.each {|c| result << "\t" + c + "\n" }
    # result
  end

  def lightStandardFont(size)
    UIFont.fontWithName "HelveticaNeue-UltraLight", size:size
  end

  def regularStandardFont(size)
    UIFont.fontWithName "HelveticaNeue", size:size
  end

  def boldStandardFont(size)
    UIFont.fontWithName "HelveticaNeue-Bold", size:size
  end

end
