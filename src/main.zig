const std = @import("std");
const webui = @cImport({
    @cInclude("webui.h");
});

pub fn main() !void {
    const win = webui.webui_new_window();

    const shown = webui.webui_show(win, "<html>Hello!</html>");

    std.debug.print("{}", .{shown}); // this is false and I don't know why

    webui.webui_wait();
}
