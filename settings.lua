-- Copyright (C) 2022  veden

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
        }
})
