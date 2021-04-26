//
//  ContentView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/1/31.
//

import Foundation
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import CoreData
import UIKit

var selectedid: UUID? = nil
var input = ""

//extension UIHostingController {
//
//    /// Applies workaround so `keyboardShortcut` can be used via SwiftUI.
//    ///
//    /// When `UIHostingController` is used as a non-root controller with the UIKit app lifecycle,
//    /// keyboard shortcuts created in SwiftUI don't work (as of iOS 14.4).
//    /// This workaround is harmless and triggers an internal state change that enables keyboard shortcut bridging.
//    /// See https://steipete.com/posts/fixing-keyboardshortcut-in-swiftui/
//    func applyKeyboardShortcutFix() {
//        #if !targetEnvironment(macCatalyst)
//        let window = UIWindow()
//        window.rootViewController = self
//        window.isHidden = false;
//        #endif
//    }
//}

/// 给SwiftUI视图添加触控板平移滚动手势，用于控制侧边抽屉栏的滑出和收起
/// 参考自：https://github.com/joehinkle11/Lazy-Pop-SwiftUI
class SwipeController<Content>: UIHostingController<Content>, UIGestureRecognizerDelegate where Content : View {
    private var panGesture: UIPanGestureRecognizer!
    private var transition: UIPercentDrivenInteractiveTransition?
    private var gestureAdded = false
    private var shortcutAdded = false
    private var begin_offset: CGFloat = CGFloat(-320)
    private var begin_position: CGFloat = 0
    private var customTransitionDelegate : TransitioningDelegate
    @Binding var offset: CGFloat
    @Binding var picker_pop: Bool
    @Binding var setting_pop: Bool
    init(rootView: Content, offset: (Binding<CGFloat>), show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) {
        self._offset = offset
        self._picker_pop = show_picker ?? Binding<Bool>(get: {return false}, set: {_ in })
        self._setting_pop = show_setting ?? Binding<Bool>(get: {return false}, set: {_ in })
        customTransitionDelegate = TransitioningDelegate(offset: offset)
        super.init(rootView: rootView)
        modalPresentationStyle = .custom
        begin_offset = self.offset
        transitioningDelegate = customTransitionDelegate
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
            self.addKeyCommand(sidemenu)
            self.addKeyCommand(picker)
            self.addKeyCommand(setting)
            self.addKeyCommand(save)
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
    
    @objc func pickershortcut(_ command: UIKeyCommand) {
        picker_pop.toggle()
    }
    
    @objc func settingshortcut(_ command: UIKeyCommand) {
        setting_pop.toggle()
    }
    
    @objc func savefile(_ command: UIKeyCommand) {
        marknote.savefile()
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let total = view.frame.width
        let percent = (panGesture.translation(in: view).x - begin_position) / total
        
        switch panGesture.state {

        case .began:
            print("begin")
            begin_position = panGesture.translation(in: view).x
//            transition = UIPercentDrivenInteractiveTransition()
//            self.customTransitionDelegate.interactionController = transition
            if abs(panGesture.velocity(in: view).x) > 1000 {
//                panGesture.state = .ended
                if offset > -320 {
                    offset = 0
                }
                else {
                    offset = -320
                }
            }
            
            
        case .changed:
            
            
            let velocity_weight = abs(panGesture.velocity(in: view).x) / CGFloat(1000)
            if velocity_weight > 2 {
                if offset > -320 {
                    offset = 0
                }
                else {
                    offset = -320
                }
//                panGesture.state = .ended
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
                print("finish")
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
            print("failed")

        default:
            break
        }
    }
    
    class sildeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
        enum TransitionType {
            case presenting
            case dismissing
        }

        let transitionType: TransitionType
        @Binding var offset: CGFloat
        
        init(transitionType: TransitionType, offset: (Binding<CGFloat>)) {
            self.transitionType = transitionType
            self._offset = offset
            super.init()
        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            switch transitionType {
            case .presenting:
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { [self] in
                    self.offset = CGFloat(0)
                }, completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            case .dismissing:

                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    self.offset = CGFloat(-320)
                }, completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        }
    }
    
    class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

        @Binding var offset: CGFloat
        init(offset: Binding<CGFloat>) {
            self._offset = offset
            super.init()
        }
        
        /// Interaction controller
        ///
        /// If gesture triggers transition, it will set will manage its own
        /// `UIPercentDrivenInteractiveTransition`, but it must set this
        /// reference to that interaction controller here, so that this
        /// knows whether it's interactive or not.

        weak var interactionController: UIPercentDrivenInteractiveTransition?

        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return sildeAnimationController(transitionType: .presenting, offset: $offset)
        }

        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return sildeAnimationController(transitionType: .dismissing, offset: $offset)
        }
