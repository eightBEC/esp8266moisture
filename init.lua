FileToExecute="moisture.lua"
l = file.list()
for k,v in pairs(l) do
  if k == FileToExecute then
    tmr.alarm(0, 2000, 0, function()
      print("Executing ".. FileToExecute)
      dofile(FileToExecute)
    end)
  end
end
