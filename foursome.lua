--- foursome
-- 4 seqs getit

function init()
    seqs = {
        { 3, 3, 7, 0,  8,  8,  12, 0,  0 },
        { 3, 8, 7, 10, 10, 10, 14, 0,  0, 0 },
        { 3, 3, 7, 10, 0,  -3, 2,  2,  5, 9 },
        { 3, 0, 7, 20, 7,  7,  7,  -10 },
    }

    step = 1

    gate_1_in = input[1]
    gate_1_in.mode('change')
    gate_1_in.change = next_step_first

    gate_2_in = input[2]
    gate_2_in.mode('change')
    gate_2_in.change = next_step_second
end

function next_step_first()
    next_step(1)
end

function next_step_second()
    next_step(2)
end

function next_step(half)
    for i = (half * 2) - 1, half * 2 do
        seq = seqs[i]
        seq_step = (step % #seq) + 1
        note = seq[seq_step]
        print("out " .. i .. " value " .. note)
        output[i].volts = volts_from_note(seq[seq_step])
    end

    step = step + 1
end

function volts_from_note(note)
    return note / 12
end
