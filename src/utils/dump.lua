local function recursive_tostring(o)
   if type(o) == 'table' then
      local s = '{'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then 
            k = '"'..k..'"'
         end
         s = s .. '['..k..'] = ' .. recursive_tostring(v) .. ','
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

return function(o, ret)
   if not debug then return end

   if ret then 
      return recursive_tostring(o) 
   else 
      print(recursive_tostring(o)) 
   end
end