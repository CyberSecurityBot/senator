antiarabic = {}-- An empty table for solving multiple kicking problem

do
local function run(msg, matches)
  if is_momod(msg) then -- Ignore mods,owner,admins
    return
  end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)]['settings']['lock_arabic'] then
    if data[tostring(msg.to.id)]['settings']['lock_arabic'] == 'yes' then
	  if is_whitelisted(msg.from.id) then
		return
	  end
      if antiarabic[msg.from.id] == true then 
        return
      end
	  if msg.to.type == 'chat' then
		local receiver = get_receiver(msg)
		local username = msg.from.username
		local name = msg.from.first_name
		if username and is_super_group(msg) then
			send_large_msg(receiver , "<b>Arabic/Persian</b> is not Allowed here\n@"..username.."["..msg.from.id.."]\nStatus: User Kicked/Msg deleted")
		else
			send_large_msg(receiver , "<b>Arabic/Persian</b> is not Allowed here\nName: "..name.."["..msg.from.id.."]\nStatus: User Kicked/Msg deleted")
		end
		local name = user_print_name(msg.from)
		savelog(msg.to.id, name.." ["..msg.from.id.."] Kicked <b>(Arabic not Allowed)</b> ")
		local chat_id = msg.to.id
		local user_id = msg.from.id
			kick_user(user_id, chat_id)
		end
		antiarabic[msg.from.id] = true
    end
  end
  return
end

local function cron()
  antiarabic = {} -- Clear antiarabic table 
end

return {
  patterns = {
    "([\216-\219][\128-\191])"
    },
  run = run,
  cron = cron
}

end
