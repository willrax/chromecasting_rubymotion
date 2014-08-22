class ViewController < UIViewController
  KReceiverAppID = "794B7BBF"

  def viewDidLoad
    super
    self.title = "🚂 Chromotion 🚂"
    self.view.backgroundColor = UIColor.whiteColor
    @image = UIImage.imageNamed("icon-cast-identified.png")
    @image_selected = UIImage.imageNamed("icon-cast-connected.png")

    @chromecast_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @chromecast_button.addTarget(self, action: "choose_device", forControlEvents: UIControlEventTouchDown)
    @chromecast_button.frame = CGRectMake(0, 0, @image.size.width, @image.size.height)
    @chromecast_button.setImage(nil, forState: UIControlStateNormal)
    @chromecast_button.hidden = true

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(@chromecast_button)

    add_controls

    @scanner = GCKDeviceScanner.alloc.init
    @scanner.addListener self
    @scanner.startScan
  end

  def add_controls
    @text_field = UITextField.alloc.initWithFrame(CGRectMake(10, 100, 300, 40))
    @text_field.placeholder = "Type your message"

    @send_button = UIButton.buttonWithType(UIButtonTypeSystem)
    @send_button.frame = CGRectMake(10, 200, 300, 40)
    @send_button.setTitle("Send", forState: UIControlStateNormal)
    @send_button.addTarget(self, action: "send_message:", forControlEvents: UIControlEventTouchUpInside)

    self.view.addSubview @send_button
    self.view.addSubview @text_field
  end

  def choose_device
    if @selected_device == nil
      sheet = UIActionSheet.alloc.initWithTitle("Connect to Device", delegate: self, cancelButtonTitle: nil,
                                        destructiveButtonTitle: nil, otherButtonTitles: nil)

      @scanner.devices.each do |device|
        sheet.addButtonWithTitle device.friendlyName
        sheet.addButtonWithTitle "Cancel"
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1
        sheet.showInView @chromecast_button
      end
    else
      sheet = UIActionSheet.alloc.init
      sheet.title = "Casting to #{@selected_device.friendlyName}"
      sheet.delegate = self

      sheet.addButtonWithTitle "Disconnect"
      sheet.addButtonWithTitle "Cancel"
      sheet.destructiveButtonIndex = 0
      sheet.cancelButtonIndex = 1
      sheet.showInView chromecastButton
    end
  end

  def isConnected
    @device_manager.isConnected
  end

  def connectToDevice
    info = NSBundle.mainBundle.infoDictionary
    @device_manager = GCKDeviceManager.alloc.initWithDevice(@selected_device, clientPackageName: info.objectForKey("CFBundleIdentifier"))
    @device_manager.delegate = self
    @device_manager.connect
  end

  def update_button_states
    if @device_manager && @device_manager.isConnected
      @chromecast_button.setImage(@image_selected, forState: UIControlStateNormal)
      @chromecast_button.setTintColor UIColor.blueColor
      @chromecast_button.hidden = false
    else
      @chromecast_button.setImage(@image, forState: UIControlStateNormal)
      @chromecast_button.setTintColor UIColor.grayColor
      @chromecast_button.hidden = false
    end
  end

  def send_message(sender)
    if @device_manager && @device_manager.isConnected
      @text_channel.sendTextMessage @text_field.text
    else
      puts "not connected"
    end
  end

  def deviceManager(device, didConnectToCastApplication: meta, sessionID: sessionId, launchedApplication: application)
    @text_channel = TextChannel.alloc.initWithNamespace("urn:x-cast:com.google.cast.sample.helloworld")
    @device_manager.addChannel @text_channel
  end

  def deviceDidComeOnline(device)
    update_button_states
  end

  def deviceManagerDidConnect(device)
    update_button_states
    @device_manager.launchApplication(KReceiverAppID)
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    if @selected_device == nil
      if buttonIndex < @scanner.devices.count
        @selected_device = @scanner.devices[buttonIndex]
        connectToDevice
      end
    end
  end
end
