import SwiftUI

@MainActor
@Observable
final class ImagenesRemotasViewModel {

    // MARK: - Estado

    /// Imágenes que se van a mostrar.
    /// `private(set)`: la vista puede leerla, pero solo este ViewModel puede cambiarla.
    private(set) var imagenes: [ImagenRemota] = []

    // MARK: - Acciones

    /// Llena la lista de imágenes. La vista lo llama en `.task`, al aparecer,
    /// para que el `init` del ViewModel no haga trabajo.
    func cargar() {
        imagenes = ImagenesRemotasManager.shared.obtener()
    }
}
