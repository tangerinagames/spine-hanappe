local system = {}

system.ResourceDirectory = MOAIFileSystem.getWorkingDirectory()

function system.pathForFile(fileName, base)
  return base .. fileName
end

return system
