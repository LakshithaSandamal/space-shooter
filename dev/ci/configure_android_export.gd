extends SceneTree

func _initialize() -> void:
	var editor_settings: EditorSettings = EditorInterface.get_editor_settings()
	if editor_settings == null:
		push_error("Android export setup requires the Godot editor binary.")
		quit(1)
		return

	var android_sdk_path: String = OS.get_environment("ANDROID_SDK_ROOT")
	var java_sdk_path: String = OS.get_environment("JAVA_HOME")
	if android_sdk_path.is_empty():
		push_error("ANDROID_SDK_ROOT is not configured.")
		quit(1)
		return
	if java_sdk_path.is_empty():
		push_error("JAVA_HOME is not configured.")
		quit(1)
		return

	editor_settings.set_setting("export/android/android_sdk_path", android_sdk_path)
	editor_settings.set_setting("export/android/java_sdk_path", java_sdk_path)
	print("Configured Android SDK: %s" % android_sdk_path)
	print("Configured Java SDK: %s" % java_sdk_path)
	quit(0)
