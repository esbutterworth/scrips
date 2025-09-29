--- sy05kit
-- trying to play a whole pattern on just one sy0.5

function init()
    input[1].mode("change")
    input[1].change = play_next

    step = 1
    mutate_chance = 0.1

    -- really these should just be totally random on start
    instruments = {
        perc = { 3, 2, 3 },
        deep_kick = { 4, -2.5, 6 },
        bell = { 1, 2, 4 },
        cymbal = { 1, 4, 5 },
    }

    -- same with this
    seq = {
        "deep_kick",
        "snare",
        "deep_kick",
        "perc",
        "cymbal",
        "deep_kick",
        "snare",
        "bell",
    }

    trig_out = output[1]
    mode_out = output[2]
    pitch_out = output[3]
    decay_out = output[4]

    trig_out.action = pulse()
end

function play_next()
    instrument = seq[step]

    hit(instrument)
    mutate(instrument)

    step = step + 1

    if step > #seq then
        step = 1
    end
end

-- input: a key in instruments table
function hit(instrument)
    print("playing " .. instrument)
    instrument_values = instruments[instrument]

    mode_out.volts = instrument_values[1]
    pitch_out.volts = instrument_values[2]
    decay_out.volts = instrument_values[3]
    trig_out()
end

function mutate(instrument)
    if math.random() > mutate_chance then
        print("mutating " .. instrument)

        mutate_index = math.random(3)
        mutate_amount = math.random() - 0.5
        instruments[instrument][mutate_index] = instruments[instrument][mutate_index] + mutate_amount
    end
end
