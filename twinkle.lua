--- twinkle

function init()
    Seq = { 1, 5, 8, 11 }
    Step = 1

    UpperNoteBound = 36
    LowerNoteBound = -12
    SeqSizeCoeff = 0.05

    Seqs = { -- haha
        -- these will all get mutated over time
        { 1,  5,  8,  11 },
        { 5,  8,  12, 15 },
        { 11, 15, 18, 21 },
    }

    PossibleMutationSteps = { 12, -12, 3, -3, 4, -4 }

    Voice = output[1]
    StepIn = input[1]
    MutateIn = input[2]

    StepIn.mode('change')
    StepIn.change = play_next_note

    MutateIn.mode('change')
    MutateIn.change = mutate_seq
end

function play_next_note()
    if Step > #Seq then
        play_next_seq()
        Step = 1
    end
    local next_note = Seq[(Step % #Seq) + 1]
    print(next_note)
    Voice.volts = volts_from_note(next_note)
    Step = Step + 1
end

function mutate_seq()
    local choice = math.random()
    local mutation_pos = math.random(#Seq)
    if #Seq > 5 and choice < (#Seq * SeqSizeCoeff) then
        -- remove a note only if the step table is big enough
        table.remove(Seq, mutation_pos)
        print("del")
    elseif choice > 0.7 then
        -- add a note
        local mutation = Seq[mutation_pos] + PossibleMutationSteps[math.random(#PossibleMutationSteps)]
        if mutation > UpperNoteBound or mutation < LowerNoteBound then
            return
        end
        table.insert(Seq, mutation_pos, mutation)
        print("add")
    end
end

function play_next_seq()
    local choice = math.random(#Seqs)
    Seq = Seqs[choice]
    print("---next seq---")
end

function volts_from_note(note)
    return note / 12
end
