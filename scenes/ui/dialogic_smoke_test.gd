extends SceneTree
## Headless smoke test for Dialogic sample timelines (ISSUE-701).

const SAMPLE_RELATIVE_PATH: String = "cycle_0/sample_greeting.dtl"


func _initialize() -> void:
	await process_frame

	var root: Window = get_root()
	if root.get_node_or_null("Dialogic") == null:
		push_error("Dialogic autoload missing")
		quit(1)
		return

	var bridge: Node = root.get_node("DialogicBridge")
	var localization: Node = root.get_node("LocalizationManager")
	bridge.call("sync_all")

	for locale: String in ["fr", "en"]:
		localization.call("set_locale", locale)
		await process_frame
		var path: String = bridge.call("get_timeline_path", SAMPLE_RELATIVE_PATH) as String
		if not ResourceLoader.exists(path):
			push_error("Missing timeline: %s" % path)
			quit(1)
			return

		var timeline: Resource = load(path)
		if timeline == null:
			push_error("Failed to load timeline: %s" % path)
			quit(1)
			return

		print("OK: loaded %s (%s)" % [path, locale])

	print("Dialogic smoke test passed.")
	quit(0)
