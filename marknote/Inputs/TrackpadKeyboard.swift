//
//  TrackpadKeyboard.swift
//  marknote
//
//  Created by 钟赫明 on 2021/4/28.
//

import Foundation
import SwiftUI 

/// 给Compact模式下的SwiftUI视图添加触控板平移滚动手势，用于控制侧边抽屉栏的滑出和收起
/// 此外，所有的快捷键也被加入到该Controller中，因为如果使用多个类似Controller作为Modifier，会导致对Safearea的ignorance失效
/// 参考自：https://github.com/joehinkle11/Lazy-Pop-SwiftUI
class SwipeController<Content>: UIHostingController<Content>, UIGestureRecognizerDelegate where Content : View {
    private var panGesture: UIPanGestureRecognizer!
    private var transition: UIPercentDrivenInteractiveTransition?
    private var gestureAdded = false
    private var shortcutAdded = false
    private var begin_offset: CGFloat = CGFloat(-320)
    private var begin_position: CGFloat = 0
    @Binding var picker_pop: Bool
    @Binding var setting_pop: Bool
    @Binding var offset: CGFloat
    init(rootView: Content, offset: (Binding<CGFloat>), show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) {
        self._offset = offset
        self._picker_pop = show_picker ?? Binding<Bool>(get: {return false}, set: {_ in })
        self._setting_pop = show_setting ?? Binding<Bool>(get: {return false}, set: {_ in })
        super.init(rootView: rootView)
        super.additionalSafeAreaInsets = .zero
        begin_offset = self.offset
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        if gestureAdded == true {
        }
        else {
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            panGesture.minimumNumberOfTouches = 2
            panGesture.maximumNumberOfTouches = 2
            panGesture.delegate = self
            panGesture.allowedScrollTypesMask = UIScrollTypeMask.continuous
            self.view.addGestureRecognizer(panGesture)
            gestureAdded = true
        }
        
        if shortcutAdded == true {
            
        }
        else {
            let sidemenu = UIKeyCommand(input: "l", modifierFlags: .command, action: #selector(sidemenushortcut(_:)))
            let picker = UIKeyCommand(input: "o", modifierFlags: .command, action: #selector(pickershortcut(_:)))
            let setting = UIKeyCommand(input: "g", modifierFlags: .command, action: #selector(settingshortcut(_:)))
            let save = UIKeyCommand(input: "s", modifierFlags: .command, action: #selector(savefile(_:)))
            self.addKeyCommand(picker)
            self.addKeyCommand(setting)
            self.addKeyCommand(save)
            self.addKeyCommand(sidemenu)
        }
    }

    /// 重写UIGestureRecognizerDelegate提供的函数，用于判断在什么情况下触发手势
    /// 对于这个右滑拉出抽屉菜单的触控板手势，这里设置为当起始 y 方向速度 小于 起始 x 方向速度的1 / 2时触发
    /// 目的是防止该手势干扰编辑器的垂直方向滑动
    /// 参考：官方文档、https://stackoverflow.com/questions/39207789/temporarily-disable-gesture-recognizer-swiping-functionality
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if ((gestureRecognizer as? UIPanGestureRecognizer) == nil) {
            return true
        }
        let velocity_y = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: view).y
        let velocity_x = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: view).x
        if 2 * abs(velocity_y) <= abs(velocity_x) {
            return (velocity_x > 0 && offset == -320) || (velocity_x < 0 && offset == 0)
        }
        return false
    }
    
    @objc func sidemenushortcut(_ command: UIKeyCommand) {
        if offset == CGFloat(-320) {
            offset = CGFloat(0)
        }
        else {
            offset = CGFloat(-320)
        }
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let total = view.frame.width
        let percent = (panGesture.translation(in: view).x - begin_position) / total
        let velocity_weight = abs(panGesture.velocity(in: view).x) / CGFloat(1000)
        
        switch panGesture.state {
        case .began:
            print("begin")
            begin_position = panGesture.translation(in: view).x
            if abs(panGesture.velocity(in: view).x) > 1000 {
                if offset > -320 {
                    offset = 0
                }
                else {
                    offset = -320
                }
            }
        case .changed:
            if velocity_weight > 2 {
                if offset > -320 {
                    offset = 0
                }
                else {
                    offset = -320
                }
            }
            var modifier = percent * 4
            if percent > 1.0 {
                modifier = 1.0
            }
            if percent < -1.0 {
                modifier = -1.0
            }
            let temp = begin_offset - modifier * CGFloat(-320)
            offset = (temp < CGFloat(0)) ? temp : CGFloat(0)
            
        case .ended:
            let velocity = panGesture.velocity(in: view).x

            // Continue if drag more than 50% of screen width or velocity is higher than 100
            if percent > 0.5 || velocity > 100 {
                if offset > -160 {
                    offset = 0
                }
                else {
                    offset = -320
                }
                begin_offset = offset
            } else {
                withAnimation {
                    if offset > -160 {
                        offset = 0
                    }
                    else {
                        offset = -320
                    }
                }
                begin_offset = offset
            }

        case .cancelled, .failed:
            break

        default:
            break
        }
    }
    
    @objc func pickershortcut(_ command: UIKeyCommand) {
        picker_pop.toggle()
    }
    
    @objc func settingshortcut(_ command: UIKeyCommand) {
        setting_pop.toggle()
    }
    
    @objc func savefile(_ command: UIKeyCommand) {
        marknote.savefile()
    }
}

struct swipeView<Content: View>: UIViewControllerRepresentable {
    let rootView: Content
    @Binding var offset: CGFloat
    @Binding var picker_pop: Bool
    @Binding var setting_pop: Bool
    
