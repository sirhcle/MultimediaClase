import SwiftUI

struct MenuView: View {
    /// `some View` significa "alguna vista concreta que Swift deduce solo".
    /// Así no tienes que escribir el tipo exacto, que sería larguísimo.
    var body: some View {
        NavigationStack {
            List {
                ForEach(Seccion.allCases) { seccion in
                    Section(seccion.rawValue) {
                        ForEach(seccion.ejemplos) { ejemplo in
                            NavigationLink(value: ejemplo) {
                                // Label junta un texto y un ícono SF Symbol en una fila.
                                Label(ejemplo.titulo, systemImage: ejemplo.icono)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Multimedia")
            .navigationDestination(for: Ejemplo.self) { ejemplo in
                destino(para: ejemplo)
            }
        }
    }
    
    /// Construye la pantalla de cada ejemplo. Cada vista crea su propio ViewModel.
    ///
    /// - `@ViewBuilder` deja que la función devuelva vistas de tipos distintos
    ///   según el caso del `switch` (una `GaleriaView`, una `AlbumView`...).
    ///   Sin él, Swift exigiría que todas las ramas devolvieran el mismo tipo.
    /// - `private` significa que solo se usa dentro de `MenuView`.
    @ViewBuilder
    private func destino(para ejemplo: Ejemplo) -> some View {
        // switch revisa en qué caso está `ejemplo` y ejecuta solo esa rama.
        // Swift te obliga a cubrir todos los casos: si agregas uno nuevo al enum
        // y olvidas ponerlo aquí, el proyecto no compila. Así no se te pasa ninguno.
        switch ejemplo {
        // Día 1: imágenes (al empezar, las cuatro líneas muestran un texto provisional;
        // las vas cambiando por la vista real conforme creas cada pantalla)
        case .galeria:
            GaleriaView()
        case .album:
            AlbumView()
        case .filtros:
            Text("Próximamente... o no")
        case .imagenesRemotas:
            ImagenesRemotasView()
            
        case .reproductorAudio:
            Text("Próximamente")
        case .grabadora:
            Text("Próximamente")
        case .textoAVoz:
            Text("Próximamente... tal vez")
        case .misAudios:
            Text("Próximamente... tal vez x2")

        }
    }
}
