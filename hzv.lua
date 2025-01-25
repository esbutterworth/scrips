--- hzv
-- can I control the MS-20 with the crow?

-- MS-20 seems to have the following properties:
-- 0V is silence
-- 10V is the maximum

-- low C?
BASE_NOTE = 55.0

TEST_SCALE = { 7, 8, 10, 12 }

function init()
    TrigOut = output[3]
    Voice1Out = output[1]

    TrigOut.action = pulse()
end

function note_to_ms_20(note)
    return hz_to_v(note_to_hz(note))
end

function hz_to_v(freq)
    v = math.log((freq / BASE_NOTE), 2)
    print("V: " .. v)
    return v
end

function note_to_hz(note)
    exp = (note / 12)
    print("exp: " .. exp)

    coeff = 2 ^ (exp)
    print("coeff: " .. coeff)
    hz = BASE_NOTE * coeff
    print("Hz: " .. hz)
    return hz
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

function playhz(hz)
    Voice1Out.volts = hz_to_v(hz)
    TrigOut()
end
