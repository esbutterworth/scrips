--- twinkle3
-- I want to make a version that incorporates some kind of motif
-- maybe the step mutations start off being completely random but over time the
-- coefficients that determine which step to take are influenced by what
-- decisions have been made previously like

LOG_LEVEL = "debug"
INHERIT_INTERVALS_FROM_NEIGHBOR = true
NEIGHBOR_DISTANCE = -4
LOW_NOTE = -24
HIGH_NOTE = 36

DEFAULT_MUTATION_INTERVALS = {
    {
        interval = 6,
        tally = 5, -- initializing the tally to a big number allows the coefficient to change more gradually
        coeff = 0, -- this doesn't need a default because it gets calculated first
    },
    {
        interval = 4,
        tally = 5,
        coeff = 0,
    },
    {
        interval = -6,
        tally = 5,
        coeff = 0,
    },
    {
        interval = -4,
        tally = 5,
        coeff = 0,
    },
    {
        interval = -10,
        tally = 2,
        coeff = 0,
    },
    {
        interval = 10,
        tally = 2,
        coeff = 0,
    },
}

function init()
    mutation_intervals_by_note = {}
    next_note = 2 -- arbitrary

    gate_in = input[1]
    cv_out = output[1]
    gate_out = output[2]

    gate_in.mode('change')
    gate_in.change = play_next_note

    gate_out.action = pulse()
end

function play_next_note()
    cv_out.volts = volts_from_note(next_note)
    gate_out()
    next_note = mutate_note(next_note)
end

function mutate_note(note)
    refresh_interval_coefficients(note)
    local choice = math.random()
    local interval = choose_interval(note, choice)

    new_note = note + interval
    if new_note > HIGH_NOTE or new_note < LOW_NOTE then
        new_note = mutate_note(new_note)
    end

    return new_note
end

function refresh_interval_coefficients(note)
    if mutation_intervals_by_note[note] == nil then
        initialize_mutation_intervals(note)
    end

    -- mutation_intervals_by_note.note would be crazy
    local interval_details = mutation_intervals_by_note[note]

    local total_tally = 0
    for _, interval_detail in ipairs(interval_details) do
        total_tally = total_tally + interval_detail.tally
    end

    for _, interval_detail in ipairs(interval_details) do
        interval_detail.coeff = interval_detail.tally / total_tally
        debug_message("interval of " ..
            interval_detail.interval .. " from note " .. note .. " new coeff: " .. interval_detail.coeff)
    end
end

function choose_interval(note, choice)
    local interval_details = mutation_intervals_by_note[note]

    local total_coeff = 0
    for _, interval_detail in ipairs(interval_details) do
        if choice < interval_detail.coeff + total_coeff then
            -- this is the crucial part: when this transition happens, it
            -- affects the weight of that transition happening from this
            -- note again in the future
            interval_detail.tally = interval_detail.tally + 1
            debug_message("stepping " .. interval_detail.interval)
            return interval_detail.interval
        else
            total_coeff = total_coeff + interval_detail.coeff
        end
    end
end

function initialize_mutation_intervals(note)
    debug_message("initializing mutation intervals for note " .. note)
    initial_mutation_intervals = DEFAULT_MUTATION_INTERVALS

    if INHERIT_INTERVALS_FROM_NEIGHBOR then
        neighbor = note + NEIGHBOR_DISTANCE
        if mutation_intervals_by_note[neighbor] ~= nil then
            initial_ = mutation_intervals_by_note[neighbor]
        end
    end

    mutation_intervals_by_note[note] = initial_mutation_intervals
end

function debug_message(m)
    if LOG_LEVEL == "debug" then
        print(m)
    end
end

function volts_from_note(note)
    return note / 12
end
