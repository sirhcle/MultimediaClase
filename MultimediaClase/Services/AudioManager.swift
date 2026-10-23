import Foundation

/// Guarda, lista y borra los audios grabados en la carpeta Documents/Audios.
///
/// Capa MVVM: **Service** (un "Manager"). Hace el trabajo con archivos para el
/// ViewModel de la "Grabadora". Las vistas nunca lo llaman directo.
///
/// Como no guarda estado propio (solo trabaja con archivos), se usa como singleton:
/// una única instancia compartida por toda la app, `AudioManager.shared`.
struct AudioManager {
    // MARK: - Instancia compartida

    /// `static let shared` crea una sola instancia que vive mientras la app esté abierta.
    /// Desde cualquier ViewModel la usas así: `AudioManager.shared.listar()`.
    static let shared = AudioManager()

    // MARK: - Configuración

    /// Carpeta Documents/Audios dentro del sandbox de la app.
    /// El sandbox es el espacio privado de tu app: otras apps no pueden entrar.
    private let carpeta = URL.documentsDirectory.appending(path: "Audios", directoryHint: .isDirectory)

    /// `private init()` impide que alguien escriba `AudioManager()` desde fuera.
    /// Así te aseguras de que solo exista `shared`.
    private init() {
        // Crea la carpeta si todavía no existe.
        // `try?` intenta algo que puede fallar; si falla, lo ignora y sigue.
        // Aquí está bien ignorarlo: si la carpeta ya existe, no pasa nada.
        try? FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        // #if DEBUG: este código solo existe mientras pruebas desde Xcode,
        // no en la app que publicas. Sirve para ver en la consola dónde quedan los archivos.
        #if DEBUG
        print("Audios guardados en: \(carpeta.path())")
        #endif
    }

    // MARK: - Direcciones

    /// Dirección donde se va a escribir una grabación nueva.
    /// El nombre lleva los segundos actuales + 4 letras al azar del UUID,
    /// para que dos grabaciones hechas en el mismo segundo no se sobrescriban.
    func nuevaURL() -> URL {
        let nombre = "grabacion-\(Int(Date().timeIntervalSince1970))-\(UUID().uuidString.prefix(4)).m4a"
        return carpeta.appending(path: nombre)
    }

    /// Dirección completa a partir del nombre guardado.
    /// Por eso basta con guardar solo el nombre: la ruta se arma aquí, en el momento,
    /// y siempre apunta a la carpeta correcta aunque reinstales la app.
    func url(de nombre: String) -> URL {
        carpeta.appending(path: nombre)
    }

    // MARK: - Acciones

    /// Audios guardados, del más reciente al más antiguo.
    func listar() -> [Grabacion] {
        // Lee los nombres de la carpeta. Si falla, `?? []` usa un arreglo vacío.
        // `??` significa: "si lo de la izquierda es nil, usa lo de la derecha".
        let nombres = (try? FileManager.default.contentsOfDirectory(atPath: carpeta.path())) ?? []
        // Encadenamos tres pasos sobre el arreglo:
        // 1. filter: se queda solo con los archivos .m4a. $0 es cada nombre.
        // 2. map: convierte cada nombre en una Grabacion con su fecha de creación.
        // 3. sorted: ordena por fecha, la más nueva primero.
        return nombres
            .filter { $0.hasSuffix(".m4a") }
            .map { nombre in
                // Si no se puede leer la fecha del archivo, usamos la fecha de hoy (.now).
                let atributos = try? FileManager.default.attributesOfItem(atPath: url(de: nombre).path())
                let fecha = atributos?[.creationDate] as? Date ?? .now
                return Grabacion(nombre: nombre, fecha: fecha)
            }
            .sorted { $0.fecha > $1.fecha }
    }

    /// Borra el audio con ese nombre. Si no existe, no pasa nada (`try?`).
    func borrar(_ nombre: String) {
        try? FileManager.default.removeItem(at: url(de: nombre))
    }
}
