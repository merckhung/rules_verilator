load("@rules_verilator//verilator:repositories.bzl", "verilator_repository")
load("@rules_verilator//verilator/internal:versions.bzl", "VERSION_INFO", "DEFAULT_VERSION")

def _verilator_module_extension_impl(ctx):
    requested_versions = set()
    for mod in ctx.modules:
        for tag in mod.tags.toolchain:
            requested_versions.add(tag.version)

    if not requested_versions:
        requested_versions.add(DEFAULT_VERSION)

    for version in requested_versions:
        if version not in VERSION_INFO:
            fail("Verilator version {} not supported by rules_verilator.".format(repr(version)))
        
        verilator_repository(
            name = "verilator_v{}".format(version),
            version = version,
        )

verilator_toolchain = module_extension(
    implementation = _verilator_module_extension_impl,
    tag_classes = {
        "toolchain": tag_class(attrs = {"version": attr.string()}),
    },
)
