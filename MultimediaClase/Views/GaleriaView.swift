import SwiftUI
import PhotosUI

struct GaleriaView: View {
    
    //MARK: - Estado
    
    /// `@State` hace que la vista sea dueña de este ViewModel y lo conserve
    /// aunque SwiftUI vuelva a dibujar la pantalla muchas veces.
    @State private var viewModel = GaleriaViewModel()
    
    /// Columnas de la cuadrícula.
    /// `GridItem(.adaptive(minimum: 100))` dice: "mete tantas columnas como quepan,
    /// cada una de al menos 100 puntos". Así funciona igual en iPhone y en iPad.
    private let columnas = [GridItem(.adaptive(minimum: 100), spacing: 8)]
    
    
    //MARK: - Cuerpo
    
    var body: some View {
        // Permite usar $viewModel.propiedad para crear bindings.
        // Un binding es un "cable" de ida y vuelta: el PhotosPicker puede
        // leer y también escribir `seleccion` dentro del ViewModel.
        @Bindable var viewModel = viewModel
        
        ScrollView {
            if viewModel.fotos.isEmpty {
                ContentUnavailableView(
                    "Sin fotos",
                    systemImage: "photo",
                    description: Text("Toca el botón para elegir hasta \(viewModel.maximoFotos) fotos.")
                    )
            } else {
                LazyVGrid(columns: columnas, spacing: 8) {
                    
                    ForEach(viewModel.fotos) { foto in
                        CeldaCuadrada {
                            Image(uiImage: foto.imagen)
                                .resizable()
                                .scaledToFit()
                        }
                        .onTapGesture {
                            viewModel.fotoAmpliada = foto
                        }
                    }
                }
                .padding()
            }
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
        .fullScreenCover(item: $viewModel.fotoAmpliada) { foto in
            Text("aquí va la foto seleccionada")
            //DetalleFotoView(foto: foto)
        }
    }
}
