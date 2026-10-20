import Foundation

struct Sonido: Identifiable, Hashable {
    /// Nombre que ve el usuario.
    let titulo: String
    /// Nombre del archivo .wav, sin la extensión.
    let archivo: String
    /// Nombre de un SF Symbol (los íconos que trae iOS), por ejemplo "bell".
    let icono: String

    /// Propiedad calculada: el nombre del archivo sirve como id porque no se repite.
    var id: String { archivo }

    var url: URL? {
        // Bundle.main es el paquete de tu app. Aquí le pedimos un archivo por nombre y extensión.
        Bundle.main.url(forResource: archivo, withExtension: "wav")
    }
    
    // MARK: - Lista de sonidos

    /// Todos los sonidos incluidos en la app.
    /// `static` hace que la lista pertenezca al tipo: la lees como `Sonido.todos`.
    static let todos = [
        Sonido(titulo: "Campana", archivo: "campana", icono: "bell"),
        Sonido(titulo: "Melodía", archivo: "melodia", icono: "music.note"),
        Sonido(titulo: "Pulso", archivo: "pulso", icono: "waveform")
    ]
}
