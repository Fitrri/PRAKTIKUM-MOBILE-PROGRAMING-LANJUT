allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Solusi Namespace & Manifest tanpa afterEvaluate
    plugins.withType<com.android.build.gradle.api.AndroidBasePlugin> {
        configure<com.android.build.gradle.BaseExtension> {
            if (namespace == null) {
                namespace = "com.example.${project.name.replace("-", ".")}"
            }
        }
        
        // Menghapus atribut package langsung saat task preBuild dipanggil
        tasks.register("removePackageAttribute") {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val content = manifestFile.readText()
                if (content.contains("package=")) {
                    val updatedContent = content.replace(Regex("""package="[^"]*""""), "")
                    manifestFile.writeText(updatedContent)
                }
            }
        }
        tasks.named("preBuild") { dependsOn("removePackageAttribute") }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}