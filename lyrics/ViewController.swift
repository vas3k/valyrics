import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var alignmentControl: NSSegmentedControl!
    @IBOutlet weak var versionField: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionField.title = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let window = self.view.window {
            window.styleMask.insert(.fullSizeContentView)
            window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
        }
        
        let defaults = UserDefaults(suiteName: "group.ru.vas3k.lyrics")
        if let lyricsAlignment = defaults?.integer(forKey: "lyricsAlignment"), lyricsAlignment == 0 {
            self.alignmentControl.selectSegment(withTag: 0)
        } else {
            self.alignmentControl.selectSegment(withTag: 1)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func vas3kruClicked(_ sender: Any) {
        NSWorkspace.shared().open(URL(string: "http://vas3k.ru/lyrics/")!)
    }
    
    @IBAction func donateClicked(_ sender: Any) {
        NSWorkspace.shared().open(URL(string: "http://vas3k.ru/donate/")!)
    }
    
    @IBAction func alignmentChanged(_ sender: Any) {
        print("Changed alignment: ", self.alignmentControl.selectedSegment)
        let defaults = UserDefaults(suiteName: "group.ru.vas3k.lyrics")
        defaults?.set(self.alignmentControl.selectedSegment, forKey: "lyricsAlignment")
        defaults?.synchronize()
    }
}