//
//        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//            return PresentationController(presentedViewController: presented, presenting: presenting)
//        }

        func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return interactionController
        }

        func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return interactionController
        }

    }
}

struct swipeView<Content: View>: UIViewControllerRepresentable {
    let rootView: Content
    @Binding var offset: CGFloat
    @Binding var picker_pop: Bool
    @Binding var setting_pop: Bool
    
    init(_ rootView: Content, offset: (Binding<CGFloat>)? = nil, show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) {
        self.rootView = rootView
        self._offset = offset ?? Binding<CGFloat>(get: { return CGFloat(-320)}, set: {_ in })
        self._picker_pop = show_picker ?? Binding<Bool>(get: {return false}, set: {_ in })
        self._setting_pop = show_setting ?? Binding<Bool>(get: {return false}, set: {_ in })
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = SwipeController(rootView: rootView, offset: $offset, show_picker: $picker_pop, show_setting: $setting_pop)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let host = uiViewController as? UIHostingController<Content> {
            host.rootView = rootView
        }
    }
}

extension View {
    public func keytrackpad_support(offset: (Binding<CGFloat>)? = nil, show_picker: (Binding<Bool>)? = nil, show_setting: (Binding<Bool>)? = nil) -> some View {
        return swipeView(self, offset: offset, show_picker: show_picker, show_setting: show_setting)
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

// MARK: - 主页面视图
struct ContentView: View {
    
    // MARK: - 选取外部文件夹，并保存到书签
    func filePicked(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Error: no permission")
            return
        }
        let bookmarkData = try! url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let bookmarkurl = documentsUrl?.appendingPathComponent(".book")
        try! bookmarkData.write(to: bookmarkurl!)
        
        
        Openedfilelist.reset()
        let Dir = fileitems(name: url.lastPathComponent, path: url)
        let allitems = traversesubfiles(root: Dir)
        
        DirOpened.files = allitems
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        print("Filename: \(DirOpened.files)")
        withAnimation {
            if offset == CGFloat(-320) {
                offset = CGFloat(0)
            }
        }
    }
       
    @State var showpop = false
    @ObservedObject var DirOpened: TargetDir
    @ObservedObject var Openedfilelist: Tabitem
    var root:URL?

    @State var settingpop = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: BookMarks.entity(), sortDescriptors: []) var Marks: FetchedResults<BookMarks>
    @State var offset = CGFloat(-320)
    
