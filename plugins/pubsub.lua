local subscriptions = {}

PubSub = {}

PubSub.purge = function()
	subscriptions = {}
end

PubSub.publish = function(name, payload)
	local subs = subscriptions[name]
	if not subs then
		return
	end
	for _, fn in pairs(subs) do
		fn(payload)
	end
end

PubSub.subscribe = function(name, fn)
	if not subscriptions[name] then
		subscriptions[name] = {}
	end
	table.insert(subscriptions[name], fn)
end

return PubSub
