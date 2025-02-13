--- ms20harmony
-- experimenting with MS-20 duophonicity and tintinnabuli

M_SCALE = { 7, 9, 10, 12, 14, 15, 17, 19 }
T_TRIAD = { 7, 10, 14 }

function init()
    Voice1Out = output[1]
    Voice2Out = output[2]
    TrigOut = output[3]
    NoteIn = input[1]

    TrigOut.action = pulse()
    NoteIn.mode('scale', M_SCALE)
    NoteIn.scale = play_note
end

function test()
    clock.run(function()
        while true do
            for _, note in ipairs(M_SCALE) do
                t_note = t_from_m(note, T_TRIAD)
                print("m note: " .. note)
                print("t note: " .. t_note)

                Voice1Out.volts = note_to_ms_20(note)
                Voice2Out.volts = note_to_ms_20(t_note)
                TrigOut()

                clock.sleep(1)
            end
        end
    end)
end

function play_note(note)
    note = note.note -- nah that's fucked
    Voice1Out.volts = note_to_ms_20(note)

    t_note = t_from_m(note, T_TRIAD)
    Voice2Out.volts = note_to_ms_20(t_note)
    TrigOut()
end

function note_to_ms_20(note)
    return 2 ^ (note / 12)
end

function t_from_m(note, triad)
    -- find next lowest
    while true do -- lol???
        for i = 1, #triad do
            print("eye: " .. i)
            local t_note = triad[#triad + 1 - i]
            print("note " .. note)
            print("tee note: " .. t_note)
            if t_note < note then
                return t_note
            end
        end
        -- if no matches go to the next octave
        new_triad = {}
        for _, n in ipairs(triad) do
            table.insert(new_triad, n - 12)
        end

        triad = new_triad
    end
end
