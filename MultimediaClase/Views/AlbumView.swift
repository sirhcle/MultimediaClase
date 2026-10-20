import SwiftUI
// PhotosUI trae PhotosPicker, el selector de fotos del sistema.
import PhotosUI

struct AlbumView: View {
    
    // MARK: - Estado

    /// `@State` hace que la vista sea dueña del ViewModel y lo conserve
    /// entre redibujados. Si cambia algo que la vista lee, se vuelve a dibujar sola.
    @State private var viewModel = AlbumViewModel()

    /// Columnas de la cuadrícula: tantas como quepan, de al menos 100 puntos cada una.
    private let columnas = [GridItem(.adaptive(minimum: 100), spacing: 8)]

    // MARK: - Cuerpo

    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ScrollView {
            if viewModel.archivos.isEmpty {
                ContentUnavailableView(
                    "Álbum vacío",
                    systemImage: "photo.on.rectangle",
                    description: Text("Agrega fotos con el botón de arriba.")
                )
            } else {
                LazyVGrid(columns: columnas, spacing: 8) {
                    ForEach(viewModel.archivos, id: \.self) { nombre in
                        MiniaturaView(nombre: nombre, viewModel: viewModel)
                        .contextMenu {
                            Button("Eliminar", systemImage: "trash", role: .destructive) {
                                viewModel.eliminar(nombre)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Mi álbum")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                // Sin maxSelectionCount, el usuario puede elegir varias fotos sin límite.
                PhotosPicker(selection: $viewModel.seleccion, matching: .images) {
                    Label("Agregar", systemImage: "photo.badge.plus")
                }
            }
        }
        .onChange(of: viewModel.seleccion) { _, items in
            Task { await viewModel.guardar(items) }
        }
        .task {
            viewModel.cargarArchivos()
        }
    }
}
