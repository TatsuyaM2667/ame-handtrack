// ame-shell(https://github.com/TatsuyaM2667/ame-shell)の src/cmd/ame-handtrack.zig から生成。直すときは ame-shell の方を直す
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const lib = b.createModule(.{ .root_source_file = b.path("src/lib/lib.zig") });
    const hand = b.dependency("ame_hand", .{ .target = target, .optimize = optimize });

    const exe = b.addExecutable(.{ .name = "ame-handtrack", .root_source_file = b.path("src/main.zig"), .target = target, .optimize = optimize });
    exe.root_module.addImport("ame_lib", lib);
    exe.linkLibC();
    exe.root_module.addImport("ame-hand", hand.module("ame-hand"));
    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    if (b.args) |a| run.addArgs(a);
    b.step("run", "ame-handtrack を実行する").dependOn(&run.step);

    const t_main = b.addTest(.{ .root_source_file = b.path("src/main.zig"), .target = target, .optimize = optimize });
    t_main.root_module.addImport("ame_lib", lib);
    t_main.linkLibC();
    t_main.root_module.addImport("ame-hand", hand.module("ame-hand"));
    const t_lib = b.addTest(.{ .root_source_file = b.path("src/lib/lib.zig"), .target = target, .optimize = optimize });
    t_lib.linkLibC();
    const ts = b.step("test", "テスト");
    ts.dependOn(&b.addRunArtifact(t_main).step);
    ts.dependOn(&b.addRunArtifact(t_lib).step);
}
