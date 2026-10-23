import SwiftUI

/// Pantalla del ejemplo "Reproductor de audio" (día 2).
///
/// Capa MVVM: **View**. MuestraReproductorAudioView la lista de sonidos incluidos en la app
/// (campana, melodía, pulso). Quien reproduce es `ReproductorAudioViewModel`,
/// con ayuda de `ReproductorAudioManager`.
struct ReproductorAudioView: View {
    // MARK: - Estado

    /// `@State` hace que la vista sea dueña del ViewModel y lo conserve entre redibujados.
    @State private var viewModel = ReproductorAudioViewModel()

    // MARK: - Cuerpo

    var body: some View {
        // List con varias Section: cada una es un grupo con su propio encabezado.
        List {
            // Sección 1: los sonidos disponibles.
            Section("Sonidos") {
                // Sonido es Identifiable, por eso ForEach no necesita `id:`.
                ForEach(viewModel.sonidos) { sonido in
                    // Tocar un sonido lo reproduce; si ya era el actual, lo pausa o reanuda.
                    Button {
                        
                    } label: {
                        // Spacer empuja el ícono de bocina hasta la derecha.
                        // La bocina solo aparece en el sonido que está sonando ahora.
                        // `&&` significa "y": deben cumplirse las dos condiciones.
                        HStack {
                            Label(sonido.titulo, systemImage: sonido.icono)
                            Spacer()
                            if sonido == viewModel.actual && viewModel.reproduciendo {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            }

            // Sección 2: mensaje de error (por ejemplo, si falta un archivo .wav).
            if !viewModel.mensaje.isEmpty {
                Section {
                    Text(viewModel.mensaje)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Reproductor de audio")
        // Al salir de la pantalla, se detiene el audio para que no siga sonando en el menú.
        .onDisappear {
            viewModel.detener()
        }
    }
}
