
import Foundation

protocol ErrorMappable {
    func mapToDomainError() -> DomainError
}
