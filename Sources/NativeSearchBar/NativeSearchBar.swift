import SwiftUI

@available(iOS 13.0, *)
public class SearchBar: NSObject, ObservableObject {
    
    @Published public var text: String = ""
    
    public let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    public override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
    }
}


@available(iOS 13.0, *)
extension SearchBar: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
            
        }
    }
}

@available(iOS 13.0, *)
public struct SearchBarModifier: ViewModifier {
    
    public let searchBar: SearchBar
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }.frame(width: 0, height: 0)
        )
    }
}

@available(iOS 13.0, *)
public extension View {
    func addSearchBar(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}

public final class ViewControllerResolver: UIViewControllerRepresentable {
    
    
    public let onResolve: (UIViewController) -> Void
    
    
    public init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
    }
    
    public func makeUIViewController(context: Context) -> ParentResolverViewController {
        ParentResolverViewController(onResolve: onResolve)
    }
    
    public func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) {
        
    }
}

public class ParentResolverViewController: UIViewController {
    
    
    public let onResolve: (UIViewController) -> Void
    
    
    public init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }
    
    public override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent {
            onResolve(parent)
        }
    }
}

