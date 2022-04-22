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

local function linearInterpolation(percent, min, max)
    return ((max - min) * percent) + min
end


for name,resource in pairs(data.raw.resource) do
    if not resource.infinite and not resource.exclude_from_rampant_resources then
        resource.infinite = true

        resource.normal = settings.startup["rampant-resources-infiniteResourceNormal"].value
        resource.minimum = math.floor(settings.startup["rampant-resources-infiniteResourceMinimum"].value * resource.normal)
        resource.infinite_depletion_amount = settings.startup["rampant-resources-infiniteResourceDepletionAmount"].value

        if (#resource.stage_counts > 1) then
            for i = #resource.stage_counts,1,-1  do
                resource.stage_counts[i] = linearInterpolation(
                    1 - (i / #resource.stage_counts),
                    resource.minimum,
                    resource.normal
                )
            end
            resource.stage_counts[#resource.stage_counts] = 0
        end
    end
end
