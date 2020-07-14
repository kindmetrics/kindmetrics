require "baked_file_system"

class JavascriptStorage
  extend BakedFileSystem

  bake_folder "../src/js"
end
