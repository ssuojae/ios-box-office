
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let dependencyEnvironment = DependencyEnvironment(decoderFactory: JsonDecoderFactory(), sessionFactory: SessionFactory())
        
        let viewControllerFactory: ViewControllerFactoryProtocol = dependencyEnvironment
        let mainViewController = UINavigationController(rootViewController: viewControllerFactory.makeViewController(for: .boxOffice))
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = mainViewController
    }
    
}
