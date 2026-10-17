import SwiftUI

/// Celda cuadrada con esquinas redondeadas para mostrar una miniatura.
///
/// No tiene estado ni ViewModel; solo da forma.
/// La usan la galería, el álbum (a través de `MiniaturaView`) y las imágenes remotas,
/// para que todas las cuadrículas se vean iguales sin repetir código.
///
/// El fondo gris fija el tamaño; el contenido se dibuja encima y se recorta.
///
/// - `<Contenido: View>` es un genérico: "Contenido" es un hueco para
///   **cualquier** tipo de vista. Quien usa la celda decide qué poner dentro
///   (una `Image`, un `AsyncImage`, un `ProgressView`...).
///   Es lo mismo que hacen `VStack` o `Button` con lo que les pasas entre llaves.
struct CeldaCuadrada<Contenido: View> : View {
    
    @ViewBuilder let contenido: () -> Contenido
    
    var body: some View {
        Color.gray.opacity(0.15)
            .aspectRatio(1, contentMode: .fit)
            .overlay { contenido() }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
}
