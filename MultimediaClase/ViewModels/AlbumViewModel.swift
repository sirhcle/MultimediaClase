import SwiftUI
import PhotosUI

@MainActor
@Observable
final class AlbumViewModel {
    
    // MARK: - Estado
    
    /// Lo que el usuario eligió en el `PhotosPicker`.
    /// Un `PhotosPickerItem` es solo una referencia a una foto de la fototeca:
    /// todavía no es una imagen, hay que cargarla. Es `var` normal porque la vista la modifica.
    var seleccion: [PhotosPickerItem] = []
    
    /// Nombres de los archivos guardados. La vista dibuja una miniatura por cada uno.
    /// `private(set)`: la vista puede leerla, pero solo este ViewModel puede cambiarla.
    /// Guardamos solo el nombre, no la ruta completa, porque la ruta del sandbox cambia entre instalaciones.
    private(set) var archivos: [String] = []

    // MARK: - Acciones
    
    /// Lee del disco la lista de archivos. La vista lo llama al aparecer.
    func cargarArchivos() {
        archivos = FotoManager.shared.listar()
    }
    
    /// Guarda en disco cada foto elegida y actualiza la lista.
    /// Es `async` porque cargar cada foto tarda; con `await` esperamos sin congelar la pantalla.
    func guardar(_ items: [PhotosPickerItem]) async {
        
        guard !items.isEmpty else { return }
        
        for item in items {
            
            if let data = try? await item.loadTransferable(type: Data.self),
               let imagen = UIImage(data: data) {
                
                _ = try? FotoManager.shared.guardar(imagen)
            
            }
        }
        archivos = FotoManager.shared.listar()
        seleccion = []
    }
    
    /// Lee del disco la imagen con ese nombre. Devuelve nil si no existe.
    func imagen(para nombre: String) -> UIImage? {
        FotoManager.shared.cargar(nombre)
    }
    
    /// Borra la foto del disco y vuelve a leer la lista para que la pantalla se actualice.
    func eliminar(_ nombre: String) {
        FotoManager.shared.borrar(nombre)
        archivos = FotoManager.shared.listar()
    }
}
