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

            --todo would be nice to just insert into a particular position
            --janky code to swap ideal location with actual location
            local ideal_index
            for i, the_card in ipairs(G.jokers.cards) do
                if card == the_card then
                    ideal_index = i + 1
                end
            end
            if ideal_index ~= nil then
                local temp = G.jokers.cards[ideal_index]
                G.jokers.cards[ideal_index] = G.jokers.cards[#G.jokers.cards]
                G.jokers.cards[#G.jokers.cards] = temp
            end
        elseif context.drawing_cards or context.end_of_round then
            --todo would be nice to have dissolve shader here
            card.children.center:set_sprite_pos({ x = 0, y = 1 })
            card.is_copy = false
        end

    end
}