    // MARK: - body
    var body: some View {
        let drag = DragGesture(minimumDistance: CGFloat(50))
            .onChanged { g in
                if g.translation.width > -320 && g.translation.width < 320 {
                    withAnimation {
                        offset = g.translation.width - 320
                    }
                }
            }
            .onEnded {
                print($0.translation.width)
                if $0.translation.width < 120 {
                    withAnimation {
                        offset = CGFloat(-320)
                    }
                }
                else if $0.translation.width >= 120 {
                    withAnimation {
                        offset = CGFloat(0)
                    }
                }
                else {
                    withAnimation {
                        offset = CGFloat(0)
                    }
                }
            }
        return
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    NavigationView {
                        body1
                            .frame(width: .infinity, height: .infinity, alignment: .trailing)
                            .disabled(offset != CGFloat(-320) ? true : false)
                            .opacity((-Double(offset) + 320) / 640)
                            .toolbar() {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    TopToolBarLeading
                                }
                                ToolbarItem(placement: .principal) {
                                    TopToolBarPrincipal
                                }
                                ToolbarItem(placement: .automatic, content: {
                                    Button("save") {
                                        savefile()
                                    }
                                    .padding()
                                    .frame(width: nil, height: nil, alignment: .center)
                                    .hoverEffect()
                                })
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    navitool
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())

                    if offset > CGFloat(-320) {
                        Rectangle()
                            .frame(width: geometry.size.width + offset, height: .infinity, alignment: .trailing)
                            .opacity(0.001)
                            .ignoresSafeArea(.all)
                            .edgesIgnoringSafeArea(.all)
                            .tappable {
                                withAnimation {
                                    if offset == CGFloat(-320) {
                                        offset = CGFloat(0)
                                    }
                                    else {
                                        offset = CGFloat(-320)
                                    }
                                }
                            }
                    }
                    NavigationView {
                        sidebar
                    }
                    .accessibility(hidden: (offset == CGFloat(-320)))
                    .frame(width: CGFloat(320), height: .infinity)
                    .offset(x: offset)
                    .animation(.default)
                    .ignoresSafeArea(.all)
                    .shadow(radius: 0.9)
                    .navigationViewStyle(StackNavigationViewStyle())
                }
                .keytrackpad_support(offset: $offset, show_picker: $showpop, show_setting: $settingpop)
                .gesture(drag)
                .accentColor(.purple)
                .ignoresSafeArea(.all)
                
            }
    }
    
    var navitool: some View {
        HStack {
            Button(action: {showpop.toggle()}, label: {
                Image(systemName: "folder.badge.gear")
                    .imageScale(.medium)
            }).sheet(isPresented: $showpop, content: {
                PickerView(callback: filePicked)
                    .accentColor(.purple)
            })
            .frame(width: nil, height: nil, alignment: .center)
            .hoverEffect()
            .keyboardShortcut("o", modifiers: [.command])
            .padding()
            Button(action: {
                if DirOpened.files.path != nil {
                    print("refreshing")
                    filePicked(DirOpened.files.path!)
                }
            }, label: {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.medium)
            })
            .frame(width: nil, height: nil, alignment: .center)
            .hoverEffect()
            .keyboardShortcut("r", modifiers: [.command])
            .padding()
            Button(action: {
                settingpop.toggle()
            }, label: {
                Image(systemName: "gear")
                    .imageScale(.medium)
            }).sheet(isPresented: $settingpop, content: {
                SettingMenu()
            })
            .frame(width: nil, height: nil, alignment: .center)
            .hoverEffect()
            .keyboardShortcut("g", modifiers: [.command])
            .padding()
            Button(action: {
                savefile()
            }, label: {
                EmptyView()
            })
            .frame(width: 0, height: 0)
            .keyboardShortcut("s", modifiers: [.command])
            Button(action: {
                withAnimation {
                    if offset == CGFloat(-320) {
                        offset = CGFloat(0)
                    }
                    else {
                        offset = CGFloat(-320)
                    }
                }
            }, label: {
                EmptyView()
            })
            .frame(width: 0, height: 0)
            .keyboardShortcut("l", modifiers: [.command])
        }
    }
    
    
}



// MARK: - EditorView：显示指定内容的Markdown编辑器
struct EditorView: View {
    @Binding var document: String
    @Binding var edited: Bool
    var fileURL: URL?
    var body: some View {
        VStack {
            VditorView(code: $document, edited: $edited)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(DirOpened: DirOpened, Openedfilelist: Openedfilelist, root: nil)
    }
}
