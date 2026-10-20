import Foundation

struct ImagenesRemotasManager {
    static let shared = ImagenesRemotasManager()
    
    private init() {}
    
    /// Devuelve las imágenes a mostrar: 8 válidas y 1 que falla a propósito.
    func obtener() -> [ImagenRemota] {
        let validas = (10...17).map { "https://picsum.photos/id/\($0)/400/400" }
        let invalida = "https://example.invalid/no-existe.jpg"
        
        return (validas + [invalida]).compactMap { texto in
            URL(string: texto).map { ImagenRemota(url: $0) }
        }
    }
}