    init(_ rootView: Content, offset: (Binding<CGFloat>)? = nil, show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) {
        self.rootView = rootView
        self._picker_pop = show_picker ?? Binding<Bool>(get: {return false}, set: {_ in })
        self._setting_pop = show_setting ?? Binding<Bool>(get: {return false}, set: {_ in })
        self._offset = offset ?? Binding<CGFloat>(get: { return CGFloat(-320)}, set: {_ in })
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = SwipeController(rootView: rootView, offset: $offset, show_picker: $picker_pop, show_setting: $setting_pop)
        vc.additionalSafeAreaInsets = .zero
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let host = uiViewController as? UIHostingController<Content> {
            host.rootView = rootView
            host.additionalSafeAreaInsets = .zero
        }
    }
}

class KeyShortcutController<Content>: UIHostingController<Content> where Content : View {
    private var shortcutAdded = false
    @Binding var picker_pop: Bool
    @Binding var setting_pop: Bool
    init(rootView: Content, show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) {
        self._picker_pop = show_picker ?? Binding<Bool>(get: {return false}, set: {_ in })
        self._setting_pop = show_setting ?? Binding<Bool>(get: {return false}, set: {_ in })
        super.init(rootView: rootView)
        super.additionalSafeAreaInsets = .zero
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        if shortcutAdded == true {
            // do nothing
        }
        else {
            let picker = UIKeyCommand(input: "o", modifierFlags: .command, action: #selector(pickershortcut(_:)))
            let setting = UIKeyCommand(input: "g", modifierFlags: .command, action: #selector(settingshortcut(_:)))
            let save = UIKeyCommand(input: "s", modifierFlags: .command, action: #selector(savefile(_:)))
            self.addKeyCommand(picker)
            self.addKeyCommand(setting)
            self.addKeyCommand(save)
        }
    }
    
    @objc func pickershortcut(_ command: UIKeyCommand) {
        picker_pop.toggle()
    }
    
    @objc func settingshortcut(_ command: UIKeyCommand) {
        setting_pop.toggle()
    }
    
    @objc func savefile(_ command: UIKeyCommand) {
        marknote.savefile()
    }
}

struct KeyShortcutView<Content: View>: UIViewControllerRepresentable {
    let rootView: Content
    @Binding var picker_pop: Bool
    @Binding var setting_pop: Bool
    
    init(_ rootView: Content, show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) {
        self.rootView = rootView
        self._picker_pop = show_picker ?? Binding<Bool>(get: {return false}, set: {_ in })
        self._setting_pop = show_setting ?? Binding<Bool>(get: {return false}, set: {_ in })
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = KeyShortcutController(rootView: rootView, show_picker: $picker_pop, show_setting: $setting_pop)
        vc.additionalSafeAreaInsets = .zero
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let host = uiViewController as? UIHostingController<Content> {
            host.rootView = rootView
            host.additionalSafeAreaInsets = .zero
        }
    }
}


extension View {
    public func trackpad_support(offset: (Binding<CGFloat>)? = nil, show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) -> some View {
        return swipeView(self, offset: offset, show_picker: show_picker, show_setting: show_setting)
    }
    
    public func keyshortcut_support(show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) -> some View {
        return KeyShortcutView(self, show_picker: show_picker, show_setting: show_setting)
    }
}

// MARK: - 自定义的tap扩展
/// 用于解决官方TapGesture在trackpad点击时需要点击两次的bug
/// 链接：https://stackoverflow.com/questions/65047746/swiftui-unexpected-behaviour-using-ontapgesture-with-mouse-trackpad-on-ipados?rq=1
public struct UltraPlainButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct Tappable: ViewModifier {
    let action: () -> ()
    func body(content: Content) -> some View {
        Button(action: self.action) {
            content
        }
        .buttonStyle(UltraPlainButtonStyle())
    }
}

extension View {
    func tappable(do action: @escaping () -> ()) -> some View {
        self.modifier(Tappable(action: action))
    }
}
