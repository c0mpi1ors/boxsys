//
//  JuBoxSys.swift
//  boxsys
//
//  Migrated to Swift from Objective-C
//  Original by chunyi.zhoucy on 14-1-8.
//

import UIKit

// MARK: - BoxExtend Enum

/// 枚举类型，列出了图像的各种缩放模式
enum JuBoxExtend: Int {
    case none = 0      // 以模板中定义的像素1：1显示，不做任何等比扩展
    case width         // 以屏幕高度做等比依据，宽度任意扩展
    case height        // 以屏幕宽度做等比依据，高度任意扩展，目前大部分都是以这个为主
    case both          // 长和高都以外部框大小扩展，这意味着不是等比缩放
}

// MARK: - JuBoxSysDelegate Protocol

/// BoxSys处理器接口
/// BoxSys回调处理句柄
protocol JuBoxSysDelegate: AnyObject {
    /// 用于预先分配占位
    func getContainer() -> UIView

    /// 消息事件
    /// - Parameters:
    ///   - sender: 发送事件的对象
    ///   - args: 事件参数
    func onBoxSysEvent(sender: Any, args: [String: Any]?)
}

// MARK: - JuBoxModel

/// Box模型基类
/// 存放配置信息
class JuBoxModel {
    /// 必需的初始化器，用于动态实例化
    required init() {}

    /// Box的名字，唯一区分一个BoxModel
    var name: String = ""

    /// Box的类型
    var type: String = ""

    /// Box对应数据里的相对位置
    var map: String?

    /// Box的宽度
    var width: CGFloat = 0

    /// Box的高度
    var height: CGFloat = 0

    /// 装载模型信息
    /// - Parameters:
    ///   - name: 模板名字
    ///   - modelMap: 模板数据
    /// - Returns: 成功或失败
    func load(name: String, modelMap: [String: Any]) -> Bool {
        // 增加版本管理
        guard JuBoxVersion.verify(modelMap) else {
            return false
        }

        self.name = name
        self.map = JuBoxSys2.getString(from: modelMap, name: "map")

        if let w = JuBoxSys2.getNumber(from: modelMap, name: "width") {
            self.width = CGFloat(w.floatValue)
        }

        if let h = JuBoxSys2.getNumber(from: modelMap, name: "height") {
            self.height = CGFloat(h.floatValue)
        }

        return true
    }

    /// 关闭对象（ARC版本可忽略）
    func close() {}
}

// MARK: - JuBox

/// 显示元素类，所有显示元素都需要从这个类继承。
/// 与BoxModel存放配置信息不同，Box存放实际用于显示的内容。
class JuBox {
    /// 必需的初始化器，用于动态实例化
    required init() {}

    /// Box相对与外部容器的x
    var x: CGFloat = 0

    /// Box相对与外部容器的y
    var y: CGFloat = 0

    /// Box相对与外部容器的宽度
    var width: CGFloat = 0

    /// Box相对与外部容器的高度
    var height: CGFloat = 0

    /// Box对应的处理句柄
    weak var handler: JuBoxSysDelegate?

    /// Box对应的Model
    var model: JuBoxModel?

    /// Box对应的数据
    var dataMap: [String: Any]?

    /// View对象，需要子类里实现
    var boxView: UIView?

    deinit {
        boxView?.removeFromSuperview()
    }

    /// 装载入数据
    /// - Parameters:
    ///   - dataMap: 显示数据
    ///   - x: 显示开始位置x
    ///   - y: 显示开始位置y
    ///   - width: 显示宽度
    ///   - height: 显示高度
    ///   - handler: 回调处理入口
    ///   - model: 对应的模型
    /// - Returns: 成功或失败
    func load(dataMap: [String: Any], x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, handler: JuBoxSysDelegate?, model: JuBoxModel) -> Bool {
        // 如果不提供外框的大小（只要有一个维度也算OK的），则直接不可显示
        guard width > 0.1 || height > 0.1 else { return false }

        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.handler = handler
        self.model = model

        // 如果配置了数据map，需要进入对应的数据map做处理
        self.dataMap = dataMap
        if let mapKey = model.map {
            self.dataMap = JuBoxSys2.getMap(from: dataMap, name: mapKey)
        }

        guard self.dataMap != nil else { return false }

        return true
    }

    /// 在指定的容器里显示内容
    func showOn(container: Any?) {
        guard let view = boxView, let container = container else { return }

        // 从父容器里删除
        view.removeFromSuperview()

        if let containerView = container as? UIView {
            containerView.addSubview(view)
        }
    }

    /// 关闭对象（ARC版本可忽略）
    func close() {
        handler = nil
        model = nil
    }
}

// MARK: - JuListRelativeBoxModel

/// 定义了于BoxModel的关系
class JuListRelativeBoxModel {}

// MARK: - JuListBoxModel

