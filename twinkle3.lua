--- twinkle3
-- I want to make a version that incorporates some kind of motif
-- maybe the step mutations start off being completely random but over time the
-- coefficients that determine which step to take are influenced by what
-- decisions have been made previously like

LOG_LEVEL = "not debug"

mutation_intervals_by_note = {
    [1] = {
        {
            interval = 3,
            tally = 10, -- initializing the tally to a big number allows the coefficient to change more gradually
            coeff = 0,  -- this doesn't need a default because it gets calculated first
        },
        {
            interval = 4,
            tally = 10,
            coeff = 0,
        },
    },
    [2] = {
        {
            interval = 3,
            tally = 10,
            coeff = 0,
        },
        {
            interval = 4,
            tally = 10,
            coeff = 0,
        },
    }

}

function mutate_note(note)
    refresh_interval_coefficients(note)
    local choice = math.random()
    local interval = choose_interval(note, choice)

    return note + interval
end

function refresh_interval_coefficients(note)
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

function debug_message(m)
    if LOG_LEVEL == "debug" then
        print(m)
    end
end

local i = 100
while i > 0 do
    print(mutate_note(1))
    i = i - 1
end

-- tyyype shi
-- worked on the first try no debug am I the goat
