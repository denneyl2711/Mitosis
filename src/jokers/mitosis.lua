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

            card.children.center:set_sprite_pos({ x = 0, y = 0 }) --left rip
            new_card.children.center:set_sprite_pos({ x = 1, y = 0 }) --right rip

            new_card.is_copy = true
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

            relocate_copy_card(card)
        elseif context.drawing_cards or context.end_of_round then
            --todo would be nice to have dissolve shader here
            card.children.center:set_sprite_pos({ x = 0, y = 1 }) --return to full sprite
            card.is_copy = false
        end

    end
}

-- reorder the cards such that the newly inserted card (N) gets moved next to the source card (S)
-- XXXXXXSXXXXN
-- XXXXXXSNXXXX
function relocate_copy_card(card)
    --we want the left rip (original card) and the right rip (its copy) next to each other
    --ideal_index is the original card's index + 1
    local ideal_index
    for i, the_card in ipairs(G.jokers.cards) do
        if card == the_card then
            ideal_index = i + 1
        end
    end

    for i = #G.jokers.cards - 1, ideal_index, -1 do
        local temp = G.jokers.cards[i]
        G.jokers.cards[i] = G.jokers.cards[i + 1]
        G.jokers.cards[i + 1] = temp
    end
end