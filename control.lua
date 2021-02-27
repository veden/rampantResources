-- imports

-- local constants = require("libs/Constants")

local CHUNK_SIZE = 32

-- constants

-- imported functions

local mLog10 = math.log10
local mRandom = math.random
local mSqrt = math.sqrt

-- local references

local world
local pendingChunks
local queries

-- module code

local function gaussianRandomRange(mean, std_dev, min, max)
    if (min >= max) then
        return min
    end
    local r
    repeat
        local iid1
        local iid2
        local q
        repeat
            iid1 = 2 * mRandom() + -1
            iid2 = 2 * mRandom() + -1
            q = (iid1 * iid1) + (iid2 * iid2)
        until (q ~= 0) and (q < 1)
        local s = mSqrt((-2 * mLog10(q)) / q)
        local v = iid1 * s

        r = mean + (v * std_dev)
    until (r >= min) and (r <= max)
    return r
end


local function onModSettingsChange(event)

    if event and (string.sub(event.setting, 1, 17) ~= "rampant-resources") then
        return false
    end

    world.resourceNormal = settings.startup["rampant-resources-infiniteResourceNormal"].value
    world.resourceMinimum = math.floor(settings.startup["rampant-resources-infiniteResourceMinimum"].value * world.resourceNormal)
    world.resourceMaximum = math.floor(world.resourceNormal * settings.startup["rampant-resources-infiniteResourceMaximum"].value)
    world.resourceStdDev = world.resourceNormal * settings.startup["rampant-resources-infiniteResourceStdDev"].value

    -- world.spoutThreshold = settings.global["rampant-arsenal-spoutThreshold"].value
    -- world.spoutScaler = settings.global["rampant-arsenal-spoutScaler"].value
    -- world.spoutDefaultValue = world.spoutScaler * DEFAULT_SPOUT_SIZE

    for _,surface in pairs(game.surfaces) do
        if surface.valid then
            local entities = surface.find_entities_filtered(queries.getResources)
            for i=1,#entities do
                local entity = entities[i]
                if entity.valid then
                    local normal = entity.prototype.normal_resource_amount
                    local minimum = entity.prototype.minimum_resource_amount
                    if (normal == world.resourceNormal) and (minimum == world.resourceMinimum) then
                        entity.amount = gaussianRandomRange(world.resourceNormal,
                                                            world.resourceStdDev,
                                                            world.resourceMinimum,
                                                            world.resourceMaximum)
                        entity.initial_amount = entity.amount
                    end
                end
            end
        end
    end

    return true
end

local function onChunkGenerated(event)
    -- queue generated chunk for delayed processing, queuing is required because some mods (RSO) mess with chunk as they
    -- are generated, which messes up the scoring.
    pendingChunks[#pendingChunks+1] = event
end

local function onConfigChanged()
    if not world.version or world.version < 2 then

        queries.area = {{0,0},{0,0}}
        queries.getResourcesArea = { area=queries.area, type="resource" }
        queries.getResources = { type="resource" }

        for _,p in ipairs(game.connected_players) do
            p.print("Rampant Resources - Version 0.18.1")
        end
        world.version = 2
    end
    onModSettingsChange()
end

local function onTick()
    if (#pendingChunks > 0) then
        local getResourcesArea = queries.getResourcesArea
        local area = queries.area

        local topOffset = area[1]
        local bottomOffset = area[2]

        for i=#pendingChunks,1,-1 do
            local event = pendingChunks[i]
            pendingChunks[i] = nil

            local topLeft = event.area.left_top
            local x = topLeft.x
            local y = topLeft.y
            local surface = event.surface

            topOffset[1] = x
            topOffset[2] = y
            bottomOffset[1] = x + CHUNK_SIZE
            bottomOffset[2] = y + CHUNK_SIZE

            if surface.valid then
                local entities = surface.find_entities_filtered(getResourcesArea)
                for entityIndex=1,#entities do
                    local entity = entities[entityIndex]
                    if entity.valid then
                        local normal = entity.prototype.normal_resource_amount
                        local minimum = entity.prototype.minimum_resource_amount
                        if (normal == world.resourceNormal) and (minimum == world.resourceMinimum) then
                            entity.amount = gaussianRandomRange(world.resourceNormal,
                                                                world.resourceStdDev,
                                                                world.resourceMinimum,
                                                                world.resourceMaximum)
                            entity.initial_amount = entity.amount
                        end
                    end
                end
            end
        end
    end
end

local function onInit()
    global.world = {}
    global.pendingChunks = {}
    global.queries = {}

    world = global.world
    pendingChunks = global.pendingChunks
    queries = global.queries

    onConfigChanged()
end

local function onLoad()
    world = global.world
    pendingChunks = global.pendingChunks
    queries = global.queries
end

-- hooks

script.on_nth_tick(5, onTick)
-- script.on_event(defines.events.on_tick, onTick)
script.on_init(onInit)
script.on_load(onLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChange)
script.on_configuration_changed(onConfigChanged)

script.on_event(defines.events.on_chunk_generated, onChunkGenerated)
