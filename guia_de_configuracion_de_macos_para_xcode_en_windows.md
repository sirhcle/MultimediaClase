# Guía de Instalación: Entorno macOS para Desarrollo en Xcode (Windows)

Esta guía describe el procedimiento paso a paso para configurar una máquina virtual con **macOS** sobre **Windows** utilizando **VMware Workstation Pro**. Este entorno te permitirá ejecutar **Xcode** y el **Simulador de iOS** para realizar las prácticas del curso.

---

## 📋 Requisitos Mínimos del Equipo

Asegúrate de que tu computadora cumpla con las siguientes especificaciones:

* **Sistema Operativo:** Windows 10 o Windows 11 (64-bit).
* **Procesador:** Intel Core i5/i7/i9 (8ª generación o superior) o AMD Ryzen 5/7/9 con soporte de virtualización.
* **Memoria RAM:** Mínimo **16 GB** (se asignarán 8 GB a la Máquina Virtual y 8 GB a Windows).
* **Almacenamiento:** Mínimo **90 GB libres en una unidad SSD** (evitar discos duros mecánicos HDD para no comprometer el rendimiento).
* **Virtualización Habilitada:** Asegúrate de tener habilitada la opción de virtualización (**VT-x** en Intel o **AMD-V** en AMD) desde la BIOS/UEFI de tu equipo.

---

## 🛠️ Herramientas y Archivos Necesarios

Descarga previamente los siguientes componentes antes de iniciar:

