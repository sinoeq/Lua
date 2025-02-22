-- Biblioteka do obsługi HTTP
local http = require("socket.http") -- lub "http" w zależności od środowiska

-- Adres webhooka Discorda
local webhook_url = "https://discord.com/api/webhooks/1340470833570779348/RmlBy005W3vh9ns7dps5VUstqWQW5xLsZNIyohPlgJBsMW7IaopQOL0TwXAbBPtCmpAw "

-- Funkcja do pobrania publicznego IP
function getPublicIP()
    local response, _, _ = http.request("http://api.ipify.org/")
    return response
end

-- Funkcja do wysyłania IP do Discorda
function sendToDiscord(ip)
    local data = {
        content = "Publiczne IP: " .. ip
    }
    
    -- Konwertowanie danych do formatu JSON
    local json = require("cjson").encode(data)
    
    -- Wysyłanie zapytania POST do webhooka Discorda
    local response, status, headers = http.request{
        url = webhook_url,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#json)
        },
        source = ltn12.source.string(json),
        sink = ltn12.sink.table(response)
    }

    -- Sprawdzanie, czy zapytanie zostało wykonane poprawnie
    if status == 200 then
        print("IP wysłane pomyślnie na Discorda.")
    else
        print("Błąd podczas wysyłania IP. Status: " .. status)
    end
end

-- Pobranie publicznego IP i wysłanie do Discorda
local ip = getPublicIP()
sendToDiscord(ip)
