//
//  JuBoxExtensions.swift
//  boxsys
//
//  Migrated to Swift from Objective-C
//  Extension components: Button, Array, Group
//

import UIKit

// MARK: - JuButtonBoxModel

/// 按钮模型
class JuButtonBoxModel: JuBoxModel {
    /// 按钮图片的字段名
    var imageURL: String?

    /// 配置HTML的URL的字段名。如果设置了，则会跳转到HTML
    var htmlURL: String?

    /// 配置native跳转的URL的字段名。如果设置了，则会跳转到native页面
    var nativeURL: String?

    /// 埋点的ID，这个是仅有的定义值
    var trackId: String?

    /// 埋点的值的字段名
    var trackName: String?

    required override init() {
        super.init()
    }

    override func load(name: String, modelMap: [String: Any]) -> Bool {
        guard super.load(name: name, modelMap: modelMap) else { return false }

        imageURL = JuBoxSys2.getString(from: modelMap, name: "imageURL")
        htmlURL = JuBoxSys2.getString(from: modelMap, name: "htmlURL")
        nativeURL = JuBoxSys2.getString(from: modelMap, name: "androidURL")
        trackId = JuBoxSys2.getString(from: modelMap, name: "trackId")
        trackName = JuBoxSys2.getString(from: modelMap, name: "trackName")

        return true
    }
}

// MARK: - JuButtonBox

/// 按钮显示元素
class JuButtonBox: JuBox {
    /// 跳转用的url
    private var internalUrl: String?

    /// 按下时的埋点ID
    private var trackId: String?

    /// 按下时的埋点值
    private var trackName: String?

    required override init() {
        super.init()
    }

    override func load(dataMap: [String: Any], x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, handler: JuBoxSysDelegate?, model: JuBoxModel) -> Bool {
        guard super.load(dataMap: dataMap, x: x, y: y, width: width, height: height, handler: handler, model: model) else { return false }

        guard let buttonModel = model as? JuButtonBoxModel else { return false }

        guard let imageURLKey = buttonModel.imageURL,
              let imageUrlString = JuBoxSys2.getString(from: self.dataMap, name: imageURLKey) else {
            return false
        }

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: self.x, y: self.y, width: self.width, height: self.height)

