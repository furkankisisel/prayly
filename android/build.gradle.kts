allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Workaround: Some third-party plugins (e.g. older flutter_compass) miss an explicit
// Android namespace required by newer AGP versions. Inject one so the build succeeds.
subprojects {
    if (name == "flutter_compass") {
        // Delay until the Android library plugin is applied
        plugins.withId("com.android.library") {
            // Use the BaseExtension to stay compatible across AGP versions
            extensions.findByName("android")?.let { ext ->
                try {
                    val clazz = ext::class
                    val nsProp = clazz.members.firstOrNull { it.name == "namespace" }
                    // Only set if not already defined
                    val current = nsProp?.call(ext) as? String
                    if (current.isNullOrBlank()) {
                        // Arbitrary stable namespace (doesn't need to match manifest package for legacy plugins)
                        clazz.members.firstOrNull { it.name == "setNamespace" }?.call(ext, "com.example.flutter_compass")
                    }
                } catch (_: Exception) {
                    // Silently ignore if reflection fails; build will surface real issue if still present.
                }
            }
        }
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
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Enforce Java 11 toolchain and Kotlin JVM target for all subprojects.
// This helps prevent older plugin subprojects or examples from compiling with
// obsolete `-source 8` flags which trigger the "source value 8 is obsolete" warnings.
subprojects {
    // If the Java plugin is applied, configure its toolchain to use Java 11
    plugins.withType(org.gradle.api.plugins.JavaPlugin::class.java) {
        extensions.findByType(org.gradle.api.plugins.JavaPluginExtension::class.java)
            ?.toolchain
            ?.languageVersion
            ?.set(org.gradle.jvm.toolchain.JavaLanguageVersion.of(11))
    }

    // If the Kotlin JVM plugin is applied, set Kotlin jvmTarget to 11
    plugins.withId("org.jetbrains.kotlin.jvm") {
        afterEvaluate {
            tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class.java).configureEach {
                // 'this' is a KotlinCompile receiver here
                kotlinOptions.jvmTarget = org.gradle.api.JavaVersion.VERSION_11.toString()
            }
        }
    }
}

// Apply namespace patch script for plugins missing namespace (AGP 8+ requirement)
apply(from = File(rootDir.parentFile, "patches/flutter_compass_namespace.gradle"))

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
