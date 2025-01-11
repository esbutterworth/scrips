--- evolve
-- trying to make a sequence that changes gradually over time

function init()
    -- input 1 will be "next step" like first
    input[1].mode('change', 1, 0.1, 'rising')
    input[2].mode('stream')

    base_note = 0
    note_range = 24
    reset_threshold = 0.9
    next_chord_threshold = 1.0
    chord_change_mod = -0.01
    steps_since_last_change = 0

    note = base_note
    step = 3
end

input[1].change = function(state)
    note = note + step
    if should_change_chord() then
        next_musical_chord()
    end
    
    reset_note()

    if note == 0 then
        note_v = 0
    else
        note_v  = note / 12
    end
    output[1].volts = note_v
    next_step()
end

function next_step()
    -- weighted random to make normalish chords
    if step == 3 then
        step = math.random(0, 1) + step
    elseif step == 4 then
        step = step - math.random(0.1)
    else
        step = 3
    end
    
    if note > base_note + note_range then -- an octave above
        step_downward = true 
        print('going down')
    elseif note < base_note - note_range then
        step_downward = false
        print('going up')
    end

    if step_downward then
        step = step * -1
    end
end

function reset_note()
    rand = math.random()
    if rand > reset_threshold then
        note = base_note
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
    print('new chord: '..base_note)
end
