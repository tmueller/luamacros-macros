clear()
lmc_device_set_name('NUM', 'VID_062A')
lmc_device_set_name('CORSAIR', 'VID_1B1')

-- log_handler = function(button, direction, ts)
--   print('Callback for device: button ' .. button .. ', direction '..direction..', ts '..ts)
-- end

lmc_set_handler('NUM', function(button, direction)
    debug_output(button, direction)

    media_controls(button, direction)
    debuggers(button, direction)
    windows_keys(button, direction)
end)

-- Utils ----------------------------------------------------------------------
input_direction = function (direction)
    return direction == 0 and 2 or 0;
end

debug_output = function (button, direction)
    title = lmc_get_window_title()
    print(
        "Button: " .. button ..
        " | Direction: " .. direction ..
        " | Title: " .. title
    )
end

-- Windows Keys ---------------------------------------------------------------
windows_keys = function (button, direction)
    if (direction == 1) then
        return
    end

    if (button == 221) then
        print("Desktop Right")
        lmc_send_keys("^#{RIGHT}");
    end

    if (button == 9) then
        print("Desktop Left")
        lmc_send_keys("^#{LEFT}");
    end

    if (button == 13) then
        print("Powershell")
        lmc_spawn("powershell")
    end
end

-- Media Keys -----------------------------------------------------------------
media_map = {
    [8] = 0xAF,     -- backspace    => Volume +
    [106] = 0xAE,   -- *            => Volume -
    [111] = 0xAD,   -- /            => Mute
    [104] = 0xB1,   -- 8            => Prev Track
    [105] = 0xB3,   -- 9            => Play / Pause
    [103] = 0xB2,   -- 7            => Stop
    [109] = 0xB0,   -- -            => Next Track
};

media_controls = function (button, direction)
    mapped_input = media_map[button]

    if (not mapped_input) then
        return
    end

    lmc_send_input(mapped_input, 0, input_direction(direction))
end

-- Debugging ------------------------------------------------------------------
debug_action_map = {
    [100] = "Continue",
    [101] = "StepOver",
    [102] = "StepInto",
    [107] = "StepOut",
    [98] = "Reload",
    [97] = "Stop",
}

make_debug_function = function(window_title, debug_map)
    return function (button, direction)
        if (direction == 1) then
            return
        end

        title = lmc_get_window_title()
        if (not string.match(title, window_title)) then
            return
        end

        action = debug_action_map[button]

        if (not action) then
            return
        end

        print("Debug: " .. action);

        keys = debug_map[action]

        if (not keys) then
            print(
                "Debug action '" .. action ..
                "' not supported for " .. window_title
            )
            return
        end

        lmc_send_keys(keys)
    end
end

debug_chrome = make_debug_function(
    "Chrome",
    {
        Continue = "{F8}",
        StepOver = "{F10}",
        StepInto = "{F11}",
        StepOut = "+{F11}",
        Reload = "^{F5}",
        Stop = "{F12}",
    }
)

debug_vscode = make_debug_function(
    "Visual Studio Code",
    {
        Continue = "{F5}",
        StepOver = "{F10}",
        StepInto = "{F11}",
        StepOut = "+{F11}",
        Reload = "^+{F5}",
        Stop = "+{F5}",
    }
)

debug_firefox = make_debug_function(
    "Firefox",
    {
        Continue = "{F8}",
        StepOver = "{F10}",
        StepInto = "{F11}",
        StepOut = "+{F11}",
        Reload = "^{F5}",
        Stop = "{F12}",
    }
)

debuggers = function (button, direction)
    debug_chrome(button, direction)
    debug_vscode(button, direction)
    debug_firefox(button, direction)
end

-- Shift+a you write '+a'
-- Alt+a is '%a'
-- Ctrl+a is '^a'.
