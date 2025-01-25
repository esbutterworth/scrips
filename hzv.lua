--- hzv
-- can I control the MS-20 with the crow?

-- MS-20 seems to have the following properties:
-- 0V is silence
-- 10V is the maximum

-- 0 is "middle"
TEST_SCALE = { 7, 9, 10, 12, 14, 15, 17, 19 }

function init()
    TrigOut = output[3]
    Voice1Out = output[1]

    TrigOut.action = pulse()
end

function note_to_ms_20(note)
    return 2 ^ (note / 12)
end

function run_test()
    clock.run(function()
        for _, note in ipairs(TEST_SCALE) do
            Voice1Out.volts = note_to_ms_20(note)
            TrigOut()
            clock.sleep(1)
        end
    end)
end