/// 列表元素模型定义
/// 定义了一个包含子模型的列表
class JuListBoxModel: JuBoxModel {
    /// 子类的列表
    var subBoxModelList: [JuListRelativeBoxModel] = []

    required override init() {
        super.init()
    }

    override func load(name: String, modelMap: [String: Any]) -> Bool {
        guard super.load(name: name, modelMap: modelMap) else { return false }

        guard let arr = JuBoxSys2.getList(from: modelMap, name: "blocks") else {
            return false
        }

        for (index, item) in arr.enumerated() {
            guard let itemMap = item as? [String: Any] else { continue }

            if let relative = loadItem(index: index, itemMap: itemMap) {
                subBoxModelList.append(relative)
            }
        }

        return true
    }

    /// 装载每条配置关系，需要子类override
    func loadItem(index: Int, itemMap: [String: Any]) -> JuListRelativeBoxModel? {
        return nil
    }
}

// MARK: - JuListBox

/// 列表Box
class JuListBox: JuBox {
    /// 子类的列表
    var subBoxList: [JuBox] = []

    required override init() {
        super.init()
    }
}

// MARK: - JuBoxCache

/// Box缓存管理类
/// BoxCache是两层的，是这样的结构：
/// BoxCache->BoxCacheItem->String
class JuBoxCache {
    private var handlerCache: [String: JuBoxCacheItem] = [:]

    /// 存储一个Box
    func set(boxName: String, key: String, box: JuBox) {
        if handlerCache[key] == nil {
            handlerCache[key] = JuBoxCacheItem()
        }
        handlerCache[key]?.set(boxName: boxName, box: box)
    }

    /// 根据key和box名，获得一个Box缓存数据
    func get(boxName: String, key: String) -> JuBox? {
        return handlerCache[key]?.get(boxName: boxName)
    }

    /// 清除一个key对应下的某个Box缓存
    func clear(boxName: String, key: String) {
        handlerCache[key]?.clear(boxName: boxName)
    }

    /// 清除一个key关联的所有缓存数据
    func clearHandler(key: String) {
        handlerCache[key]?.clearAll()
        handlerCache.removeValue(forKey: key)
    }

    /// 清除所有缓存数据
    func clearAll() {
        handlerCache.removeAll()
    }
}

/// Cache条目
private class JuBoxCacheItem {
    private var boxNameCache: [String: JuBox] = [:]

    func set(boxName: String, box: JuBox) {
        boxNameCache[boxName] = box
    }

    func get(boxName: String) -> JuBox? {
        return boxNameCache[boxName]
    }

    func clear(boxName: String) {
        boxNameCache.removeValue(forKey: boxName)
    }

    func clearAll() {
        boxNameCache.removeAll()
    }
}

// MARK: - JuBoxVersion

/// 版本控制
/// 用于版本控制。从目前的情况看，不同的app版本，需要有版本控制，才能保证正常的显示。
class JuBoxVersion {
    /// 验证数据是否是符合版本要求的
    static func verify(_ dic: [String: Any]) -> Bool {
        let version = JuBoxSys2.getVersion()

        guard let versionMap = JuBoxSys2.getMap(from: dic, name: "version") else {
            // 如果没有指定版本，就是表示版本OK的
            return true
        }

        if let min = JuBoxSys2.getNumber(from: versionMap, name: "min") {
            // 如果最小版本大于当前版本，表示版本不可用
            if min.intValue > version {
                return false
            }
        }

        if let max = JuBoxSys2.getNumber(from: versionMap, name: "max") {
            // 如果最大版本小于当前版本，表示版本不可用
            if max.intValue < version {
                return false
            }
        }

        return true
    }
}

// MARK: - JuBoxSys2

/// BOXSYS 2.0: BOX SYSTEM的缩写，是块状显示系统。
/// BOX SYSTEM是用来提供动态化显示的系统，使用JSON作为模板和数据源，动态拼装显示
class JuBoxSys2 {
    /// 单例
    static let shared = JuBoxSys2()

    /// 类型名->模型类的字典
    private var typeModelClass: [String: JuBoxModel.Type] = [:]

    /// 类型名->显示元素类的字典
    private var typeBoxClass: [String: JuBox.Type] = [:]

    /// 内部锁，防止线程间干扰
    private let internalLock = NSLock()

    /// 模型库
    private var namedModel: [String: JuBoxModel] = [:]

    /// 元素缓存
    private var boxCache = JuBoxCache()

    /// 版本号
    private var version: Int = 100

    private init() {}

    // MARK: - Static Methods

    /// 初始化系统
    static func initBoxSys(versionNumber: Int) {
        shared.version = versionNumber

        // 注册控件
        register(type: "button", modelClass: JuButtonBoxModel.self, boxClass: JuButtonBox.self)
        register(type: "group", modelClass: JuGroupBoxModel.self, boxClass: JuGroupBox.self)
        register(type: "array", modelClass: JuArrayBoxModel.self, boxClass: JuArrayBox.self)
    }

