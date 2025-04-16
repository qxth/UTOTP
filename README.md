# 🔐 TOTP-Unix

TOTP (Time-based One-Time Password) para Flutter.

---

## 📋 Versión de Flutter

Flutter 3.29.2 - Tools • Dart 3.7.2 • DevTools 2.42.3

## 🚀 Antes de comenzar

Establecer el canal de Flutter:

```bash
flutter channel stable
```

Instala las dependencias del proyecto:

```bash
flutter pub get
```

---

## 🧪 Pre-commits con Husky

### ✅ Instalación de Husky

```bash
dart pub add --dev husky
```

```bash
dart run husky install
```

```bash
dart run husky add .husky/pre-commit "flutter test"
```

### 🧹 Integrar Lint con Husky

```bash
dart pub add --dev lint_staged
```

> 💡 Revisa el archivo de configuración para asegurar que se ejecute el lint en los archivos modificados.

### 🧹 Integrar Commitlint  con Husky
```bash
dart pub add --dev commitlint_cli
```

```bash
dart run husky add .husky/commit-msg 'dart run commitlint_cli --edit $1'
```


### 💬 Realizar commits con Husky activado

```bash
git commit -a -m "mensaje"
```

---

## 📱 Comandos útiles de ADB

Asegúrate de tener `adb` instalado desde el Android SDK. Luego, puedes ejecutar los siguientes comandos desde PowerShell:

### 🔍 Navega a la carpeta `platform-tools`

```powershell
cd $env:homepath\AppData\Local\Android\Sdk\platform-tools
```

### 📋 Ver dispositivos/emuladores conectados

```powershell
adb devices
```

> Muestra la lista de dispositivos o emuladores disponibles.

### 📦 Instalar una APK en un emulador

```powershell
adb -s <nombre_emulador> install app.apk
```

> Reemplaza `<nombre_emulador>` con un valor como `emulator-5554`.

### 💻 Acceder a la terminal del emulador

```powershell
adb -s <ip_emulador|nombre_emulador> shell
```

> Ejecuta comandos directamente en el entorno del emulador.

### 🌐 Instalar una APK usando IP o nombre

```powershell
adb -s <ip_emulador|nombre_emulador> install app.apk
```

> Útil para dispositivos conectados remotamente.

---

## 📋 Otras notas
### 📦 Visualizar markdown desde android studio
- Ir a > `choose boot Java Runtime` y elegir el recomendado, instalar y reiniciar

## 🔗 Enlaces útiles
- [🔧 Integración de lint-staged y Husky en Flutter](https://thisiscem.medium.com/boosting-code-quality-in-your-flutter-projects-lint-staged-and-husky-integration-4bcee79bbb85)
