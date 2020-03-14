local function linearInterpolation(percent, min, max)
    return ((max - min) * percent) + min
end


for _,resource in pairs(data.raw.resource) do
    if not resource.infinite then
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
