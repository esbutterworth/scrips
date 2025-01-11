--- mcopoly
-- two voices with the MCO
-- input 1 switches between snare and perc
-- output 1 is the pitch
-- output 3 is the waveshape
-- wave knob should be at half mast

function init ()
    -- 0 = snare, 1 = perc
    mode = 0
    input[1].mode('change', 1, 0.1, 'rising')
end

modes = 
{
    [0] = -4.5, -- snare
    [1] = -1, -- perc
}

input[1].change = function (state)
    mode = (mode + 1) % 2
    output[3].volts = modes[mode]
end
