--- tintinnabuli
-- my understanding is:
-- voice m (melody) plays notes in some scale
-- voice t (tintinnabuli) plays notes in the root triad only
-- the note played by voice t has a consistent relationship to the one played
-- by voice m. this relationship is expressed like "the xth note above/below"
-- so for example, if the relationship is -1, the t voice always plays the
-- closest note in the triad which is lower than the note of the m voice.
-- and the voices cannot play the same note

-- this version will take input CV and gate from elsewhere because I don't want
-- to conflate this with yet another sequence generator
-- (off topic ish but apparently SQ-1 has a hidden sync mode that can handle
-- irregular clocks: https://www.reddit.com/r/modular/comments/b3d5r8/korg_sq1_has_undocumented_sync_modes/)

-- globals
-- could use musicutil for this
m_scale = { 0, 2, 3, 5, 7, 8, 10 } -- example C minor
t_triad = { 0, 3, 5 }              -- C minor triad
t_relationship = -1                -- next lowest note in the triad

function init()
    MVoice = output[1]
    TVoice = output[2]
    CVIn = input[1]

    -- does this limit it to one octave?
    CVIn.mode('scale', m_scale)

    CVIn.scale = play_notes
end

-- idk if this is how it works the docs are ass tbh
function play_notes(note)
    MVoice.volts = volts_from_note(note)
    TVoice.volts = volts_from_note(t_from_m(note))
end

-- this should be a library probably is
function volts_from_note(note)
    return note / 12
end

function t_from_m(note)
    -- lost my train of thought
end
