--- chords
-- arps based on my own mind and bad knowledge of music theory
-- what was I cooking? I want to be able to control how many octave sup the chord
-- can travel with the param `octave_range` but I'm giving up atm

function init()
    -- input 1 will be "next step" like first
    input[1].mode('change', 1, 0.1, 'rising')
    input[2].mode('stream')

    octave_range = 2
    reset_threshold = 0.9

    base_note = 0
    next_chord_threshold = 1.0
    chord_change_mod = -0.01
    steps_since_last_change = 0

    -- 0: dominant 7: 4,3,3 steps
    chord_type = 1
    chord_pos = 1

    note = base_note
    step = 0
end

chord_steps = 
{
    {4, 3, 3}, -- dominant 7
    {4, 2, 3}, -- minor 7 I think
    {4, 3}, -- major
    {3 ,3}, -- minor
}

input[1].change = function(state)
    reset_note()

    if note == 0 then
        note_v = 0
    else
        note_v  = note / 12
    end
    output[1].volts = note_v

    eval_next_step()
    note = note + step
end

function eval_next_step()
    chord = chord_steps[chord_type]
    chord_pos = chord_pos + 1
    print('position '..chord_pos..' of chord')
    if chord_pos > #chord then
        if chord_pos > (#chord * octave_range) then
            next_musical_chord()
            chord_pos = 1
        else
            local clamped_chord_pos = (chord_pos % #chord)
            next_step = (octave_range - chord[clamped_chord_pos]) + octave_range        
        end
    else
        next_step = chord[chord_pos]
    end
    print('step '..step)
    step = next_step
end

function reset_note()
    rand = math.random()
    if rand > reset_threshold then
        chord_pos = 1
    end
end

function should_change_chord()
    rand = math.random()
    threshold = next_chord_threshold - (steps_since_last_change * 0.01)
    if rand > threshold then
        steps_since_last_change = 0
        return true
    else
        steps_since_last_change = steps_since_last_change + 1
        return false
    end
end

function next_musical_chord()
    transition = math.random(0,1)
    if base_note == 0 then
        if transition == 0 then
            base_note = 3
        else
            base_note = 4
        end
    elseif base_note == 3 then
        if transition == 0 then
            base_note = 0
        else
            base_note = 6
        end
    elseif base_note == 6 then
        if transition == 0 then
            base_note = 4
        else
            base_note = 4
        end
    else
        base_note = 0
    end

    chord_type = math.random(1,#chord_steps)
    print('new chord: '..base_note..' of type '..chord_type)
    chord_pos = 1
    note = base_note
end