    /// 获得版本号
    static func getVersion() -> Int {
        return shared.version
    }

    /// 从字典中获取字典
    static func getMap(from dataMap: [String: Any]?, name: String?) -> [String: Any]? {
        guard let dataMap = dataMap, let name = name else { return nil }
        return dataMap[name] as? [String: Any]
    }

    /// 从字典中获取列表
    static func getList(from dataMap: [String: Any]?, name: String?) -> [Any]? {
        guard let dataMap = dataMap, let name = name else { return nil }
        return dataMap[name] as? [Any]
    }

    /// 从字典中获取字符串
    static func getString(from dataMap: [String: Any]?, name: String?) -> String? {
        guard let dataMap = dataMap, let name = name else { return nil }
        return dataMap[name] as? String
    }

    /// 从字典中获取数字
    static func getNumber(from dataMap: [String: Any]?, name: String?) -> NSNumber? {
        guard let dataMap = dataMap, let name = name else { return nil }
        return dataMap[name] as? NSNumber
    }

    /// 根据名字获取模型对象
    static func getBoxModel(name: String) -> JuBoxModel? {
        return shared.namedModel[name]
    }

    /// 生成模型
    static func generateModel(type: String) -> JuBoxModel? {
        guard let clazz = shared.typeModelClass[type] else { return nil }
        let model = clazz.init()
        model.type = type
        return model
    }

    /// 生成显示元素
    static func generateBox(type: String?) -> JuBox? {
        guard let type = type, let clazz = shared.typeBoxClass[type] else { return nil }
        return clazz.init()
    }

    /// 注册<Box类型，模型类，元素类>
    static func register(type: String, modelClass: JuBoxModel.Type, boxClass: JuBox.Type) {
        shared.typeModelClass[type] = modelClass
        shared.typeBoxClass[type] = boxClass
        createDefaultBoxModel(type: type)
    }

    /// 反注册
    static func unregister(type: String) {
        shared.typeModelClass.removeValue(forKey: type)
        shared.typeBoxClass.removeValue(forKey: type)
    }

    /// 创建默认类型
    private static func createDefaultBoxModel(type: String) {
        guard let boxModel = generateModel(type: type) else { return }
        if boxModel.load(name: type, modelMap: [:]) {
            shared.namedModel[type] = boxModel
        }
    }

    /// 装载入模型数据
    static func loadModel(_ model: [String: Any]) {
        shared.internalLock.lock()
        defer { shared.internalLock.unlock() }

        // 必须加以排序，否则Dictionary里的是乱序的
        let sortedKeys = model.keys.sorted()

        for modelName in sortedKeys {
            // 判断是否已经存在，如果有重复存在，就以最后那个为准
            if let existingModel = shared.namedModel[modelName] {
                existingModel.close()
                shared.namedModel.removeValue(forKey: modelName)
            }

            guard let m = model[modelName] as? [String: Any] else { continue }

            // 生成模型对象，然后初始化他
            guard let modelType = m["type"] as? String else { continue }
            guard let boxModel = generateModel(type: modelType) else { continue }

            // 如果初始化正确，就放入模形库里
            if boxModel.load(name: modelName, modelMap: m) {
                shared.namedModel[modelName] = boxModel
            }
        }
    }

    /// 渲染出Box
    static func loadBox(name: String, key: String, dataMap: [String: Any], width: CGFloat, height: CGFloat, delegate: JuBoxSysDelegate?) {
        shared.internalLock.lock()
        defer { shared.internalLock.unlock() }

        // 判断是否已经存在显示元素，如果已经存在，就用已有的，如果没有，就构造一个
        var box = shared.boxCache.get(boxName: name, key: key)

        if box == nil {
            // 根据模板名找到模板
            guard let boxModel = shared.namedModel[name] else { return }

            // 根据模板类型构造对象
            guard let newBox = generateBox(type: boxModel.type) else { return }

            // 初始化元素
            if newBox.load(dataMap: dataMap, x: 0, y: 0, width: width, height: height, handler: delegate, model: boxModel) {
                shared.boxCache.set(boxName: name, key: key, box: newBox)
                box = newBox
            }
        }

        if let container = delegate?.getContainer() {
            box?.showOn(container: container)
        }
    }

    /// 删除该handler关联的某模板对应的Box
    static func removeBox(name: String, key: String) {
        shared.internalLock.lock()
        defer { shared.internalLock.unlock() }
        shared.boxCache.clear(boxName: name, key: key)
    }

    /// 清理自身
    static func clearSelf() {
        shared.internalLock.lock()
        shared.boxCache.clearAll()
        shared.namedModel.removeAll()
        shared.internalLock.unlock()
    }
}
