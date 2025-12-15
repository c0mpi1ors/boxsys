//
//  ViewController.swift
//  boxsys
//
//  Migrated to Swift from Objective-C
//

import UIKit

class ViewController: UIViewController, JuBoxSysDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    var workview: UIView?

    private var modelStatus = 0
    private var dataStatus = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        guard let dData = AppDelegate.getDictionary(fromFile: "JuToday") else { return }

        JuBoxSys2.loadBox(
            name: "Today",
            key: "ViewController",
            dataMap: dData,
            width: 320,
            height: 0,
            delegate: self
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeModel(_ sender: Any) {
        switch modelStatus {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            modelStatus = 0
        }
        modelStatus += 1

        // 测试删除对象，看释放情况
        JuBoxSys2.clearSelf()
    }

    @IBAction func changeData(_ sender: Any) {
        switch dataStatus {
        case 0:
            break
        case 1:
            break
        default:
            dataStatus = 0
        }
        dataStatus += 1
    }

    // MARK: - JuBoxSysDelegate

    func getContainer() -> UIView {
        if workview == nil {
            workview = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
            scrollView.addSubview(workview!)
        }
        return workview!
    }

    func onBoxSysEvent(sender: Any, args: [String: Any]?) {
        // Handle box system events
    }
}
