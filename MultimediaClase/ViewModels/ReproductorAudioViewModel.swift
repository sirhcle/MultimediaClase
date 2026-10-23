import SwiftUI

@MainActor
@Observable
final class ReproductorAudioViewModel {
    // MARK: - Estado
    
    /// La lista fija de sonidos que muestra la pantalla.
    let sonidos = Sonido.todos
    
    /// Sonido cargado en el reproductor; nil = ninguno todavía.
    private(set) var actual: Sonido?
    /// true mientras suena; sirve para mostrar el botón de play o de pausa.
    private(set) var reproduciendo = false
    /// Texto para el usuario cuando algo sale mal. Vacío = sin errores.
    private(set) var mensaje = ""

    /// El manager que toca el audio. Es un recurso vivo, por eso se crea aquí.
    /// `@ObservationIgnored`: SwiftUI no lo vigila porque es una herramienta interna.
    @ObservationIgnored private let reproductor = ReproductorAudioManager()

    init() {
        // El manager avisa cuando el audio termina; saltamos al hilo principal para tocar el estado.
        // `[weak self]` evita que el manager retenga al ViewModel en memoria.
        reproductor.alTerminar = { [weak self] in
            Task { @MainActor in self?.terminoElSonido() }
        }
    }
    
    // MARK: - Acciones

    /// Toca un sonido. Si ya es el actual, alterna entre pausa y reproducción.
    func tocar(_ sonido: Sonido) {
        if sonido == actual {
            alternar()
            return
        }
        
        guard let url = sonido.url else {
            mensaje = "No se encontró \(sonido.archivo).wav. ¿Revisa que se haya agregado al proyecto?"
            return
        }
        
        do {
            try reproductor.cargar(url)
            actual = sonido
            mensaje = ""
            reproductor.reproducir()
            reproduciendo = true
        } catch {
            mensaje = "No se pudo reproducir el sonido"
        }
    }
    
    /// Botón de play/pausa: si suena, pausa; si está en pausa, reanuda.
    func alternar() {
        if reproduciendo {
            reproductor.pausar()
            reproduciendo = false
        } else {
            reproductor.reproducir()
            reproduciendo = true
        }
    }

    /// Detiene el audio.
    func detener() {
        reproductor.detener()
        reproduciendo = false
    }
    
    // MARK: - Ayudantes

    /// Se llama cuando el audio llega a su final.
    private func terminoElSonido() {
        reproduciendo = false
    }


}
