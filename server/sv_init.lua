local function init_core()
    local IsLinux = false

    print("###############################################################################\n" ..
        "\n^1----- ^3#RedM ^1----------------------------------------------------------------------^0\n" ..
        " /##    /##  /######  /#######  /#######   /######   /######  /#######  /########\n" ..
        "| ##   | ## /##__  ##| ##__  ##| ##__  ## /##__  ## /##__  ##| ##__  ##| ##_____/\n" ..
        "| ##   | ##| ##  | ##| ##  | ##| ##  | ##| ##  |__/| ##  | ##| ##  | ##| ##      \n" ..
        "|  ## / ##/| ##  | ##| #######/| #######/| ##      | ##  | ##| #######/| #####   \n" ..
        " |  ## ##/ | ##  | ##| ##__  ##| ##____/ | ##      | ##  | ##| ##__  ##| ##__/   \n" ..
        "  |  ###/  | ##  | ##| ##  | ##| ##      | ##    ##| ##  | ##| ##  | ##| ##      \n" ..
        "   |  #/   |  ######/| ##  | ##| ##      |  ######/|  ######/| ##  | ##| ########\n" ..
        "    |_/     |______/ |__/  |__/|__/       |______/  |______/ |__/  |__/|________/\n" ..
        "^1----------------------------------------------------^3VORPcore Framework ^2Lua^0 ^1-----^0\n")

    if IsLinux then
        print("\nVORP CORE Running on Linux, thanks for using VorpCore");
    end
end

ScriptList = {}
Changelogs = 0

Citizen.CreateThread(function()

    local Resources = GetNumResources()

    for i = 0, Resources, 1 do
        local resource = GetResourceByFindIndex(i)
        UpdateChecker(resource)
    end



    if next(ScriptList) ~= nil then
        init_core()
        Checker()

    end

end)

function UpdateChecker(resource)
    if resource and GetResourceState(resource) == 'started' then
        if GetResourceMetadata(resource, 'vorp_checker', 0) == 'yes' then

            local Name = GetResourceMetadata(resource, 'vorp_name', 0)
            local Github = GetResourceMetadata(resource, 'vorp_github', 0)
            local Version = GetResourceMetadata(resource, 'vorp_version', 0)
            local Changelog, GithubL, NewestVersion

            Script = {}

            Script['Resource'] = resource
            if Version == nil then
                Version = GetResourceMetadata(resource, 'version', 0)
            end
            if Name ~= nil then
                Script['Name'] = Name
            else
                resource = resource:upper()
                Script['Name'] = '^6' .. resource
            end
            if string.find(Github, "github") then
                if string.find(Github, "github.com") then
                    Script['Github'] = Github
                    Github = string.gsub(Github, "github", "raw.githubusercontent") .. '/master/version'
                else
                    GithubL = string.gsub(Github, "raw.githubusercontent", "github"):gsub("/master", "")
                    Github = Github .. '/version'
                    Script['Github'] = GithubL
                end
            else
                Script['Github'] = Github .. '/version'
            end
            PerformHttpRequest(Github, function(Error, V, Header)
                NewestVersion = V
            end)
            repeat
                Citizen.Wait(10)
            until NewestVersion ~= nil
            local _, strings = string.gsub(NewestVersion, "\n", "\n")
            Version1 = NewestVersion:match("[^\n]*"):gsub("[<>]", "")
            if string.find(Version1, Version) then
            else
                if strings > 0 then
                    Changelog = NewestVersion:gsub(Version1, ""):match("%<.*" .. Version .. ">"):gsub(Version, "")
                    Changelog = string.gsub(Changelog, "\n", "")
                    Changelog = string.gsub(Changelog, "-", " \n-"):gsub("%b<>", ""):sub(1, -2)
                    NewestVersion = Version1
                end
            end
            if Changelog ~= nil then
                Script['CL'] = true
            end
            Script['NewestVersion'] = Version1
            Script['Version'] = Version
            Script['Changelog'] = Changelog
            table.insert(ScriptList, Script)
        end
    end
end

function Checker()

    print("^3VORPcore Version check ")
    print("^2Resources found")
    print('')
    for i, v in pairs(ScriptList) do
        if string.find(v.NewestVersion, v.Version) then
            print('^4' .. v.Name .. ' (' .. v.Resource .. ') ^2✅ ' .. 'Up to date - Version ' .. v.Version .. '^0')
        else
            print('^4' .. v.Name .. ' (' .. v.Resource .. ') ^1❌ ' .. 'Outdated (v' .. v.Version .. ') ^5- Update found: Version ' .. v.NewestVersion .. ' ^0(' .. v.Github .. ')')
        end

        if v.CL then
            Changelogs = Changelogs + 1
        end
    end

    if Changelogs > 0 then
        print('^1###############################')
        Changelog()

    else
        print('^0###############################################################################')
    end
end

function Changelog()

    print('')
    for i, v in pairs(ScriptList) do
        if v.Version ~= v.NewestVersion then
            if v.CL then
                print('^3' .. v.Resource:upper() .. ' - Changelog:')
                print('^0' .. v.Changelog)
                print('^1###############################^0')
            end
        end
    end
    print('^0###############################################################################')

end
