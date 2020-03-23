data:extend({

        {
            type = "int-setting",
            name = "rampant-resources-infiniteResourceNormal",
            setting_type = "startup",
            minimum_value = 1,
            maximum_value = 10000000,
            default_value = 15000,
            order = "l[modifier]-m[unit]",
            per_user = false
        },
        
        {
            type = "double-setting",
            name = "rampant-resources-infiniteResourceMinimum",
            setting_type = "startup",
            minimum_value = 0,
            maximum_value = 1,
            default_value = 0.25,
            order = "l[modifier]-m[unit]",
            per_user = false
        },

        {
            type = "int-setting",
            name = "rampant-resources-infiniteResourceDepletionAmount",
            setting_type = "startup",
            minimum_value = 0,
            maximum_value = 1000000,
            default_value = 1,
            order = "l[modifier]-n[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-resources-infiniteResourceStdDev",
            setting_type = "startup",
            minimum_value = 0,
            maximum_value = 3,
            default_value = 0.17,
            order = "l[modifier]-n[unit]",
            per_user = false
        },

        {
            type = "double-setting",
            name = "rampant-resources-infiniteResourceMaximum",
            setting_type = "startup",
            minimum_value = 0,
            maximum_value = 100,
            default_value = 1.4,
            order = "l[modifier]-n[unit]",
            per_user = false
        },

        -- {
        --     type = "bool-setting",
        --     name = "rampant-attackWaveGenerationUsePlayerProximity",
        --     setting_type = "runtime-global",
        --     default_value = true,
        --     order = "b[modifier]-b[trigger]",
        --     per_user = false

        -- }
})
