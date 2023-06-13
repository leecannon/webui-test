const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "webui-test",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();

    if (target.isWindows()) {
        exe.subsystem = .Console;
        exe.linkSystemLibrary("Ws2_32");
    }

    exe.addIncludePath("webui/include");
    exe.addCSourceFile("webui/src/civetweb/civetweb.c", &.{
        "-DNO_CACHING", "-DNO_CGI", "-DNO_SSL", "-DUSE_WEBSOCKET",
    });
    exe.addCSourceFile("webui/src/webui.c", &.{});

    const install_step = b.addInstallArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(&install_step.step);

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
