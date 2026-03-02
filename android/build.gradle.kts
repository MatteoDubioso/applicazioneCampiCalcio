// Definizione dei repository globali
allprojects {
    repositories {
        google()  // Repository Google
        mavenCentral()  // Repository Maven Central
    }
}

// Configurazione dei repository per i sottoprogetti
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Configurazione della pulizia dei task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Definizione del blocco buildscript per la configurazione delle dipendenze di build
buildscript {
    repositories {
        google()  // Aggiungi Google come repository per le dipendenze di build
        mavenCentral()  // Aggiungi Maven Central per le dipendenze
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")  // Versione recente di Gradle Plugin
        classpath("com.google.gms:google-services:4.4.2")  // Google Services Plugin
    }
}

// Subprojects evaluation (non strettamente necessario per questo scopo, quindi puoi eliminarlo se non lo usi)
subprojects {
    project.evaluationDependsOn(":app")
}
