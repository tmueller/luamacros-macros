clear()
lmc_device_set_name('NUM', 'VID_062A')
lmc_device_set_name('CORSAIR', 'VID_1B1')

-- log_handler = function(button, direction, ts)
--   print('Callback for device: button ' .. button .. ', direction '..direction..', ts '..ts)
-- end

lmc_set_handler('NUM', function(button, direction)
    print("button: " .. button .. " direction: " .. direction)

    -- MEDIA ------------------------------------------------------------------
    media_controls(button, direction)

    -- DEBUG ------------------------------------------------------------------
    title=lmc_get_window_title()
    print(title)

    if (string.match(title, "Chrome")) then
        debug_chrome(button, direction)
    elseif (string.match(title, "Visual Studio Code")) then
        debug_vscode(button, direction)
    end

    -- Windows ----------------------------------------------------------------
    windows_keys(button, direction)
end)

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
end

media_map = {};
media_map[8] = 0xAF     -- backspace    => Volume +
media_map[106] = 0xAE   -- *            => Volume -
media_map[111] = 0xAD   -- /            => Mute
media_map[104] = 0xB1   -- 8            => Prev Track
media_map[105] = 0xB3   -- 9            => Play / Pause
media_map[103] = 0xB2   -- 7            => Stop
media_map[109] = 0xB0   -- -            => Next Track

media_controls = function (button, direction)
    dir = input_direction(direction)
    mapped_input = media_map[button]

    if (not mapped_input) then
        return
    end

    lmc_send_input(mapped_input, 0, dir)
end

debug_chrome = function (button, direction)
    if (direction == 1) then
        return
    end

    -- Continue
    if (button == 100) then
        print("Continue")
        lmc_send_keys("{F8}")
    end

    -- Step Over
    if (button == 101) then
        print("Step Over")
        lmc_send_keys("{F10}")
    end

    -- Step Into
    if (button == 102) then
        print("Step Into")
        lmc_send_keys("{F11}")
    end

    -- Step Out
    if (button == 107) then
        print("Step Out")
        lmc_send_keys("+{F11}")
    end
end

debug_vscode = function (button, direction)
    if (direction == 1) then
        return
    end

    -- Continue
    if (button == 100) then
        print("Continue")
        lmc_send_keys("{F5}")
    end

    -- Step Over
    if (button == 101) then
        print("Step Over")
        lmc_send_keys("{F10}")
    end

    -- Step Into
    if (button == 102) then
        print("Step Into")
        lmc_send_keys("{F11}")
    end

    -- Step Out
    if (button == 107) then
        print("Step Out")
        lmc_send_keys("+{F11}")
    end
end

input_direction = function (direction)
    return direction == 0 and 2 or 0;
end

-- Shift+a you write '+a'
-- Alt+a is '%a'
-- Ctrl+a is '^a'.
