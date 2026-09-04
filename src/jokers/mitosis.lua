SMODS.Joker {
    key = 'mitosis',
    atlas = 'mitosis',
    is_copy = false,
    pos = {
        x = 0,
        y = 1
    },
    rarity = 1,
    cost = 1,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = 1
            }
        elseif context.before and not card.is_copy then
            local new_card = SMODS.copy_card(card, {
                no_add = true --don't add a glitched extra duplicate to our jokers list
            })

            card.children.center:set_sprite_pos({ x = 0, y = 0 })
            new_card.children.center:set_sprite_pos({ x = 1, y = 0 })

            new_card.is_copy = true
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

            local ideal_index
            for i, the_card in ipairs(G.jokers.cards) do
                if card == the_card then
                    ideal_index = i + 1
                end
            end
            if ideal_index ~= nil then
                shimmy_over(ideal_index)
            end
        elseif context.drawing_cards or context.end_of_round then
            --todo would be nice to have dissolve shader here
            card.children.center:set_sprite_pos({ x = 0, y = 1 })
            card.is_copy = false
        end

    end
}

-- reorder the cards such that the newly inserted card (N) gets moved next to the source card (S)
-- XXXXXXSXXXXN
-- XXXXXXSNXXXX
function shimmy_over(ideal_index)
    for i = #G.jokers.cards - 1, ideal_index, -1 do
        local temp = G.jokers.cards[i]
        G.jokers.cards[i] = G.jokers.cards[i + 1]
        G.jokers.cards[i + 1] = temp
    end
end