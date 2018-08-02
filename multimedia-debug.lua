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

media_controls = function (button, direction)
    if (direction == 1) then
        if (button == 8) then
            print("Volume +")
            lmc_send_input(0xAF, 0, 0)
            lmc_send_input(0xAF, 0, 2) -- Volume +
        end

        if (button == 106) then
            print("Volume -")
            lmc_send_input(0xAE, 0, 0)
            lmc_send_input(0xAE, 0, 2) -- Volume -
        end

        return
    end

    if (button == 111) then
        print("Mute")
        lmc_send_input(0xAD, 0, 0)
        lmc_send_input(0xAD, 0, 2) -- Mute
    end

    if (button == 104) then
        print("Prev Track")
        lmc_send_input(0xB1, 0, 0) -- Prev Track
        lmc_send_input(0xB1, 0, 2) -- Prev Track
    end

    if (button == 105) then
        print("Play / Pause")
        lmc_send_input(0xB3, 0, 0) -- Play / Pause
        lmc_send_input(0xB3, 0, 2) -- Play / Pause
    end

    if (button == 103) then
        print("Stop")
        lmc_send_input(0xB2, 0, 0) -- Stop
        lmc_send_input(0xB2, 0, 2) -- Stop
    end

    if (button == 109) then
        print("Next Track")
        lmc_send_input(0xB0, 0, 0) -- Next Track
        lmc_send_input(0xB0, 0, 2) -- Next Track
    end
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

-- Shift+a you write '+a'
-- Alt+a is '%a'
-- Ctrl+a is '^a'.