        // 异步加载图片
        if let url = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        button.setImage(image, for: .normal)
                    }
                }
            }
        }

        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        self.boxView = button

        if let htmlURLKey = buttonModel.htmlURL {
            self.internalUrl = JuBoxSys2.getString(from: self.dataMap, name: htmlURLKey)
        } else if let nativeURLKey = buttonModel.nativeURL {
            self.internalUrl = JuBoxSys2.getString(from: self.dataMap, name: nativeURLKey)
        }

        self.trackId = buttonModel.trackId
        if let trackNameKey = buttonModel.trackName {
            self.trackName = JuBoxSys2.getString(from: self.dataMap, name: trackNameKey)
        }

        return true
    }

    @objc private func onClick(_ sender: Any) {
        handler?.onBoxSysEvent(sender: self, args: nil)

        // 统一埋点
        if let trackId = trackId, let trackName = trackName {
            // TBS.Page.buttonClicked("BOXSYS_" + trackId + "_" + trackName)
            print("Track: BOXSYS_\(trackId)_\(trackName)")
        }

        // 统一跳转HTML
        if let urlString = internalUrl, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - JuArrayRelativeBoxModel

/// Array相对模型
class JuArrayRelativeBoxModel: JuListRelativeBoxModel {
    /// 模板
    var model: JuBoxModel?

    /// 映射名，到数据的映射关系
    var map: String?
}

// MARK: - JuArrayBoxModel

/// 数组模型
class JuArrayBoxModel: JuListBoxModel {
    required override init() {
        super.init()
    }

    override func loadItem(index: Int, itemMap: [String: Any]) -> JuListRelativeBoxModel? {
        let relative = JuArrayRelativeBoxModel()

        guard let name = JuBoxSys2.getString(from: itemMap, name: "name") else { return nil }

        relative.model = JuBoxSys2.getBoxModel(name: name)
        guard let model = relative.model else { return nil }

        // 如果对应的模板没有配置高度，这就不行了，array是无法自己知道高度的
        guard model.height > 0.0 else { return nil }

        relative.map = JuBoxSys2.getString(from: itemMap, name: "map")

        return relative
    }
}

// MARK: - JuArrayBox

/// 数组显示元素
class JuArrayBox: JuListBox {
    required override init() {
        super.init()
    }

    override func load(dataMap: [String: Any], x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, handler: JuBoxSysDelegate?, model: JuBoxModel) -> Bool {
        guard super.load(dataMap: dataMap, x: x, y: y, width: width, height: height, handler: handler, model: model) else { return false }

        guard let arrayModel = model as? JuArrayBoxModel else { return false }

        // 初始化布局
        self.boxView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
        self.height = 0.0

        for r in arrayModel.subBoxModelList {
            guard let relative = r as? JuArrayRelativeBoxModel,
                  let relativeModel = relative.model else { continue }

            // 如果配置了数据map，需要进入对应的数据map做处理
            var itemData = self.dataMap
            if let mapKey = relative.map {
                itemData = JuBoxSys2.getMap(from: self.dataMap, name: mapKey)
            }

            guard let itemDataUnwrapped = itemData else { continue }

            // 获取对应的模型定义,Box实例
            guard let itemBox = JuBoxSys2.generateBox(type: relativeModel.type) else { continue }

            // 初始化Box
            guard itemBox.load(dataMap: itemDataUnwrapped, x: 0, y: self.height, width: width, height: height, handler: handler, model: relativeModel) else { continue }

            // 显示Box
            itemBox.showOn(container: self.boxView)

            // 高度等比变高
            self.height += itemBox.height

            // 保存
            self.subBoxList.append(itemBox)
        }

        if self.height > 0 {
            self.boxView?.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        }

        return true
    }
}

// MARK: - JuGroupRelativeBoxModel

/// Group相对模型
class JuGroupRelativeBoxModel: JuListRelativeBoxModel {
    /// 模板
    var model: JuBoxModel?

    /// 映射名，到数据的映射关系
    var map: String?

    /// x坐标
    var x: CGFloat = 0

    /// y坐标
    var y: CGFloat = 0

    /// 宽度
    var width: CGFloat = 0

    /// 高度
    var height: CGFloat = 0

    /// 设置值
    var parameters: [String: Any]?
}

// MARK: - JuGroupBoxModel

/// 组显示元素模型定义
/// 定义了一组相对位置布局的元素关系
class JuGroupBoxModel: JuListBoxModel {
    var boxExtend: JuBoxExtend = .height

    required override init() {
        super.init()
    }

    override func load(name: String, modelMap: [String: Any]) -> Bool {
        guard super.load(name: name, modelMap: modelMap) else { return false }

        boxExtend = .height
        if let strExtend = JuBoxSys2.getString(from: modelMap, name: "extend")?.uppercased() {
            switch strExtend {
            case "NONE":
                boxExtend = .none
            case "WIDTH":
                boxExtend = .width
            case "HEIGHT":
                boxExtend = .height
            case "BOTH":
                boxExtend = .both
            default:
                break
            }
        }

        return true
    }

    override func loadItem(index: Int, itemMap: [String: Any]) -> JuListRelativeBoxModel? {
        let relative = JuGroupRelativeBoxModel()

        guard let name = JuBoxSys2.getString(from: itemMap, name: "name") else { return nil }

        relative.model = JuBoxSys2.getBoxModel(name: name)
        guard relative.model != nil else { return nil }

        relative.map = JuBoxSys2.getString(from: itemMap, name: "map")
        relative.parameters = JuBoxSys2.getMap(from: itemMap, name: "parameters")

        // 判断是否设置了parameters，有的话，直接重新构造
        if let parameters = relative.parameters, let modelType = relative.model?.type {
            guard let itemModel = JuBoxSys2.generateModel(type: modelType) else { return nil }
            guard itemModel.load(name: "temp", modelMap: parameters) else { return nil }
            relative.model = itemModel
        }

        guard let arr = JuBoxSys2.getList(from: itemMap, name: "position"),
              arr.count == 4 else { return nil }

        guard let xNum = arr[0] as? NSNumber,
              let yNum = arr[1] as? NSNumber,
              let widthNum = arr[2] as? NSNumber,
              let heightNum = arr[3] as? NSNumber else { return nil }

        relative.x = CGFloat(xNum.doubleValue)
        relative.y = CGFloat(yNum.doubleValue)
        relative.width = CGFloat(widthNum.doubleValue)
        relative.height = CGFloat(heightNum.doubleValue)

        return relative
    }
}

// MARK: - JuGroupBox

/// 组显示元素
class JuGroupBox: JuListBox {
    required override init() {
        super.init()
    }

    override func load(dataMap: [String: Any], x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, handler: JuBoxSysDelegate?, model: JuBoxModel) -> Bool {
        guard super.load(dataMap: dataMap, x: x, y: y, width: width, height: height, handler: handler, model: model) else { return false }

        guard let groupModel = model as? JuGroupBoxModel else { return false }

        // 根据扩展，计算缩放
        switch groupModel.boxExtend {
        case .height:
            self.width = width
            self.height = groupModel.height * self.width / groupModel.width

        case .none:
            self.width = groupModel.width
            self.height = groupModel.height

        case .width:
            self.height = height
            self.width = groupModel.width * self.height / groupModel.height

        case .both:
            self.height = height
            self.width = width
        }

        // 初始化布局
        self.boxView = UIView(frame: CGRect(x: self.x, y: self.y, width: self.width, height: self.height))

        for r in groupModel.subBoxModelList {
            guard let relative = r as? JuGroupRelativeBoxModel,
                  let relativeModel = relative.model else { continue }

            // 如果配置了数据map，需要进入对应的数据map做处理
            var itemData: [String: Any]?
            if let mapKey = relative.map {
                itemData = JuBoxSys2.getMap(from: self.dataMap, name: mapKey)
            }

            guard let itemDataUnwrapped = itemData else { continue }

            // 获取对应的模型定义,Box实例
            guard let itemBox = JuBoxSys2.generateBox(type: relativeModel.type) else { continue }

            // 计算相对坐标
            let itemX = relative.x * self.width / groupModel.width
            let itemY = relative.y * self.height / groupModel.height
            let itemWidth = relative.width * self.width / groupModel.width
            let itemHeight = relative.height * self.height / groupModel.height

            // 初始化Box
            guard itemBox.load(dataMap: itemDataUnwrapped, x: itemX, y: itemY, width: itemWidth, height: itemHeight, handler: handler, model: relativeModel) else { continue }

            // 显示Box
            itemBox.showOn(container: self.boxView)

            // 保存
            self.subBoxList.append(itemBox)
        }

        return true
    }
}
