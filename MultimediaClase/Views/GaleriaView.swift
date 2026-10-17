import SwiftUI
import PhotosUI

struct GaleriaView: View {
    
    //MARK: - Estado
    
    /// `@State` hace que la vista sea dueña de este ViewModel y lo conserve
    /// aunque SwiftUI vuelva a dibujar la pantalla muchas veces.
    @State private var viewModel = GaleriaViewModel()
    
    //MARK: - Cuerpo
    
    var body: some View {
        // Permite usar $viewModel.propiedad para crear bindings.
        // Un binding es un "cable" de ida y vuelta: el PhotosPicker puede
        // leer y también escribir `seleccion` dentro del ViewModel.
        @Bindable var viewModel = viewModel
        
        ScrollView {
            Text("Fotos Elegidas: \(viewModel.fotos.count)")
        }
        .navigationTitle("Galería")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                // PhotosPicker abre el selector de fotos del sistema.
                // No pide permiso a la fototeca: el usuario solo comparte las fotos que elige.
                PhotosPicker(
                    selection: $viewModel.seleccion,
                    maxSelectionCount: viewModel.maximoFotos,
                    matching: .images
                ) {
                    Label("Elegir fotos", systemImage: "photo.badge.plus")
                }
            }
        }
        // Cada vez que cambia la selección, se cargan las imágenes con await dentro de un Task.
        .onChange(of: viewModel.seleccion) { _, nuevos in
            Task { await viewModel.cargar(nuevos) }
        }
    }
}
