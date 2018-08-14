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
media_action_map = {
    [8] = "VolumeUp",
    [106] = "VolumeDown",
    [111] = "Mute",
    [104] = "PrevTrack",
    [103] = "Stop",
    [105] = "PlayPause",
    [109] = "NextTrack",
}

make_media_function = function(window_title, media_map)
    return function (button)
        local title = lmc_get_window_title()
        if (not string.match(title, window_title)) then
            return
        end

        local action = media_action_map[button]

        if (not action) then
            return
        end

        local key = media_map[action]
        local key_type = type(key)

        if (key) then
            print("Media: found '" .. action .. "' for '" .. window_title .. "'");
        end

        if (key_type == "number") then
            return function (direction)
                lmc_send_input(key, 0, input_direction(direction))
            end
        elseif (key_type == "string") then
            return function (direction)
                if (direction == 1) then
                    return
                end

                lmc_send_keys(key)
            end
        end
    end
end

global_media_control = make_media_function(
    ".*",
    {
        VolumeUp = 0xAF,
        VolumeDown = 0xAE,
        Mute = 0xAD,
        PrevTrack = 0xB1,
        Stop = 0xB2,
        PlayPause = 0xB3,
        NextTrack = 0xB0,
    }
)

youtube_media_control = make_media_function(
    "YouTube",
    {
        PrevTrack = "%{LEFT}",
        PlayPause = "k",
        NextTrack = "N",
    }
)

media_controls = function (button, direction)
    local mapped_input = youtube_media_control(button)

    if (not mapped_input) then
        mapped_input = global_media_control(button)
    end

    if (not mapped_input) then
        return
    end

    mapped_input(direction)
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

        local title = lmc_get_window_title()
        if (not string.match(title, window_title)) then
            return
        end

        local action = debug_action_map[button]

        if (not action) then
            return
        end

        print("Debug: " .. action);

        local keys = debug_map[action]

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