1. **VMware Workstation Pro:** [Sitio Oficial de VMware/Broadcom](https://www.vmware.com/) *(Gratuito para uso personal y educativo)*.
2. **VMware Auto-Unlocker:** Herramienta comunitaria para desbloquear la compatibilidad con macOS.
3. **Imagen de macOS (.ISO):** Descarga el archivo de imagen de macOS (versión recomendada: **macOS Ventura** o **macOS Sonoma**) provisto por el instructor o desde la plataforma del curso.

---

## 🚀 Paso a Paso: Configuración del Entorno

### Paso 1: Desactivar Hyper-V en Windows (Paso Crítico)
Para evitar conflictos de rendimiento en la máquina virtual, debes desactivar las características de virtualización nativas de Windows:

1. En la barra de búsqueda de Windows, escribe **"Activar o desactivar las características de Windows"** y ábrelo.
2. Desmarca las siguientes casillas:
   * **Hyper-V**
   * **Plataforma de máquina virtual**
   * **Plataforma de hipervisor de Windows**
3. Haz clic en **Aceptar** y **reinicia la computadora**.

---

### Paso 2: Instalación de VMware Workstation Pro
1. Ejecuta el instalador descargado de **VMware Workstation Pro**.
2. Sigue los pasos del asistente de instalación por defecto.
3. Al finalizar, selecciona la opción para usarlo con fines personales/educativos.

---

### Paso 3: Ejecutar VMware Unlocker
Por defecto, VMware bloquea la instalación de macOS en hardware no perteneciente a Apple. Para habilitarlo:

1. Asegúrate de que **VMware esté completamente cerrado**.
2. Descomprime el archivo ZIP de **VMware Unlocker**.
3. Busca el archivo llamado `win-install.cmd`.
4. Haz clic derecho sobre él y selecciona **"Ejecutar como administrador"**.
5. Se abrirá una ventana de la consola mandando comandos automáticos. Espera a que el proceso finalice y se cierre la ventana.

---

### Paso 4: Creación de la Máquina Virtual

1. Abre **VMware Workstation Pro**.
2. Ve a **File > New Virtual Machine...** y elige la opción **Typical (recommended)**.
3. Selecciona **Installer disc image file (iso)** y navega hasta elegir tu archivo `.iso` de macOS. Haz clic en **Next**.
4. En el tipo de sistema operativo, selecciona **Apple Mac OS X** y elige la versión correspondiente al archivo descargado.
5. Asigna un nombre a la máquina virtual y elige la ubicación donde se guardará (debe ser dentro del SSD).
6. **Disk Size:** Asigna un tamaño de disco de al menos **80 GB a 100 GB** y selecciona la opción **"Store virtual disk as a single file"**.
7. En la pantalla final, haz clic en **Customize Hardware...**:
   * **Memory:** Asigna **8192 MB (8 GB)** o más si tu PC tiene 32 GB.
   * **Processors:** Asigna al menos **4 núcleos** (Cores).
8. Haz clic en **Finish**.

---

### Paso 5: Modificación del Archivo `.vmx` (Incompatibilidades de CPU)

Antes de iniciar la máquina virtual por primera vez, es necesario agregar unos parámetros de configuración:

1. Dirígete a la carpeta en tu disco donde guardaste la máquina virtual.
2. Busca un archivo con extensión `.vmx` (por ejemplo, `macOS.vmx`).
3. Haz clic derecho sobre él y ábrelo con el **Bloc de Notas**.
4. Desplázate hasta la última línea e ingresa las siguientes líneas de código:

```text
smc.version = "0"
cpuid.1.eax = "0000:0000:0000:0001:0000:0000:0000:0001"
```

> **Nota para usuarios con Procesadores AMD Ryzen:**
> Si tu equipo tiene procesador AMD, agrega adicionalmente las siguientes líneas de compatibilidad:
> ```text
> cpuid.0.eax = "0000:0000:0000:000d:0000:0000:0000:0000"
> cpuid.0.ebx = "0111:0101:0110:1110:0110:0101:0100:0111"
> cpuid.0.ecx = "0110:1100:0110:0101:0111:0100:0110:1110"
> cpuid.0.edx = "0100:0100:0100:0101:0111:0011:0110:0001"
> ```

5. Guarda los cambios (`Ctrl + G`) y cierra el Bloc de Notas.

---

### Paso 6: Instalación del Sistema Operativo macOS

1. Vuelve a VMware y haz clic en **Power on this virtual machine**.
2. Cuando cargue el instalador de macOS, selecciona el idioma predeterminado.
3. En el menú de utilidades, selecciona **Utilidad de Discos (Disk Utility)** y haz clic en **Continuar**.
4. En el panel izquierdo, selecciona el disco virtual no formateado (generalmente denominado *VMware Virtual SATA Hard Drive*).
5. Haz clic en el botón **Borrar (Erase)** en el menú superior:
   * **Nombre:** `macOS HD`
   * **Formato:** *APFS* (o *Mac OS Plus con registro* en versiones anteriores).
   * **Esquema:** *Mapa de particiones GUID*.
6. Haz clic en **Borrar**. Una vez formateado, cierra la Utilidad de Discos.
7. Selecciona **Instalar macOS** y sigue el proceso normal de instalación en el disco `macOS HD`. La máquina se reiniciará un par de veces durante el proceso.

---

### Paso 7: Instalación de Xcode

Una vez dentro del escritorio de macOS:

1. Abre la **App Store** o la app de navegador (Safari).
2. Inicia sesión con tu **Apple ID** (puedes crear una cuenta gratuita en [appleid.apple.com](https://appleid.apple.com) si no tienes una).
3. Busca **Xcode** en la App Store e inicia la descarga.
4. Una vez instalado, abre Xcode, acepta los términos de licencia y permite que instale las herramientas de línea de comandos iniciales.
5. Prueba creando un proyecto nuevo (**iOS App > SwiftUI**) y ejecuta el **Simulador** para verificar que la interfaz visual cargue correctamente.

---

## ❓ Preguntas Frecuentes y Solución de Problemas

* **La pantalla se ve pequeña o la resolución es baja:**
  Instala **VMware Tools** dentro de macOS. En la barra superior de VMware, ve a `VM > Install VMware Tools`, abre el disco virtual que aparecerá en el escritorio de macOS y ejecuta el instalador `Install VMware Tools`.

* **La máquina virtual no arranca (Queda en pantalla negra o bucle de reinicio):**
  Verifica que ejecutaste el script `win-install.cmd` de VMware Unlocker como Administrador y que las líneas del archivo `.vmx` estén correctamente guardadas.

* **El simulador de Xcode se siente lento:**
  Asegúrate de haber cerrado programas pesados en Windows (navegadores con muchas pestañas, juegos, etc.) y asigna un núcleo de procesamiento adicional en los ajustes de la VM si tu procesador lo permite.