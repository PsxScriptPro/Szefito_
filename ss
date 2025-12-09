local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local KeyLink = "https://work.ink/4uN/test"
local SaveName = "workink_keysystem.json"

setclipboard(KeyLink)

-- helpers
local HttpService = game:GetService("HttpService")
local function loadSave()
    if isfile(SaveName) then
        return HttpService:JSONDecode(readfile(SaveName))
    end
    return nil
end

local function saveKey(key)
    local data = {
        key = key,
        date = os.date("%d-%m-%Y") -- dd-mm-yyyy
    }
    writefile(SaveName, HttpService:JSONEncode(data))
end

local function clearSave()
    if isfile(SaveName) then
        delfile(SaveName)
    end
end

local function verifyKey(key)
    local url = "https://work.ink/_api/v2/token/isValid/" .. key
    local requestFunc = syn and syn.request or request or http_request

    local result = requestFunc({
        Url = url,
        Method = "GET"
    })

    local decoded
    pcall(function()
        decoded = HttpService:JSONDecode(result.Body)
    end)

    return decoded and decoded.valid == true
end

local Window = Rayfield:CreateWindow({
    Name = "Key System",
    LoadingTitle = "Verification",
    LoadingSubtitle = "Work.Ink",
    KeySystem = false
})

local KeyPage = Window:CreateTab("Key Login", 4483362458)

local UserKey = ""

KeyPage:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Paste your key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        UserKey = text
    end
})

KeyPage:CreateButton({
    Name = "Copy Key Link",
    Callback = function()
        setclipboard(KeyLink)
        Rayfield:Notify({
            Title = "Copied!",
            Content = "Key link copied!",
            Duration = 3
        })
    end
})

KeyPage:CreateButton({
    Name = "Verify Key",
    Callback = function()
        if UserKey == "" then
            Rayfield:Notify({
                Title = "Error",
                Content = "You must enter a key!",
                Duration = 3
            })
            return
        end

        if verifyKey(UserKey) then
            Rayfield:Notify({
                Title = "Success",
                Content = "Key accepted!",
                Duration = 3
            })

            saveKey(UserKey)

            task.wait(1)
            Rayfield:Destroy()


            loadstring(game:HttpGet("https://rawscripts.net/raw/The-Forge-BETA-FourHub-No-Key-AutoMine-AutoFarm-SellAll-Teleporter-73168"))()

        else
            Rayfield:Notify({
                Title = "Invalid",
                Content = "Key is incorrect!",
                Duration = 3
            })
        end
    end
})

task.delay(1, function()
    local saved = loadSave()

    if saved and saved.key and saved.date then
        local today = os.date("%d-%m-%Y")

        if saved.date == today then

            if verifyKey(saved.key) then
                Rayfield:Notify({
                    Title = "Auto Login",
                    Content = "Using saved key!",
                    Duration = 3
                })

                task.wait(1)
                Rayfield:Destroy()

                loadstring(game:HttpGet("https://rawscripts.net/raw/The-Forge-BETA-FourHub-No-Key-AutoMine-AutoFarm-SellAll-Teleporter-73168"))()

                return
            else
                clearSave()
            end
        else
            -- outdated
            clearSave()
        end
    end
end)
